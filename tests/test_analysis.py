from datetime import UTC, datetime, timedelta
from decimal import Decimal

from sqlalchemy import create_engine
from sqlalchemy.orm import Session

from ipo_analyser.db import Base
from ipo_analyser.models import IPO, GMPObservation, MarketObservation, SubscriptionObservation
from ipo_analyser.services.analysis import _subscription_line_chart, build_snapshot


def test_snapshot_consensus_trend_calculations_and_score():
    engine = create_engine("sqlite:///:memory:")
    Base.metadata.create_all(engine)
    now = datetime(2026, 8, 10, 12, tzinfo=UTC)
    with Session(engine) as session:
        ipo = IPO(
            slug="shiprocket",
            name="Shiprocket",
            segment="mainboard",
            status="upcoming",
            price_upper=Decimal("97"),
            price_lower=Decimal("97"),
        )
        session.add(ipo)
        session.flush()
        session.add_all(
            [
                GMPObservation(
                    ipo_id=ipo.id,
                    source="iporise",
                    observed_at=now - timedelta(days=40),
                    premium=Decimal("5"),
                ),
                GMPObservation(
                    ipo_id=ipo.id,
                    source="iporise",
                    observed_at=now - timedelta(days=4),
                    premium=Decimal("14"),
                ),
                GMPObservation(
                    ipo_id=ipo.id,
                    source="iporise",
                    observed_at=now,
                    premium=Decimal("26"),
                ),
                GMPObservation(
                    ipo_id=ipo.id,
                    source="ipogram",
                    observed_at=now - timedelta(hours=1),
                    premium=Decimal("24"),
                ),
                SubscriptionObservation(
                    ipo_id=ipo.id,
                    source="ipogram",
                    observed_at=now,
                    qib=Decimal("8.2"),
                    nii=Decimal("12.4"),
                    retail=Decimal("5.7"),
                    total=Decimal("8.1"),
                ),
                SubscriptionObservation(
                    ipo_id=ipo.id,
                    source="iporise",
                    observed_at=now - timedelta(hours=2),
                    qib=Decimal("1.1"),
                    nii=Decimal("2.2"),
                    retail=Decimal("3.3"),
                    total=Decimal("2.4"),
                ),
                MarketObservation(
                    index_name="NIFTY 50",
                    source="test",
                    observed_at=now - timedelta(days=7),
                    value=Decimal("24000"),
                    percent_change=Decimal("0.1"),
                ),
                MarketObservation(
                    index_name="NIFTY 50",
                    source="test",
                    observed_at=now,
                    value=Decimal("24432"),
                    percent_change=Decimal("0.62"),
                ),
            ]
        )
        session.commit()
        snapshot = build_snapshot(session, ipo)

    assert snapshot["gmp"] == 25.0
    assert snapshot["gmp_agreement"] == "high"
    assert snapshot["implied_listing_price"] == 122.0
    assert round(snapshot["implied_gain_pct"], 2) == 25.77
    assert snapshot["delta_7d"] == 11.0
    assert snapshot["trend"] == "rising"
    assert snapshot["history_window_days"] == 7
    assert snapshot["history_coverage_days"] == 2
    assert all(point["date"] >= "2026-08-04" for point in snapshot["history"])
    assert snapshot["history_chart"]["points"]
    assert [series["label"] for series in snapshot["history_chart"]["series"]] == [
        "ipogram",
        "iporise",
        "Consensus average",
    ]
    assert snapshot["history_chart"]["series"][-1]["last"] == 25.0
    assert snapshot["subscription"]["qib"] == 1.1
    assert snapshot["subscription"]["source"] == "iporise"
    assert snapshot["subscription_coverage_days"] == 1
    assert snapshot["subscription_observation_count"] == 2
    assert snapshot["subscription_chart"]["interval_hours"] == 1
    assert snapshot["subscription_chart"]["x_labels"][0]["label"] == "15:30"
    assert snapshot["subscription_chart"]["x_labels"][-1]["label"] == "17:30"
    assert snapshot["subscription_chart"]["series"]
    assert 0 <= snapshot["score"]["total"] <= 100
    assert len(snapshot["score"]["components"]) == 6


def test_subscription_chart_uses_actual_range_and_adaptive_intervals():
    start = datetime(2026, 8, 10, 4, 30, tzinfo=UTC)

    for span_hours, expected_interval in ((4, 1), (10, 2), (20, 4), (40, 8), (80, 24)):
        history = [
            {
                "observed_at": start.isoformat(),
                "label": "10 Aug 10:00 IST",
                "source": "test",
                "qib": 0.1,
                "nii": 0.2,
                "retail": 0.3,
                "total": 0.2,
            },
            {
                "observed_at": (start + timedelta(hours=span_hours)).isoformat(),
                "label": "latest",
                "source": "test",
                "qib": 1.1,
                "nii": 1.2,
                "retail": 1.3,
                "total": 1.2,
            },
        ]

        chart = _subscription_line_chart(history)

        assert chart["interval_hours"] == expected_interval
        assert chart["series"][0]["coordinates"][0]["x"] == 54.0
        assert chart["series"][0]["coordinates"][-1]["x"] == 706.0
        assert chart["x_labels"][0]["x"] == 54.0
        assert chart["x_labels"][-1]["x"] == 706.0
