from contextlib import asynccontextmanager
from typing import Annotated

from fastapi import Depends, FastAPI, HTTPException, Query, Request
from fastapi.responses import HTMLResponse
from fastapi.staticfiles import StaticFiles
from sqlalchemy import select
from sqlalchemy.orm import Session

from ipo_analyser.config import get_settings
from ipo_analyser.db import create_db, get_session
from ipo_analyser.models import IPO
from ipo_analyser.rendering import dashboard_context, templates
from ipo_analyser.services.analysis import build_market_view, build_snapshot, list_snapshots

settings = get_settings()
SessionDep = Annotated[Session, Depends(get_session)]


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
    return templates.TemplateResponse(
        request=request,
        name="index.html",
        context=dashboard_context(
            list_snapshots(session), build_market_view(session), status, sort_by, direction, q
        ),
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
