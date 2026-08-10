import re
import unicodedata
from dataclasses import dataclass, field
from datetime import date, datetime
from decimal import Decimal


@dataclass(slots=True)
class GMPPoint:
    observed_at: datetime
    premium: Decimal
    source_url: str


@dataclass(slots=True)
class IPORecord:
    name: str
    slug: str
    segment: str = "unknown"
    status: str = "unknown"
    price_lower: Decimal | None = None
    price_upper: Decimal | None = None
    lot_size: int | None = None
    open_date: date | None = None
    close_date: date | None = None
    listing_date: date | None = None
    gmp: list[GMPPoint] = field(default_factory=list)


@dataclass(slots=True)
class SubscriptionRecord:
    ipo_name: str
    ipo_slug: str
    observed_at: datetime
    qib: Decimal | None
    nii: Decimal | None
    retail: Decimal | None
    total: Decimal | None
    source_url: str
    segment: str = "unknown"
    status: str = "unknown"


@dataclass(slots=True)
class MarketPoint:
    index_name: str
    observed_at: datetime
    value: Decimal
    percent_change: Decimal | None
    source_url: str


def canonical_slug(value: str) -> str:
    normalized = unicodedata.normalize("NFKD", value).encode("ascii", "ignore").decode()
    normalized = normalized.lower().replace("&", " and ")
    normalized = re.sub(r"\b(ipo|limited|ltd|gmp|subscription|status)\b", " ", normalized)
    return re.sub(r"[^a-z0-9]+", "-", normalized).strip("-")


def clean_name(value: str) -> str:
    value = re.sub(r"\s+", " ", value).strip()
    return re.sub(r"\s+IPO(?:\s+GMP)?$", "", value, flags=re.IGNORECASE).strip()


def decimal_from_text(value: str | None) -> Decimal | None:
    if not value or value.strip() in {"-", "–", "—", "N/A", "NA"}:
        return None
    match = re.search(r"[-+]?\d[\d,]*(?:\.\d+)?", value)
    return Decimal(match.group(0).replace(",", "")) if match else None
