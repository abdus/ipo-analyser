import re
from datetime import date, datetime
from urllib.parse import urljoin
from zoneinfo import ZoneInfo

import httpx
from bs4 import BeautifulSoup

from ipo_analyser.sources.base import (
    GMPPoint,
    IPORecord,
    canonical_slug,
    clean_name,
    decimal_from_text,
)

IST = ZoneInfo("Asia/Kolkata")


class IPOCrackerSource:
    name = "ipocracker"
    base_url = "https://ipocracker.com"
    url = f"{base_url}/ipo-gmp"

    def __init__(self, client: httpx.AsyncClient):
        self.client = client

    async def collect(self) -> list[IPORecord]:
        response = await self.client.get(self.url)
        response.raise_for_status()
        return self.parse(response.text)

    @classmethod
    def parse(cls, html: str, now: datetime | None = None) -> list[IPORecord]:
        now = now or datetime.now(IST)
        soup = BeautifulSoup(html, "html.parser")
        records: list[IPORecord] = []
        for row in soup.select("#gmp-table tbody tr[data-name]"):
            cells = row.find_all("td", recursive=False)
            if len(cells) < 7:
                continue
            link = row.select_one("td a[href]")
            raw_name = link.get_text(" ", strip=True) if link else row.get("data-name", "")
            name = clean_name(raw_name)
            source_url = urljoin(cls.base_url, link.get("href", "")) if link else cls.url
            price_values = re.findall(r"\d[\d,]*(?:\.\d+)?", cells[2].get_text(" ", strip=True))
            prices = [decimal_from_text(value) for value in price_values]
            premium_text = cells[1].get_text(" ", strip=True)
            premium = decimal_from_text(premium_text) if "₹" in premium_text else None
            observed_at = _updated_at(cells[6].get_text(" ", strip=True), now)
            record = IPORecord(
                name=name,
                slug=canonical_slug(name),
                segment=row.get("data-type", "unknown").lower(),
                status=row.get("data-status", "unknown").lower(),
                price_lower=prices[0] if prices else None,
                price_upper=prices[-1] if prices else None,
                open_date=_short_date(cells[3].get_text(" ", strip=True), now.date()),
                close_date=_short_date(cells[4].get_text(" ", strip=True), now.date()),
            )
            if premium is not None:
                record.gmp.append(GMPPoint(observed_at, premium, source_url))
            records.append(record)
        return records


def _updated_at(value: str, fallback: datetime) -> datetime:
    for fmt in ("%d %b, %I:%M %p %Y", "%d %b, %H:%M %Y"):
        try:
            return datetime.strptime(f"{value} {fallback.year}", fmt).replace(tzinfo=IST)
        except ValueError:
            pass
    return fallback


def _short_date(value: str, reference: date) -> date | None:
    if not value or value in {"-", "–", "—"}:
        return None
    for year in (reference.year, reference.year + 1, reference.year - 1):
        try:
            parsed = datetime.strptime(f"{value} {year}", "%b %d %Y").date()
        except ValueError:
            continue
        if abs((parsed - reference).days) <= 200:
            return parsed
    return None
