from collections import defaultdict
from dataclasses import asdict, dataclass
from datetime import UTC, date, datetime, timedelta
from decimal import Decimal
from statistics import fmean

from sqlalchemy import select
from sqlalchemy.orm import Session

from ipo_analyser.models import IPO, GMPObservation, MarketObservation, SubscriptionObservation

TREND_WINDOW_DAYS = 7
SUBSCRIPTION_SOURCE_PRIORITY = {"iporise": 2, "ipogram": 1}


@dataclass(slots=True)
class ScoreComponent:
    key: str
    label: str
    points: float
    maximum: float
    detail: str
    available: bool = True


@dataclass(slots=True)
class MarketIndexView:
    name: str
    value: float
    day_change: float | None
    seven_day_change: float | None


def build_market_view(session: Session) -> dict:
    rows = session.scalars(
        select(MarketObservation).order_by(
            MarketObservation.index_name, MarketObservation.observed_at.desc()
        )
    ).all()
    grouped: dict[str, list[MarketObservation]] = defaultdict(list)
    for row in rows:
        grouped[row.index_name].append(row)

    indices: list[MarketIndexView] = []
    for name, values in grouped.items():
        latest = values[0]
        cutoff = _as_aware(latest.observed_at) - timedelta(days=7)
        older = next((item for item in values if _as_aware(item.observed_at) <= cutoff), values[-1])
        seven_day = _percent_change(latest.value, older.value) if older.id != latest.id else None
        indices.append(
            MarketIndexView(
                name=name,
                value=float(latest.value),
                day_change=_float_or_none(latest.percent_change),
                seven_day_change=seven_day,
            )
        )

    day_values = [item.day_change for item in indices if item.day_change is not None]
    week_values = [item.seven_day_change for item in indices if item.seven_day_change is not None]
    day_average = sum(day_values) / len(day_values) if day_values else None
    week_average = sum(week_values) / len(week_values) if week_values else None
    combined = (day_average or 0) + (week_average or 0) / 3
    sentiment = "positive" if combined > 0.6 else "weak" if combined < -0.6 else "neutral"
    return {
        "indices": [asdict(item) for item in sorted(indices, key=lambda item: item.name)],
        "day_average": day_average,
        "week_average": week_average,
        "sentiment_score": combined,
        "sentiment_rule": "positive above +0.60; weak below -0.60; otherwise neutral",
        "sentiment": sentiment,
    }


def list_snapshots(session: Session) -> list[dict]:
    market = build_market_view(session)
    ipos = session.scalars(
        select(IPO).order_by(IPO.open_date.asc().nullslast(), IPO.name.asc())
    ).all()
    snapshots = [build_snapshot(session, ipo, market) for ipo in ipos]
    status_order = {"open": 0, "upcoming": 1, "closed": 2, "listed": 3, "unknown": 4}
    snapshots.sort(
        key=lambda item: (
            status_order.get(item["status"], 4),
            -item["score"]["total"],
            item["name"],
        )
    )
    return snapshots


