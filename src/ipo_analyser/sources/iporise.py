import asyncio
import re
from datetime import date, datetime, time
from urllib.parse import urljoin
from zoneinfo import ZoneInfo

import httpx
from bs4 import BeautifulSoup, Tag

from ipo_analyser.sources.base import (
    GMPPoint,
    IPORecord,
    SubscriptionRecord,
    canonical_slug,
    clean_name,
    decimal_from_text,
)

IST = ZoneInfo("Asia/Kolkata")


class IPORiseSource:
    name = "iporise"
    base_url = "https://www.iporise.com"
    list_url = f"{base_url}/gmp"

    def __init__(self, client: httpx.AsyncClient):
        self.client = client

    async def collect(
        self, max_details: int = 20
    ) -> tuple[list[IPORecord], list[SubscriptionRecord]]:
        response = await self.client.get(self.list_url)
        response.raise_for_status()
        records = self.parse_list(response.text)
        detail_records = [record for record in records if record.gmp][:max_details]
        semaphore = asyncio.Semaphore(4)
        subscriptions: list[SubscriptionRecord] = []

        async def load_history(record: IPORecord) -> None:
            detail_url = record.gmp[0].source_url
            async with semaphore:
                try:
                    detail = await self.client.get(detail_url)
                    detail.raise_for_status()
                    history = self.parse_history(detail.text, detail_url)
                    if history:
                        record.gmp = history
                except httpx.HTTPError:
                    return

        async def load_subscriptions(record: IPORecord) -> None:
            detail_url = record.gmp[0].source_url
            subscription_url = re.sub(r"/gmp/?$", "/subscription", detail_url)
            async with semaphore:
                try:
                    detail = await self.client.get(subscription_url)
                    detail.raise_for_status()
                    subscriptions.extend(
                        self.parse_subscription_history(
                            detail.text,
                            subscription_url,
                            record.name,
                            record.slug,
                            record.segment,
                            record.status,
                        )
                    )
                except httpx.HTTPError:
                    return

        await asyncio.gather(
            *(load_history(record) for record in detail_records),
            *(load_subscriptions(record) for record in detail_records),
        )
        return records, subscriptions

    @classmethod
    def parse_list(cls, html: str, now: datetime | None = None) -> list[IPORecord]:
        now = now or datetime.now(IST)
        soup = BeautifulSoup(html, "html.parser")
        records: list[IPORecord] = []
        for row in soup.select("#gmpTbody > tr[data-name]"):
            cells = row.find_all("td", recursive=False)
            if len(cells) < 9:
                continue
            raw_name = row.get("data-name", "")
            name = clean_name(raw_name.title())
            onclick = row.get("onclick", "")
            url_match = re.search(r"window\.location='([^']+)'", onclick)
            detail_url = urljoin(cls.base_url, url_match.group(1)) if url_match else cls.list_url
            price = decimal_from_text(cells[2].get_text(" ", strip=True))
            gmp_cell = cells[1].get_text(" ", strip=True)
            premium = decimal_from_text(row.get("data-gmp")) if "₹" in gmp_cell else None
            record = IPORecord(
                name=name,
                slug=canonical_slug(name),
                segment=row.get("data-seg", "unknown").lower(),
                status=_status(row.get("data-status", "unknown")),
                price_lower=price,
                price_upper=price,
                open_date=_short_date(cells[6].get_text(strip=True), now.date()),
                close_date=_short_date(cells[7].get_text(strip=True), now.date()),
                listing_date=_short_date(cells[8].get_text(strip=True), now.date()),
            )
            if premium is not None:
                record.gmp.append(GMPPoint(now, premium, detail_url))
            records.append(record)
        return records

    @staticmethod
    def parse_history(html: str, source_url: str) -> list[GMPPoint]:
        soup = BeautifulSoup(html, "html.parser")
        heading = soup.find(
            lambda tag: (
                isinstance(tag, Tag) and tag.name == "h2" and "GMP History" in tag.get_text()
            )
        )
        table = heading.find_next("table") if heading else None
        if table is None:
            return []
        points: list[GMPPoint] = []
        for row in table.select("tbody tr"):
            cells = row.find_all("td", recursive=False)
            if len(cells) < 2:
                continue
            observed = _history_datetime(cells[0].get_text(" ", strip=True))
            premium = decimal_from_text(cells[1].get_text(" ", strip=True))
            if observed is not None and premium is not None:
                points.append(GMPPoint(observed, premium, source_url))
        return points

    @staticmethod
    def parse_subscription_history(
        html: str,
        source_url: str,
        ipo_name: str,
        ipo_slug: str,
        segment: str = "unknown",
        status: str = "unknown",
    ) -> list[SubscriptionRecord]:
        soup = BeautifulSoup(html, "html.parser")
        heading = soup.find(
            lambda tag: (
                isinstance(tag, Tag)
                and tag.name == "h2"
                and "Day-wise Subscription History" in tag.get_text()
            )
        )
        container = heading.parent.find_next_sibling("div") if heading and heading.parent else None
        if container is None:
            return []

        records: list[SubscriptionRecord] = []
        for details in container.find_all("details", recursive=False):
            summary = details.find("summary")
            observed_at = _subscription_datetime(
                summary.get_text(" ", strip=True) if summary else ""
            )
            table = details.find("table")
            if observed_at is None or table is None:
                continue
            values: dict[str, object] = {"qib": None, "nii": None, "retail": None, "total": None}
            for row in table.select("tbody tr"):
                cells = row.find_all("td", recursive=False)
                if len(cells) < 4:
                    continue
                category = cells[0].get_text(" ", strip=True).lower()
                key = (
                    "qib"
                    if category == "qib"
                    else "nii"
                    if category == "nii"
                    else "retail"
                    if category in {"retail", "individual investors"}
                    else "total"
                    if category == "total"
                    else None
                )
                if key:
                    values[key] = decimal_from_text(cells[3].get_text(" ", strip=True))
            records.append(
                SubscriptionRecord(
                    ipo_name=ipo_name,
                    ipo_slug=ipo_slug,
                    observed_at=observed_at,
                    qib=values["qib"],
                    nii=values["nii"],
                    retail=values["retail"],
                    total=values["total"],
                    source_url=source_url,
                    segment=segment,
                    status=status,
                )
            )
        return records


def _short_date(value: str, reference: date) -> date | None:
    if not value or value in {"-", "–", "—"}:
        return None
    for year in (reference.year, reference.year + 1, reference.year - 1):
        try:
            parsed = datetime.strptime(f"{value} {year}", "%d %b %Y").date()
        except ValueError:
            continue
        if abs((parsed - reference).days) <= 200:
            return parsed
    return None


def _history_datetime(value: str) -> datetime | None:
    value = re.sub(r"\s+", " ", value).strip()
    for fmt in ("%b %d, %Y %I:%M %p", "%b %d, %Y"):
        try:
            return datetime.strptime(value, fmt).replace(tzinfo=IST)
        except ValueError:
            pass
    return None


def _status(value: str) -> str:
    normalized = value.lower()
    return "open" if normalized in {"live", "ongoing"} else normalized


def _subscription_datetime(value: str) -> datetime | None:
    match = re.search(r"(?:Mon|Tue|Wed|Thu|Fri|Sat|Sun), [A-Z][a-z]{2} \d{2}, \d{4}", value)
    if not match:
        return None
    try:
        day = datetime.strptime(match.group(0), "%a, %b %d, %Y").date()
        return datetime.combine(day, time(18, 0), tzinfo=IST)
    except ValueError:
        return None
