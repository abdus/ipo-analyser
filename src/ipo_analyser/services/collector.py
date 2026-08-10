import asyncio
from dataclasses import dataclass, field
from datetime import UTC, datetime

import httpx
from sqlalchemy import select
from sqlalchemy.orm import Session

from ipo_analyser.config import Settings
from ipo_analyser.models import IPO, GMPObservation, MarketObservation, SubscriptionObservation
from ipo_analyser.sources.base import IPORecord, MarketPoint, SubscriptionRecord
from ipo_analyser.sources.ipocracker import IPOCrackerSource
from ipo_analyser.sources.ipogram import IPOGramSource
from ipo_analyser.sources.iporise import IPORiseSource
from ipo_analyser.sources.yahoo import YahooMarketSource


@dataclass(slots=True)
class CollectionReport:
    ipos_seen: int = 0
    gmp_added: int = 0
    subscriptions_added: int = 0
    market_points_added: int = 0
    errors: list[str] = field(default_factory=list)


async def collect_all(session: Session, settings: Settings) -> CollectionReport:
    report = CollectionReport()
    timeout = httpx.Timeout(settings.http_timeout_seconds)
    headers = {
        "User-Agent": settings.user_agent,
        "Accept": "text/html,application/json;q=0.9,*/*;q=0.8",
    }
    async with httpx.AsyncClient(timeout=timeout, headers=headers, follow_redirects=True) as client:
        jobs = [
            IPORiseSource(client).collect(settings.max_detail_fetches),
            IPOGramSource(client).collect(),
            IPOCrackerSource(client).collect(),
            YahooMarketSource(client).collect(),
        ]
        results = await asyncio.gather(*jobs, return_exceptions=True)

    iporise_result, ipogram_result, ipocracker_result, market_result = results
    if isinstance(iporise_result, Exception):
        report.errors.append(f"IPORise: {iporise_result}")
    else:
        ipos, subscriptions = iporise_result
        _store_ipos(session, ipos, IPORiseSource.name, report)
        _store_subscriptions(session, subscriptions, IPORiseSource.name, report)

    if isinstance(ipogram_result, Exception):
        report.errors.append(f"IPOGram: {ipogram_result}")
    else:
        ipos, subscriptions = ipogram_result
        _store_ipos(session, ipos, IPOGramSource.name, report)
        _store_subscriptions(session, subscriptions, IPOGramSource.name, report)

    if isinstance(ipocracker_result, Exception):
        report.errors.append(f"IPO Cracker: {ipocracker_result}")
    else:
        _store_ipos(session, ipocracker_result, IPOCrackerSource.name, report)

    if isinstance(market_result, Exception):
        report.errors.append(f"Yahoo Finance: {market_result}")
    else:
        _store_market(session, market_result, YahooMarketSource.name, report)

    session.commit()
    return report


def _store_ipos(
    session: Session, records: list[IPORecord], source: str, report: CollectionReport
) -> None:
    for record in records:
        if not record.slug:
            continue
        report.ipos_seen += 1
        ipo = _find_ipo(session, record.slug)
        if ipo is None:
            ipo = IPO(slug=record.slug, name=record.name)
            session.add(ipo)
            session.flush()
        ipo.name = record.name or ipo.name
        ipo.segment = _prefer(record.segment, ipo.segment)
        ipo.status = _prefer(record.status, ipo.status)
        ipo.price_lower = record.price_lower if record.price_lower is not None else ipo.price_lower
        ipo.price_upper = record.price_upper if record.price_upper is not None else ipo.price_upper
        ipo.lot_size = record.lot_size if record.lot_size is not None else ipo.lot_size
        ipo.open_date = record.open_date or ipo.open_date
        ipo.close_date = record.close_date or ipo.close_date
        ipo.listing_date = record.listing_date or ipo.listing_date
        ipo.updated_at = datetime.now(UTC)
        for point in record.gmp:
            observed_at = _utc(point.observed_at)
            exists = session.scalar(
                select(GMPObservation.id).where(
                    GMPObservation.ipo_id == ipo.id,
                    GMPObservation.source == source,
                    GMPObservation.observed_at == observed_at,
                )
            )
            if exists is None:
                session.add(
                    GMPObservation(
                        ipo_id=ipo.id,
                        source=source,
                        observed_at=observed_at,
                        premium=point.premium,
                        source_url=point.source_url,
                    )
                )
                report.gmp_added += 1


def _store_subscriptions(
    session: Session,
    records: list[SubscriptionRecord],
    source: str,
    report: CollectionReport,
) -> None:
    for record in records:
        ipo = _find_ipo(session, record.ipo_slug)
        if ipo is None:
            ipo = IPO(
                slug=record.ipo_slug,
                name=record.ipo_name,
                segment=record.segment,
                status=record.status,
            )
            session.add(ipo)
            session.flush()
        else:
            ipo.segment = _prefer(record.segment, ipo.segment)
            ipo.status = _prefer(record.status, ipo.status)
        observed_at = _utc(record.observed_at)
        exists = session.scalar(
            select(SubscriptionObservation.id).where(
                SubscriptionObservation.ipo_id == ipo.id,
                SubscriptionObservation.source == source,
                SubscriptionObservation.observed_at == observed_at,
            )
        )
        if exists is None:
            session.add(
                SubscriptionObservation(
                    ipo_id=ipo.id,
                    source=source,
                    observed_at=observed_at,
                    qib=record.qib,
                    nii=record.nii,
                    retail=record.retail,
                    total=record.total,
                    source_url=record.source_url,
                )
            )
            report.subscriptions_added += 1


def _store_market(
    session: Session, points: list[MarketPoint], source: str, report: CollectionReport
) -> None:
    for point in points:
        observed_at = _utc(point.observed_at)
        exists = session.scalar(
            select(MarketObservation.id).where(
                MarketObservation.index_name == point.index_name,
                MarketObservation.source == source,
                MarketObservation.observed_at == observed_at,
            )
        )
        if exists is None:
            session.add(
                MarketObservation(
                    index_name=point.index_name,
                    source=source,
                    observed_at=observed_at,
                    value=point.value,
                    percent_change=point.percent_change,
                    source_url=point.source_url,
                )
            )
            report.market_points_added += 1


def _prefer(candidate: str, existing: str) -> str:
    return candidate if candidate and candidate != "unknown" else existing


def _find_ipo(session: Session, slug: str) -> IPO | None:
    exact = session.scalar(select(IPO).where(IPO.slug == slug))
    if exact is not None:
        return exact
    target_tokens = set(slug.split("-"))
    if len(target_tokens) < 2:
        return None
    candidates: list[tuple[float, IPO]] = []
    for ipo in session.scalars(select(IPO)).all():
        candidate_tokens = set(ipo.slug.split("-"))
        if min(len(target_tokens), len(candidate_tokens)) < 2:
            continue
        if target_tokens <= candidate_tokens or candidate_tokens <= target_tokens:
            union = target_tokens | candidate_tokens
            candidates.append((len(target_tokens & candidate_tokens) / len(union), ipo))
    candidates.sort(key=lambda item: item[0], reverse=True)
    if not candidates or (len(candidates) > 1 and candidates[0][0] == candidates[1][0]):
        return None
    return candidates[0][1]


def _utc(value: datetime) -> datetime:
    if value.tzinfo is None:
        return value.replace(tzinfo=UTC)
    return value.astimezone(UTC)
