"""Template environment and dashboard view logic shared by the server and the static export."""

from fastapi.templating import Jinja2Templates

from ipo_analyser.config import get_settings

STATUS_FILTERS = [
    ("all", "All"),
    ("open", "Open"),
    ("upcoming", "Upcoming"),
    ("closed", "Closed"),
    ("listed", "Listed"),
]


def money(value) -> str:
    if value is None:
        return "—"
    amount = float(value)
    decimals = 0 if amount.is_integer() else 2
    return f"₹{amount:,.{decimals}f}"


def multiple(value) -> str:
    return "—" if value is None else f"{float(value):,.2f}×"


def percent(value, signed: bool = False) -> str:
    if value is None:
        return "—"
    return f"{float(value):+,.2f}%" if signed else f"{float(value):,.2f}%"


templates = Jinja2Templates(directory=str(get_settings().templates_dir))
templates.env.filters.update(money=money, multiple=multiple, percent=percent)
# Server defaults; the static export overrides these per page so every link is relative.
templates.env.globals.update(
    root="/",
    ipo_url=lambda slug: f"/ipo/{slug}",
    static_site=False,
    status_filters=STATUS_FILTERS,
)

SORTERS = {
    "actionable": lambda item: (
        2 if item["status"] == "open" else 1 if item["status"] == "upcoming" else 0,
        item["score"]["total"],
    ),
    "name": lambda item: item["name"].casefold(),
    "score": lambda item: item["score"]["total"],
    "gmp": lambda item: item["gmp"],
    "gain": lambda item: item["implied_gain_pct"],
    "qib": lambda item: item["subscription"].get("qib"),
    "open_date": lambda item: item["open_date"],
}


def dashboard_context(
    all_snapshots: list[dict],
    market: dict,
    status: str | None = None,
    sort_by: str = "actionable",
    direction: str = "desc",
    q: str | None = None,
) -> dict:
    """Filter, sort, and summarise snapshots for the dashboard page.

    The static site's app.js mirrors this filtering and sorting in the browser, keyed on the
    ``order`` attribute assigned here, so keep the two in step.
    """
    for order, item in enumerate(all_snapshots):
        item["order"] = order
    snapshots = all_snapshots
    if status and status != "all":
        snapshots = [item for item in snapshots if item["status"] == status]
    if q:
        query = q.casefold().strip()
        snapshots = [item for item in snapshots if query in item["name"].casefold()]

    sort_by = sort_by if sort_by in SORTERS else "actionable"
    direction = direction if direction in {"asc", "desc"} else "desc"
    sorter = SORTERS[sort_by]
    populated = sorted(
        (item for item in snapshots if sorter(item) is not None),
        key=sorter,
        reverse=direction == "desc",
    )
    missing = [item for item in snapshots if sorter(item) is None]
    snapshots = populated + missing

    actionable = [item for item in all_snapshots if item["status"] in {"open", "upcoming"}]
    gains = [
        item["implied_gain_pct"] for item in actionable if item["implied_gain_pct"] is not None
    ]
    stats = {
        "open": sum(item["status"] == "open" for item in all_snapshots),
        "upcoming": sum(item["status"] == "upcoming" for item in all_snapshots),
        "average_gain": sum(gains) / len(gains) if gains else None,
        "top": max(
            actionable,
            key=lambda item: (item["status"] == "open", item["score"]["total"]),
            default=None,
        ),
    }
    return {
        "ipos": snapshots,
        "market": market,
        "selected_status": status or "all",
        "selected_sort": sort_by,
        "direction": direction,
        "query": q or "",
        "stats": stats,
    }
