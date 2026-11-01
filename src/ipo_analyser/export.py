"""Render the dashboard and its JSON API to a directory of static files.

Every link is relative, so the output works from any base path (for example GitHub Pages
project sites at ``/<repo>/``) and from ``file://``.
"""

import json
import re
import shutil
import sqlite3
from datetime import UTC, datetime
from pathlib import Path

from sqlalchemy.engine import make_url
from sqlalchemy.orm import Session

from ipo_analyser.config import get_settings
from ipo_analyser.rendering import dashboard_context, templates
from ipo_analyser.services.analysis import IST, build_market_view, list_snapshots

SAFE_SLUG = re.compile(r"^[a-z0-9][a-z0-9-]*$")


def export_site(session: Session, out_dir: Path, collect_report: dict | None = None) -> dict:
    """Write index.html, ipo/<slug>/index.html, api/*.json and static assets to ``out_dir``."""
    generated_at = datetime.now(UTC)
    failed_sources = [error.split(":", 1)[0] for error in (collect_report or {}).get("errors", [])]
    market = build_market_view(session)
    snapshots = [item for item in list_snapshots(session) if SAFE_SLUG.match(item["slug"])]

    if out_dir.exists():
        shutil.rmtree(out_dir)
    (out_dir / "api" / "ipos").mkdir(parents=True)
    shutil.copytree(get_settings().static_dir, out_dir / "static")
    (out_dir / ".nojekyll").touch()

    common = {
        "static_site": True,
        "generated_label": generated_at.astimezone(IST).strftime("%d %b %Y, %H:%M IST"),
        "failed_sources": failed_sources,
    }

    def page(name: str, path: Path, root: str, context: dict) -> None:
        html = templates.get_template(name).render(
            **common,
            **context,
            root=root,
            ipo_url=lambda slug: f"{root}ipo/{slug}/",
        )
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(html, encoding="utf-8")

    page("index.html", out_dir / "index.html", "./", dashboard_context(snapshots, market))
    for item in snapshots:
        page("detail.html", out_dir / "ipo" / item["slug"] / "index.html", "../../", {"ipo": item})
        _write_json(out_dir / "api" / "ipos" / f"{item['slug']}.json", {"data": item})

    _write_json(out_dir / "api" / "ipos.json", {"data": snapshots})
    _write_json(out_dir / "api" / "market.json", {"data": market})
    status = {
        "generated_at": generated_at.isoformat(),
        "ipos": len(snapshots),
        "failed_sources": failed_sources,
        "collect": collect_report,
    }
    _write_json(out_dir / "api" / "status.json", status)
    return status


def _write_json(path: Path, payload: dict) -> None:
    path.write_text(json.dumps(payload, ensure_ascii=False, default=str), encoding="utf-8")


def sqlite_path(database_url: str) -> Path:
    url = make_url(database_url)
    if url.get_backend_name() != "sqlite" or not url.database or url.database == ":memory:":
        raise ValueError("History dump and restore need a file-backed SQLite IPO_DATABASE_URL.")
    return Path(url.database)


def dump_history(database_url: str, out_file: Path) -> None:
    """Write the database as a plain SQL dump; text keeps git deltas small between runs."""
    with sqlite3.connect(sqlite_path(database_url)) as connection:
        out_file.write_text("\n".join(connection.iterdump()) + "\n", encoding="utf-8")


def restore_history(database_url: str, dump_file: Path) -> None:
    """Replace the database with the contents of a SQL dump."""
    db_path = sqlite_path(database_url)
    for suffix in ("", "-wal", "-shm", "-journal"):
        Path(f"{db_path}{suffix}").unlink(missing_ok=True)
    with sqlite3.connect(db_path) as connection:
        connection.executescript(dump_file.read_text(encoding="utf-8"))
