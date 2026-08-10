from functools import lru_cache
from pathlib import Path

from pydantic_settings import BaseSettings, SettingsConfigDict

PACKAGE_DIR = Path(__file__).resolve().parent


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=".env",
        env_prefix="IPO_",
        extra="ignore",
    )

    app_name: str = "IPO Analyser"
    database_url: str = "sqlite:///./ipo_analyser.db"
    http_timeout_seconds: float = 20.0
    max_detail_fetches: int = 20
    user_agent: str = "IPOAnalyser/0.1 (personal research dashboard)"
    templates_dir: Path = PACKAGE_DIR / "templates"
    static_dir: Path = PACKAGE_DIR / "static"


@lru_cache
def get_settings() -> Settings:
    return Settings()