def build_snapshot(session: Session, ipo: IPO, market: dict | None = None) -> dict:
    market = market or build_market_view(session)
    gmp_rows = session.scalars(
        select(GMPObservation)
        .where(GMPObservation.ipo_id == ipo.id)
        .order_by(GMPObservation.observed_at.asc())
    ).all()
    subscription_rows = session.scalars(
        select(SubscriptionObservation)
        .where(SubscriptionObservation.ipo_id == ipo.id)
        .order_by(SubscriptionObservation.observed_at.asc())
    ).all()
    subscription = max(subscription_rows, key=_subscription_rank, default=None)
    subscription_history = _subscription_history(subscription_rows)
    subscription_chart = _subscription_line_chart(subscription_history)
    consensus = _gmp_consensus(gmp_rows)
    history = _daily_history(gmp_rows)
    source_history = _source_history(gmp_rows)
    history_chart = _line_chart(history, source_history)
    current_gmp = consensus["value"]
    price = _float_or_none(ipo.price_upper)
    implied_price = price + current_gmp if price is not None and current_gmp is not None else None
    gain_pct = current_gmp / price * 100 if price and current_gmp is not None else None
    delta_3d = _history_delta(history, 3, current_gmp)
    delta_7d = _history_delta(history, 7, current_gmp)
    trend_delta = delta_3d if delta_3d is not None else delta_7d
    threshold = max(1.0, abs(current_gmp or 0) * 0.03)
    trend = (
        "rising"
        if trend_delta is not None and trend_delta > threshold
        else "falling"
        if trend_delta is not None and trend_delta < -threshold
        else "flat"
    )
    subscription_view = (
        {
            "qib": _float_or_none(subscription.qib),
            "nii": _float_or_none(subscription.nii),
            "retail": _float_or_none(subscription.retail),
            "total": _float_or_none(subscription.total),
            "observed_at": _iso(subscription.observed_at),
            "source": subscription.source,
            "source_url": subscription.source_url,
        }
        if subscription
        else {"qib": None, "nii": None, "retail": None, "total": None}
    )
    has_subscription = any(
        subscription_view.get(key) is not None for key in ("qib", "nii", "retail", "total")
    )
    if has_subscription:
        subscription_state = "available"
        subscription_message = None
    elif ipo.open_date and ipo.open_date > date.today():
        subscription_state = "not_open"
        subscription_message = f"Subscription opens {ipo.open_date.strftime('%d %b %Y')}."
    else:
        subscription_state = "unavailable"
        subscription_message = "No category-wise subscription data has been published yet."
    score = _score(gain_pct, delta_7d, subscription_view, market, consensus)
    return {
        "slug": ipo.slug,
        "name": ipo.name,
        "segment": ipo.segment,
        "status": ipo.status,
        "price_lower": _float_or_none(ipo.price_lower),
        "price_upper": price,
        "lot_size": ipo.lot_size,
        "open_date": ipo.open_date.isoformat() if ipo.open_date else None,
        "close_date": ipo.close_date.isoformat() if ipo.close_date else None,
        "listing_date": ipo.listing_date.isoformat() if ipo.listing_date else None,
        "gmp": current_gmp,
        "gmp_sources": consensus["sources"],
        "gmp_agreement": consensus["agreement"],
        "gmp_observed_at": consensus["observed_at"],
        "history": history,
        "source_history": source_history,
        "history_chart": history_chart,
        "history_window_days": TREND_WINDOW_DAYS,
        "history_coverage_days": len(history),
        "delta_3d": delta_3d,
        "delta_7d": delta_7d,
        "trend": trend,
        "implied_listing_price": implied_price,
        "implied_gain": current_gmp,
        "implied_gain_pct": gain_pct,
        "subscription": subscription_view,
        "subscription_state": subscription_state,
        "subscription_message": subscription_message,
        "subscription_history": subscription_history,
        "subscription_chart": subscription_chart,
        "subscription_coverage_days": len(subscription_history),
        "market": market,
        "score": score,
    }


def _gmp_consensus(rows: list[GMPObservation]) -> dict:
    if not rows:
        return {"value": None, "sources": [], "agreement": "no data", "observed_at": None}
    latest_by_source: dict[str, GMPObservation] = {}
    for row in rows:
        current = latest_by_source.get(row.source)
        if current is None or _as_aware(row.observed_at) > _as_aware(current.observed_at):
            latest_by_source[row.source] = row
    newest = max(_as_aware(row.observed_at) for row in latest_by_source.values())
    fresh = {
        source: row
        for source, row in latest_by_source.items()
        if newest - _as_aware(row.observed_at) <= timedelta(hours=36)
    }
    values = [float(row.premium) for row in fresh.values()]
    value = float(fmean(values))
    if len(values) == 1:
        agreement = "single source"
    else:
        spread = max(values) - min(values)
        base = max(abs(value), 1)
        agreement = (
            "high" if spread <= max(2, base * 0.08) else "medium" if spread <= base * 0.2 else "low"
        )
    return {
        "value": value,
        "sources": [
            {
                "name": source,
                "value": float(row.premium),
                "observed_at": _iso(row.observed_at),
                "url": row.source_url,
            }
            for source, row in sorted(fresh.items())
        ],
        "agreement": agreement,
        "observed_at": _iso(newest),
    }


