import json
from datetime import UTC, date, datetime, timedelta
from decimal import Decimal

from sqlalchemy import create_engine
from sqlalchemy.orm import Session

from ipo_analyser.db import Base
from ipo_analyser.export import dump_history, export_site, restore_history
from ipo_analyser.models import IPO, GMPObservation
from ipo_analyser.services.analysis import effective_status


def test_effective_status_advances_stale_statuses_from_dates():
    today = date(2026, 11, 2)
    old = datetime.now(UTC) - timedelta(days=60)

    def ipo(status, open_date=None, close_date=None, listing_date=None, updated_at=None):
        return IPO(
            slug="x",
            name="X",
            status=status,
            open_date=open_date,
            close_date=close_date,
            listing_date=listing_date,
            updated_at=updated_at or datetime.now(UTC),
        )

    assert effective_status(ipo("open", date(2026, 8, 7), date(2026, 8, 11)), today) == "closed"
    assert (
        effective_status(ipo("open", date(2026, 8, 7), date(2026, 8, 11), date(2026, 8, 14)), today)
        == "listed"
    )
    assert effective_status(ipo("upcoming", date(2026, 11, 1), date(2026, 11, 4)), today) == "open"
    assert effective_status(ipo("upcoming", date(2026, 11, 5), date(2026, 11, 7)), today) == (
        "upcoming"
    )
    assert effective_status(ipo("upcoming", updated_at=old), today) == "unknown"
    assert effective_status(ipo("upcoming"), today) == "upcoming"
    # Dates never move a status backwards.
    assert effective_status(ipo("listed", date(2026, 11, 5)), today) == "listed"


def test_export_writes_relative_static_site(tmp_path):
    engine = create_engine("sqlite:///:memory:")
    Base.metadata.create_all(engine)
    with Session(engine) as session:
        ipo = IPO(slug="shiprocket", name="Shiprocket", status="open", price_upper=Decimal("97"))
        session.add(ipo)
        session.flush()
        session.add(
            GMPObservation(
                ipo_id=ipo.id,
                source="iporise",
                observed_at=datetime.now(UTC),
                premium=Decimal("12"),
            )
        )
        session.commit()
        status = export_site(session, tmp_path / "site", {"errors": ["IPOGram: 403 Forbidden"]})

    site = tmp_path / "site"
    assert status["failed_sources"] == ["IPOGram"]
    index = (site / "index.html").read_text()
    assert 'href="./static/app.css"' in index
    assert 'href="./ipo/shiprocket/"' in index
    assert "Unavailable in the latest run: IPOGram" in index
    assert 'href="/' not in index
    detail = (site / "ipo" / "shiprocket" / "index.html").read_text()
    assert 'href="../../static/app.css"' in detail
    assert 'href="/' not in detail
    # One day of GMP is drawn as a labelled dot, not a line.
    assert "chart-sparse" in detail
    assert '<span class="chart-value' in detail
    assert 'class="chart-area"' not in detail
    assert "data-no-match hidden" in index
    assert "JSON data" in index
    assert (site / "static" / "app.js").exists()
    assert 'src="./static/theme.js"' in index
    assert 'src="../../static/theme.js"' in detail
    assert "data-theme-switch hidden" in index
    assert (site / "static" / "theme.js").exists()
    payload = json.loads((site / "api" / "ipos" / "shiprocket.json").read_text())
    assert payload["data"]["gmp"] == 12
    assert json.loads((site / "api" / "ipos.json").read_text())["data"][0]["slug"] == "shiprocket"


def test_history_dump_and_restore_round_trip(tmp_path):
    url = f"sqlite:///{tmp_path / 'a.db'}"
    engine = create_engine(url)
    Base.metadata.create_all(engine)
    with Session(engine) as session:
        session.add(IPO(slug="shiprocket", name="Shiprocket", status="open"))
        session.commit()
    engine.dispose()

    dump_history(url, tmp_path / "history.sql")
    restored = f"sqlite:///{tmp_path / 'b.db'}"
    restore_history(restored, tmp_path / "history.sql")
    dump_history(restored, tmp_path / "again.sql")
    assert (tmp_path / "history.sql").read_text() == (tmp_path / "again.sql").read_text()
    assert "Shiprocket" in (tmp_path / "history.sql").read_text()
