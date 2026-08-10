from datetime import UTC, date, datetime
from decimal import Decimal

from sqlalchemy import Date, DateTime, ForeignKey, Numeric, String, UniqueConstraint
from sqlalchemy.orm import Mapped, mapped_column, relationship

from ipo_analyser.db import Base


def utcnow() -> datetime:
    return datetime.now(UTC)


class IPO(Base):
    __tablename__ = "ipos"

    id: Mapped[int] = mapped_column(primary_key=True)
    slug: Mapped[str] = mapped_column(String(180), unique=True, index=True)
    name: Mapped[str] = mapped_column(String(240))
    segment: Mapped[str] = mapped_column(String(32), default="unknown")
    status: Mapped[str] = mapped_column(String(32), default="unknown", index=True)
    price_lower: Mapped[Decimal | None] = mapped_column(Numeric(12, 2), nullable=True)
    price_upper: Mapped[Decimal | None] = mapped_column(Numeric(12, 2), nullable=True)
    lot_size: Mapped[int | None] = mapped_column(nullable=True)
    open_date: Mapped[date | None] = mapped_column(Date, nullable=True)
    close_date: Mapped[date | None] = mapped_column(Date, nullable=True)
    listing_date: Mapped[date | None] = mapped_column(Date, nullable=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=utcnow)
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=utcnow)

    gmp_observations: Mapped[list["GMPObservation"]] = relationship(
        back_populates="ipo", cascade="all, delete-orphan"
    )
    subscriptions: Mapped[list["SubscriptionObservation"]] = relationship(
        back_populates="ipo", cascade="all, delete-orphan"
    )


class GMPObservation(Base):
    __tablename__ = "gmp_observations"
    __table_args__ = (
        UniqueConstraint("ipo_id", "source", "observed_at", name="uq_gmp_observation"),
    )

    id: Mapped[int] = mapped_column(primary_key=True)
    ipo_id: Mapped[int] = mapped_column(ForeignKey("ipos.id"), index=True)
    source: Mapped[str] = mapped_column(String(64), index=True)
    observed_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), index=True)
    premium: Mapped[Decimal] = mapped_column(Numeric(12, 2))
    source_url: Mapped[str | None] = mapped_column(String(500), nullable=True)
    collected_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=utcnow)

    ipo: Mapped[IPO] = relationship(back_populates="gmp_observations")


class SubscriptionObservation(Base):
    __tablename__ = "subscription_observations"
    __table_args__ = (
        UniqueConstraint("ipo_id", "source", "observed_at", name="uq_subscription_observation"),
    )

    id: Mapped[int] = mapped_column(primary_key=True)
    ipo_id: Mapped[int] = mapped_column(ForeignKey("ipos.id"), index=True)
    source: Mapped[str] = mapped_column(String(64), index=True)
    observed_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), index=True)
    qib: Mapped[Decimal | None] = mapped_column(Numeric(12, 2), nullable=True)
    nii: Mapped[Decimal | None] = mapped_column(Numeric(12, 2), nullable=True)
    retail: Mapped[Decimal | None] = mapped_column(Numeric(12, 2), nullable=True)
    total: Mapped[Decimal | None] = mapped_column(Numeric(12, 2), nullable=True)
    source_url: Mapped[str | None] = mapped_column(String(500), nullable=True)
    collected_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=utcnow)

    ipo: Mapped[IPO] = relationship(back_populates="subscriptions")


class MarketObservation(Base):
    __tablename__ = "market_observations"
    __table_args__ = (
        UniqueConstraint("index_name", "source", "observed_at", name="uq_market_observation"),
    )

    id: Mapped[int] = mapped_column(primary_key=True)
    index_name: Mapped[str] = mapped_column(String(32), index=True)
    source: Mapped[str] = mapped_column(String(64))
    observed_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), index=True)
    value: Mapped[Decimal] = mapped_column(Numeric(14, 2))
    percent_change: Mapped[Decimal | None] = mapped_column(Numeric(8, 3), nullable=True)
    source_url: Mapped[str | None] = mapped_column(String(500), nullable=True)
    collected_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=utcnow)