def _daily_history(rows: list[GMPObservation]) -> list[dict]:
    per_day_source: dict[tuple[date, str], GMPObservation] = {}
    for row in rows:
        day = _as_aware(row.observed_at).date()
        key = (day, row.source)
        current = per_day_source.get(key)
        if current is None or _as_aware(row.observed_at) > _as_aware(current.observed_at):
            per_day_source[key] = row
    if not per_day_source:
        return []
    sample_times: dict[date, datetime] = {}
    by_source: dict[str, list[GMPObservation]] = defaultdict(list)
    for (day, source), row in per_day_source.items():
        observed_at = _as_aware(row.observed_at)
        sample_times[day] = max(sample_times.get(day, observed_at), observed_at)
        by_source[source].append(row)

    latest_day = max(sample_times)
    cutoff = latest_day - timedelta(days=TREND_WINDOW_DAYS - 1)
    history = []
    for day, sample_time in sorted(sample_times.items()):
        if day < cutoff:
            continue
        values = []
        for observations in by_source.values():
            eligible = [
                row
                for row in observations
                if _as_aware(row.observed_at) <= sample_time
                and sample_time - _as_aware(row.observed_at) <= timedelta(hours=36)
            ]
            if eligible:
                latest = max(eligible, key=lambda row: _as_aware(row.observed_at))
                values.append(float(latest.premium))
        if values:
            history.append({"date": day.isoformat(), "gmp": float(fmean(values))})
    return history


def _source_history(rows: list[GMPObservation]) -> list[dict]:
    per_day_source: dict[tuple[date, str], GMPObservation] = {}
    for row in rows:
        day = _as_aware(row.observed_at).date()
        key = (day, row.source)
        current = per_day_source.get(key)
        if current is None or _as_aware(row.observed_at) > _as_aware(current.observed_at):
            per_day_source[key] = row
    if not per_day_source:
        return []

    latest_day = max(day for day, _source in per_day_source)
    cutoff = latest_day - timedelta(days=TREND_WINDOW_DAYS - 1)
    grouped: dict[str, list[tuple[date, GMPObservation]]] = defaultdict(list)
    for (day, source), row in per_day_source.items():
        if day >= cutoff:
            grouped[source].append((day, row))

    return [
        {
            "key": f"source-{index % 6}",
            "label": source,
            "url": max(values, key=lambda item: item[0])[1].source_url,
            "last": float(max(values, key=lambda item: item[0])[1].premium),
            "history": [
                {"date": day.isoformat(), "gmp": float(row.premium)} for day, row in sorted(values)
            ],
        }
        for index, (source, values) in enumerate(sorted(grouped.items()))
    ]


def _line_chart(history: list[dict], source_history: list[dict] | None = None) -> dict:
    if not history:
        return {"points": "", "area": "", "series": [], "x_labels": [], "y_ticks": []}

    left, right, top, bottom = 54.0, 706.0, 20.0, 218.0
    source_history = source_history or []
    values = [point["gmp"] for point in history]
    values.extend(point["gmp"] for series in source_history for point in series.get("history", []))
    raw_min, raw_max = min(values), max(values)
    span = raw_max - raw_min
    padding = max(span * 0.15, abs(raw_max) * 0.05, 1.0)
    chart_min = (
        min(0.0, raw_min - padding)
        if raw_min >= 0 and raw_min <= raw_max * 0.5
        else raw_min - padding
    )
    chart_max = raw_max + padding
    chart_span = chart_max - chart_min or 1.0
    window_end = date.fromisoformat(history[-1]["date"])
    window_start = window_end - timedelta(days=TREND_WINDOW_DAYS - 1)

    def coordinates_for(points_history: list[dict]) -> list[tuple[float, float]]:
        coordinates: list[tuple[float, float]] = []
        for point in points_history:
            point_day = date.fromisoformat(point["date"])
            ratio = (point_day - window_start).days / (TREND_WINDOW_DAYS - 1)
            x = left + ratio * (right - left)
            y = bottom - ((point["gmp"] - chart_min) / chart_span) * (bottom - top)
            coordinates.append((x, y))
        return coordinates

    coordinates = coordinates_for(history)

    points = " ".join(f"{x:.1f},{y:.1f}" for x, y in coordinates)
    first_x, _ = coordinates[0]
    last_x, _ = coordinates[-1]
    area = f"M {first_x:.1f} {bottom:.1f} L " + " L ".join(
        f"{x:.1f} {y:.1f}" for x, y in coordinates
    )
    area += f" L {last_x:.1f} {bottom:.1f} Z"

    label_count = TREND_WINDOW_DAYS
    x_labels = [
        {
            "x": left + index / (label_count - 1) * (right - left),
            "label": (window_start + timedelta(days=index)).strftime("%m-%d"),
        }
        for index in range(label_count)
    ]
    y_ticks = []
    for index in range(5):
        ratio = index / 4
        value = chart_max - ratio * chart_span
        y_ticks.append({"y": top + ratio * (bottom - top), "value": value})

    series = []
    for item in source_history:
        item_coordinates = coordinates_for(item["history"])
        series.append(
            {
                "key": item["key"],
                "label": item["label"],
                "url": item["url"],
                "last": item["last"],
                "points": " ".join(f"{x:.1f},{y:.1f}" for x, y in item_coordinates),
                "coordinates": [
                    {"x": x, "y": y, "date": point["date"], "gmp": point["gmp"]}
                    for point, (x, y) in zip(item["history"], item_coordinates, strict=True)
                ],
            }
        )

    series.append(
        {
            "key": "consensus",
            "label": "Consensus average",
            "url": None,
            "last": history[-1]["gmp"],
            "points": points,
            "coordinates": [
                {"x": x, "y": y, "date": point["date"], "gmp": point["gmp"]}
                for point, (x, y) in zip(history, coordinates, strict=True)
            ],
        }
    )

    return {
        "points": points,
        "area": area,
        "coordinates": [
            {
                "x": x,
                "y": y,
                "date": point["date"],
                "gmp": point["gmp"],
            }
            for point, (x, y) in zip(history, coordinates, strict=True)
        ],
        "series": series,
        "x_labels": x_labels,
        "y_ticks": y_ticks,
    }


