FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim

WORKDIR /app
ENV UV_COMPILE_BYTECODE=1 UV_LINK_MODE=copy IPO_DATABASE_URL=sqlite:////data/ipo_analyser.db

COPY pyproject.toml uv.lock* README.md ./
COPY src ./src
RUN uv sync --frozen --no-dev

VOLUME ["/data"]
EXPOSE 8000
CMD ["sh", "-c", "exec /app/.venv/bin/ipo-analyser serve --host 0.0.0.0 --port ${PORT:-8000}"]
