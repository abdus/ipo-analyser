import re
from datetime import datetime
from zoneinfo import ZoneInfo

import httpx
from bs4 import BeautifulSoup

from ipo_analyser.sources.base import (
    GMPPoint,
    IPORecord,
    SubscriptionRecord,
    canonical_slug,
    clean_name,
    decimal_from_text,
)

IST = ZoneInfo("Asia/Kolkata")


class IPOGramSource:
    name = "ipogram"
    url = "https://ipogram.in/"

    def __init__(self, client: httpx.AsyncClient):
        self.client = client

    async def collect(self) -> tuple[list[IPORecord], list[SubscriptionRecord]]:
        response = await self.client.get(self.url)
        response.raise_for_status()
        return self.parse(response.text)

    @classmethod
    def parse(
        cls, html: str, now: datetime | None = None
    ) -> tuple[list[IPORecord], list[SubscriptionRecord]]:
        now = now or datetime.now(IST)
        soup = BeautifulSoup(html, "html.parser")
        ipos: list[IPORecord] = []
        for row in soup.select("table.ipg3-tbl tbody tr[data-n][data-gmp]"):
            raw_name = row.get("data-n", "")
            name = clean_name(raw_name.title())
            premium = decimal_from_text(row.get("data-gmp"))
            cells = row.find_all("td", recursive=False)
            listing_price = (
                decimal_from_text(cells[3].get_text(" ", strip=True)) if len(cells) > 3 else None
            )
            issue_price = (
                listing_price - premium
                if listing_price is not None and premium is not None
                else None
            )
            link = row.select_one("a.ipg3-name")
            source_url = link.get("href", cls.url) if link else cls.url
            observed = _row_timestamp(row.get_text(" ", strip=True), now)
            record = IPORecord(
                name=name,
                slug=canonical_slug(name),
                segment=row.get("data-c", "unknown").lower(),
                status=row.get("data-s", "unknown").lower(),
                price_lower=issue_price,
                price_upper=issue_price,
                open_date=_unix_date(row.get("data-open-ts")),
                close_date=_unix_date(row.get("data-close-ts")),
                listing_date=_unix_date(row.get("data-listing-ts")),
            )
            if premium is not None:
                record.gmp.append(GMPPoint(observed, premium, source_url))
            ipos.append(record)

        subscriptions: list[SubscriptionRecord] = []
        for row in soup.select("table.ipg3-sub-tbl tbody tr"):
            cells = row.find_all("td", recursive=False)
            link = row.select_one("a.ipg3-sub-link")
            if link is None or len(cells) < 5:
                continue
            name = clean_name(
                re.sub(r"IPO Subscription Status$", "", link.get_text(" ", strip=True))
            )
            subscriptions.append(
                SubscriptionRecord(
                    ipo_name=name,
                    ipo_slug=canonical_slug(name),
                    observed_at=now,
                    total=decimal_from_text(cells[1].get_text(" ", strip=True)),
                    qib=decimal_from_text(cells[2].get_text(" ", strip=True)),
                    nii=decimal_from_text(cells[3].get_text(" ", strip=True)),
                    retail=decimal_from_text(cells[4].get_text(" ", strip=True)),
                    source_url=link.get("href", cls.url),
                    segment=row.get("data-sc", "unknown").lower(),
                    status=row.get("data-ss", "unknown").lower(),
                )
            )
        return ipos, subscriptions


def _unix_date(value: str | None):
    if not value:
        return None
    try:
        return datetime.fromtimestamp(int(value), tz=IST).date()
    except (TypeError, ValueError, OSError):
        return None


def _row_timestamp(value: str, fallback: datetime) -> datetime:
    match = re.search(r"(\d{1,2} [A-Z][a-z]{2} \d{1,2}:\d{2} [AP]M) IST", value)
    if not match:
        return fallback
    try:
        parsed = datetime.strptime(f"{match.group(1)} {fallback.year}", "%d %b %I:%M %p %Y")
        return parsed.replace(tzinfo=IST)
    except ValueError:
        return fallback