def _history_delta(history: list[dict], days: int, current: float | None) -> float | None:
    if current is None or len(history) < 2:
        return None
    current_day = date.fromisoformat(history[-1]["date"])
    cutoff = current_day - timedelta(days=days)
    candidates = [point for point in history if date.fromisoformat(point["date"]) >= cutoff]
    if len(candidates) < 2:
        return None
    return current - candidates[0]["gmp"]


def _subscription_history(rows: list[SubscriptionObservation]) -> list[dict]:
    if not rows:
        return []
    per_day_source: dict[tuple[date, str], SubscriptionObservation] = {}
    for row in rows:
        day = _as_aware(row.observed_at).date()
        key = (day, row.source)
        current = per_day_source.get(key)
        if current is None or _as_aware(row.observed_at) > _as_aware(current.observed_at):
            per_day_source[key] = row

    grouped: dict[date, list[SubscriptionObservation]] = defaultdict(list)
    for (day, _source), row in per_day_source.items():
        grouped[day].append(row)
    latest_day = max(grouped)
    cutoff = latest_day - timedelta(days=TREND_WINDOW_DAYS - 1)
    history: list[dict] = []
    for day, observations in sorted(grouped.items()):
        if day < cutoff:
            continue
        selected = max(observations, key=_subscription_rank)
        point: dict = {"date": day.isoformat()}
        for key in ("qib", "nii", "retail", "total"):
            value = getattr(selected, key)
            point[key] = float(value) if value is not None else None
        history.append(point)
    return history


def _subscription_rank(row: SubscriptionObservation) -> tuple[int, datetime]:
    return (
        SUBSCRIPTION_SOURCE_PRIORITY.get(row.source, 0),
        _as_aware(row.observed_at),
    )


def _subscription_line_chart(history: list[dict]) -> dict:
    series_meta = (
        ("total", "Total"),
        ("qib", "QIB"),
        ("nii", "NII / HNI"),
        ("retail", "Retail"),
    )
    all_values = [
        point[key] for point in history for key, _label in series_meta if point.get(key) is not None
    ]
    if not all_values:
        return {"series": [], "x_labels": [], "y_ticks": []}

    left, right, top, bottom = 54.0, 706.0, 20.0, 218.0
    chart_max = max(max(all_values) * 1.12, 1.0)
    window_end = date.fromisoformat(history[-1]["date"])
    window_start = window_end - timedelta(days=TREND_WINDOW_DAYS - 1)
    series = []
    for key, label in series_meta:
        coordinates = []
        for point in history:
            value = point.get(key)
            if value is None:
                continue
            point_day = date.fromisoformat(point["date"])
            ratio = (point_day - window_start).days / (TREND_WINDOW_DAYS - 1)
            x = left + ratio * (right - left)
            y = bottom - value / chart_max * (bottom - top)
            coordinates.append({"x": x, "y": y, "date": point["date"], "value": value})
        if not coordinates:
            continue
        series.append(
            {
                "key": key,
                "label": label,
                "points": " ".join(f"{point['x']:.1f},{point['y']:.1f}" for point in coordinates),
                "coordinates": coordinates,
                "latest": coordinates[-1]["value"],
            }
        )

    x_labels = [
        {
            "x": left + index / (TREND_WINDOW_DAYS - 1) * (right - left),
            "label": (window_start + timedelta(days=index)).strftime("%m-%d"),
        }
        for index in range(TREND_WINDOW_DAYS)
    ]
    y_ticks = [
        {"y": top + index / 4 * (bottom - top), "value": chart_max * (1 - index / 4)}
        for index in range(5)
    ]
    return {"series": series, "x_labels": x_labels, "y_ticks": y_ticks}


