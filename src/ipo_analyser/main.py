from contextlib import asynccontextmanager
from typing import Annotated

from fastapi import Depends, FastAPI, HTTPException, Query, Request
from fastapi.responses import HTMLResponse
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
from sqlalchemy import select
from sqlalchemy.orm import Session

from ipo_analyser.config import get_settings
from ipo_analyser.db import create_db, get_session
from ipo_analyser.models import IPO
from ipo_analyser.services.analysis import build_market_view, build_snapshot, list_snapshots

settings = get_settings()
templates = Jinja2Templates(directory=str(settings.templates_dir))
SessionDep = Annotated[Session, Depends(get_session)]


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


templates.env.filters.update(money=money, multiple=multiple, percent=percent)


@asynccontextmanager
async def lifespan(_app: FastAPI):
    create_db()
    yield


app = FastAPI(
    title=settings.app_name,
    version="0.1.0",
    description="Multi-source Indian IPO GMP, subscription, and market dashboard.",
    lifespan=lifespan,
)
app.mount("/static", StaticFiles(directory=str(settings.static_dir)), name="static")


@app.get("/", response_class=HTMLResponse)
def dashboard(
    request: Request,
    session: SessionDep,
    status: str | None = Query(default=None),
    sort_by: str = Query(default="actionable", alias="sort"),
    direction: str = Query(default="desc"),
    q: str | None = Query(default=None),
):
    all_snapshots = list_snapshots(session)
    snapshots = all_snapshots
    if status and status != "all":
        snapshots = [item for item in snapshots if item["status"] == status]
    if q:
        query = q.casefold().strip()
        snapshots = [item for item in snapshots if query in item["name"].casefold()]

    sorters = {
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
    sort_by = sort_by if sort_by in sorters else "actionable"
    direction = direction if direction in {"asc", "desc"} else "desc"
    sorter = sorters[sort_by]
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
    return templates.TemplateResponse(
        request=request,
        name="index.html",
        context={
            "ipos": snapshots,
            "market": build_market_view(session),
            "selected_status": status or "all",
            "selected_sort": sort_by,
            "direction": direction,
            "query": q or "",
            "stats": stats,
        },
    )


@app.get("/ipo/{slug}", response_class=HTMLResponse)
def ipo_detail(request: Request, slug: str, session: SessionDep):
    ipo = session.scalar(select(IPO).where(IPO.slug == slug))
    if ipo is None:
        raise HTTPException(status_code=404, detail="IPO not found")
    return templates.TemplateResponse(
        request=request,
        name="detail.html",
        context={"ipo": build_snapshot(session, ipo)},
    )


@app.get("/api/ipos")
def api_ipos(session: SessionDep):
    return {"data": list_snapshots(session)}


@app.get("/api/ipos/{slug}")
def api_ipo(slug: str, session: SessionDep):
    ipo = session.scalar(select(IPO).where(IPO.slug == slug))
    if ipo is None:
        raise HTTPException(status_code=404, detail="IPO not found")
    return {"data": build_snapshot(session, ipo)}


@app.get("/api/market")
def api_market(session: SessionDep):
    return {"data": build_market_view(session)}


@app.get("/health")
def health():
    return {"status": "ok"}
