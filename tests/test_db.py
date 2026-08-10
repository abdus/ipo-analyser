from ipo_analyser.db import _normalize_database_url


def test_render_postgres_url_uses_psycopg_driver():
    assert (
        _normalize_database_url("postgresql://user:secret@db.internal/ipo")
        == "postgresql+psycopg://user:secret@db.internal/ipo"
    )
    assert (
        _normalize_database_url("postgres://user:secret@db.internal/ipo")
        == "postgresql+psycopg://user:secret@db.internal/ipo"
    )
    assert _normalize_database_url("sqlite:///./ipo.db") == "sqlite:///./ipo.db"