def _score(
    gain_pct: float | None,
    delta_7d: float | None,
    subscription: dict,
    market: dict,
    consensus: dict,
) -> dict:
    components: list[ScoreComponent] = []
    components.append(
        _component("gmp", "GMP", _linear(gain_pct, 0, 30, 0, 40), 40, gain_pct, "% implied gain")
    )
    momentum_points = _clamp(7.5 + (delta_7d or 0) * 0.75, 0, 15) if delta_7d is not None else 7.5
    components.append(
        ScoreComponent(
            "momentum",
            "GMP momentum",
            momentum_points,
            15,
            f"{delta_7d:+.1f} over 7 days"
            if delta_7d is not None
            else "No 7-day baseline; neutral",
            delta_7d is not None,
        )
    )
    components.append(_demand_component("qib", "QIB subscription", subscription.get("qib"), 20, 50))
    components.append(_demand_component("nii", "NII subscription", subscription.get("nii"), 10, 30))
    components.append(
        _demand_component("retail", "Retail subscription", subscription.get("retail"), 5, 15)
    )
    day = market.get("day_average")
    week = market.get("week_average")
    market_available = day is not None or week is not None
    market_points = _clamp(5 + (day or 0) * 2 + (week or 0) * 0.5, 0, 10)
    components.append(
        ScoreComponent(
            "market",
            "Market conditions",
            market_points,
            10,
            f"Day {day:+.2f}%, 7-day {week:+.2f}%"
            if day is not None and week is not None
            else "No market data; neutral",
            market_available,
        )
    )
    total = round(sum(component.points for component in components))
    available_weight = sum(component.maximum for component in components if component.available)
    source_bonus = (
        10 if consensus["agreement"] == "high" else 5 if len(consensus["sources"]) > 1 else 0
    )
    confidence = round(_clamp(available_weight * 0.9 + source_bonus, 0, 100))
    signal = (
        "strong"
        if total >= 75
        else "positive"
        if total >= 60
        else "neutral"
        if total >= 40
        else "weak"
    )
    return {
        "total": total,
        "signal": signal,
        "confidence": confidence,
        "provisional": available_weight < 90,
        "components": [asdict(component) for component in components],
    }


def _component(
    key: str, label: str, points: float | None, maximum: float, value: float | None, suffix: str
) -> ScoreComponent:
    if points is None or value is None:
        return ScoreComponent(key, label, maximum / 2, maximum, "No data; neutral", False)
    return ScoreComponent(key, label, points, maximum, f"{value:.1f}{suffix}")


def _demand_component(
    key: str, label: str, value: float | None, maximum: float, strong_at: float
) -> ScoreComponent:
    if value is None:
        return ScoreComponent(key, label, maximum / 2, maximum, "No data; neutral", False)
    points = _linear(value, 0, strong_at, 0, maximum) or 0
    return ScoreComponent(key, label, points, maximum, f"{value:.2f}x")


def _linear(
    value: float | None, low: float, high: float, out_low: float, out_high: float
) -> float | None:
    if value is None:
        return None
    ratio = _clamp((value - low) / (high - low), 0, 1)
    return out_low + ratio * (out_high - out_low)


def _clamp(value: float, low: float, high: float) -> float:
    return max(low, min(high, value))


def _percent_change(current: Decimal, previous: Decimal) -> float | None:
    if not previous:
        return None
    return float((current - previous) / previous * 100)


def _float_or_none(value) -> float | None:
    return float(value) if value is not None else None


def _as_aware(value: datetime) -> datetime:
    return value if value.tzinfo else value.replace(tzinfo=UTC)


def _iso(value: datetime) -> str:
    return _as_aware(value).isoformat()
