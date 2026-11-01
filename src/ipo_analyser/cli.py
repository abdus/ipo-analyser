import asyncio
import json
from pathlib import Path
from typing import Annotated

import typer

from ipo_analyser.config import get_settings
from ipo_analyser.db import SessionLocal, create_db
from ipo_analyser.services.collector import collect_all

app = typer.Typer(no_args_is_help=True, help="Collect and display Indian IPO listing-gain signals.")


@app.command()
def init_db() -> None:
    """Create the configured database tables."""
    create_db()
    typer.echo("Database is ready.")


@app.command()
def collect(
    as_json: bool = typer.Option(False, "--json", help="Print machine-readable output."),
) -> None:
    """Fetch GMP, subscription, and market observations from all adapters."""
    create_db()
    with SessionLocal() as session:
        report = asyncio.run(collect_all(session, get_settings()))
    payload = {
        "ipos_seen": report.ipos_seen,
        "gmp_added": report.gmp_added,
        "subscriptions_added": report.subscriptions_added,
        "market_points_added": report.market_points_added,
        "errors": report.errors,
    }
    if as_json:
        typer.echo(json.dumps(payload))
        return
    typer.echo(
        f"Collected {payload['ipos_seen']} IPO records, {payload['gmp_added']} GMP points, "
        f"{payload['subscriptions_added']} subscription points, and "
        f"{payload['market_points_added']} market points."
    )
    for error in report.errors:
        typer.echo(f"Warning: {error}", err=True)


@app.command()
def export(
    out_dir: Annotated[
        Path, typer.Argument(help="Directory to write; replaced if present.")
    ] = Path("site"),
    report: Annotated[
        Path | None,
        typer.Option(help="JSON written by `collect --json`, to record which sources failed."),
    ] = None,
) -> None:
    """Render the dashboard and JSON API as a static site."""
    from ipo_analyser.export import export_site

    create_db()
    collect_report = None
    if report and report.exists() and report.read_text().strip():
        collect_report = json.loads(report.read_text())
    with SessionLocal() as session:
        status = export_site(session, out_dir, collect_report)
    typer.echo(f"Exported {status['ipos']} IPOs to {out_dir}.")


@app.command()
def dump_history(
    out_file: Annotated[Path, typer.Argument(help="SQL file to write.")],
) -> None:
    """Dump the SQLite database to a text SQL file for storage between runs."""
    from ipo_analyser.export import dump_history as dump

    create_db()
    dump(get_settings().database_url, out_file)
    typer.echo(f"Wrote {out_file}.")


@app.command()
def restore_history(
    dump_file: Annotated[Path, typer.Argument(help="SQL file written by dump-history.")],
) -> None:
    """Replace the SQLite database with a dump written by dump-history."""
    from ipo_analyser.export import restore_history as restore

    restore(get_settings().database_url, dump_file)
    typer.echo(f"Restored {dump_file}.")


@app.command()
def serve(
    host: str = typer.Option("127.0.0.1", help="Interface to bind."),
    port: int = typer.Option(8000, help="Port to bind."),
    reload: bool = typer.Option(False, help="Reload when source files change."),
) -> None:
    """Start the web dashboard and JSON API."""
    import uvicorn

    create_db()
    uvicorn.run("ipo_analyser.main:app", host=host, port=port, reload=reload)


if __name__ == "__main__":
    app()
