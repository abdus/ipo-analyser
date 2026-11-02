"""Template environment and dashboard view logic shared by the server and the static export."""

import itertools
from datetime import date, datetime

from fastapi.templating import Jinja2Templates

from ipo_analyser.config import get_settings
from ipo_analyser.services.analysis import IST

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


def day(value, year: bool = False) -> str:
    """Format an ISO date, datetime or "MM-DD" as "7 Aug", or "7 Aug 2026" with ``year``."""
    if not value:
        return "—"
    text = str(value)
    if len(text) == 5:  # chart axis labels carry only month and day
        month, day_of_month = (int(part) for part in text.split("-"))
        return f"{day_of_month} {date(2000, month, day_of_month):%b}"
    parsed = date.fromisoformat(text[:10])
    return f"{parsed.day} {parsed:%b}" + (f" {parsed.year}" if year else "")


def moment(value) -> str:
    """Format an ISO datetime as "10 Aug, 16:05 IST"."""
    if not value:
        return "—"
    local = datetime.fromisoformat(str(value)).astimezone(IST)
    return f"{local.day} {local:%b}, {local:%H:%M} IST"


def segment_label(value) -> str:
    known = {"sme": "SME", "mainboard": "Mainboard"}
    text = str(value or "").lower()
    if text in known:
        return known[text]
    return text.capitalize() if text and text != "unknown" else "Segment unknown"


def smooth_path(points) -> str:
    """A smooth SVG path through chart coordinates (monotone cubic, so it never overshoots)."""
    coords = [(float(point["x"]), float(point["y"])) for point in points]
    if not coords:
        return ""
    if len(coords) < 3:
        return "M " + " L ".join(f"{x:.1f} {y:.1f}" for x, y in coords)
    slopes = [
        (y1 - y0) / (x1 - x0) if x1 != x0 else 0.0
        for (x0, y0), (x1, y1) in itertools.pairwise(coords)
    ]
    tangents = [slopes[0]]
    for before, after in itertools.pairwise(slopes):
        tangents.append(0.0 if before * after <= 0 else 2 / (1 / before + 1 / after))
    tangents.append(slopes[-1])
    path = f"M {coords[0][0]:.1f} {coords[0][1]:.1f}"
    for index, ((x0, y0), (x1, y1)) in enumerate(itertools.pairwise(coords)):
        step = (x1 - x0) / 3
        path += (
            f" C {x0 + step:.1f} {y0 + tangents[index] * step:.1f},"
            f" {x1 - step:.1f} {y1 - tangents[index + 1] * step:.1f}, {x1:.1f} {y1:.1f}"
        )
    return path


def area_path(points, baseline: float = 218.0) -> str:
    """The smooth path closed down to the chart's baseline, for a gradient area fill."""
    if len(points) < 3:
        return ""
    first, last = float(points[0]["x"]), float(points[-1]["x"])
    return f"{smooth_path(points)} L {last:.1f} {baseline:.1f} L {first:.1f} {baseline:.1f} Z"


# Signal names mapped to the three colour tones the stylesheet defines.
SIGNAL_TONES = {"strong": "up", "positive": "up", "neutral": "mid", "weak": "down"}


def tone(signal) -> str:
    return SIGNAL_TONES.get(signal, "mid")


templates = Jinja2Templates(directory=str(get_settings().templates_dir))
templates.env.filters.update(
    money=money,
    multiple=multiple,
    percent=percent,
    day=day,
    moment=moment,
    segment_label=segment_label,
    smooth_path=smooth_path,
    area_path=area_path,
    tone=tone,
)
# Server defaults; the static export overrides these per page so every link is relative.
templates.env.globals.update(
    root="/",
    ipo_url=lambda slug: f"/ipo/{slug}",
    static_site=False,
    asset_query="",
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
