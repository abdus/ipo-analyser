# IPO Analyser

**Live dashboard: <https://abdus.github.io/ipo-analyser/>**, refreshed every two hours by GitHub
Actions.

A self-contained Indian IPO listing-gain research dashboard. It stores timestamped observations,
compares unofficial GMP sources, tracks QIB/NII/Retail demand, adds Nifty/Sensex context, and shows
the exact contribution of every factor in its 0–100 signal.

> GMP is an unofficial, unregulated market signal. The calculated score is a mechanical research
> aid—not financial advice, an application recommendation, or a listing-price guarantee.

## Quick start

Requires Python 3.12+ and [UV](https://docs.astral.sh/uv/).

```bash
uv sync
uv run ipo-analyser collect
uv run ipo-analyser serve --reload
```

Open <http://127.0.0.1:8000>. Interactive API docs are at
<http://127.0.0.1:8000/docs>.

To build the static site that GitHub Pages serves instead:

```bash
uv run ipo-analyser export site
python3 -m http.server -d site 8000
```

SQLite is the default, so no account, API key, frontend toolchain, or separate database is needed.
The database is created as `ipo_analyser.db` in the current directory.

## What is implemented

- Current GMP consensus with per-source values and agreement quality.
- Timestamped GMP history, a 7-day daily-consensus trend chart, 3/7-day changes, and
  rising/flat/falling direction.
- IPO price, implied listing price, rupee gain, and percentage gain.
- Latest QIB, NII/HNI, Retail, and total subscription multiples with every available timestamped
  observation and an adaptive hourly/day-scale chart.
- Nifty 50 and Sensex daily and seven-day performance.
- Transparent Listing Signal with individual factor contributions and data-confidence score.
- FastAPI HTML dashboard plus `/api/ipos`, `/api/ipos/{slug}`, and `/api/market`.
- A static export of the same pages and JSON, with filtering, search, and sorting done in the
  browser, published to GitHub Pages.
- Idempotent collection suitable for cron or a cloud scheduler.
- SQLite locally; PostgreSQL is supported for multi-instance deployment.

The first collection imports available current/upcoming IPOs, not just one hard-coded company.
Shiprocket will appear while its source pages remain in an active/recent state.

## Commands

```bash
# Create tables without fetching data
uv run ipo-analyser init-db

# Fetch all sources; safe to repeat
uv run ipo-analyser collect

# Machine-readable collector report
uv run ipo-analyser collect --json

# Serve on the local network
uv run ipo-analyser serve --host 0.0.0.0 --port 8000

# Write the static site (pages plus JSON) to ./site
uv run ipo-analyser export site --report collect.json

# Save and restore the SQLite history as a text SQL dump
uv run ipo-analyser dump-history history.sql
uv run ipo-analyser restore-history history.sql

# Test and lint
uv run pytest
uv run ruff check .
```

## Data-source design

Each observation retains its source and source URL. Adapters currently included:

- `IPORiseSource`: IPO catalogue, issue price, current GMP, and timestamped GMP history.
- `IPOGramSource`: independent current GMP and investor-class subscription figures.
- `IPOCrackerSource`: a third current GMP and price-band observation for broader consensus coverage.
- `YahooMarketSource`: Nifty 50 and Sensex daily index history.

These are public webpages/endpoints rather than contractual APIs and can change. A failed adapter is
reported as a warning while successful adapters are still committed. Source code is isolated under
`src/ipo_analyser/sources/`, so a layout change only requires replacing one parser.

The app does not bypass access controls. Before running this commercially or at high frequency,
review each source's terms and request permission or a licensed feed. A collection interval of a few
hours is more appropriate than minute-level polling for this use case.

## Score

The Listing Signal weights are:

| Factor | Maximum |
| --- | ---: |
| GMP implied gain | 40 |
| GMP 7-day momentum | 15 |
| QIB subscription | 20 |
| NII subscription | 10 |
| Retail subscription | 5 |
| Overall market | 10 |

Missing factors receive neutral points and are visibly marked unavailable. They reduce the separate
data-confidence percentage, so an incomplete 70 is not presented as equivalent to a fully observed
70. The score is intentionally simple and inspectable; it should be backtested before changing its
thresholds or using it in any decision process.

## Configuration

Copy `.env.example` to `.env` if you want to override defaults. Every setting uses the `IPO_` prefix.

| Variable | Default | Purpose |
| --- | --- | --- |
| `IPO_DATABASE_URL` | `sqlite:///./ipo_analyser.db` | SQLAlchemy database URL |
| `IPO_HTTP_TIMEOUT_SECONDS` | `20` | Per-request timeout |
| `IPO_MAX_DETAIL_FETCHES` | `20` | Maximum IPO history pages per run |
| `IPO_USER_AGENT` | project identifier | Collector User-Agent |

For PostgreSQL:

```bash
uv sync
IPO_DATABASE_URL='postgresql+psycopg://user:password@host/database' \
  uv run ipo-analyser collect
```

## Deployment: GitHub Pages

`.github/workflows/pages.yml` runs on `30 */2 * * *` (UTC, which is the even hour in IST), on
every push to `main`, and on demand from the Actions tab. Each run:

1. restores the database from `history.sql` on the `data` branch;
2. runs `collect --json`;
3. runs `export site`, which writes `index.html`, `ipo/<slug>/index.html`, and the JSON API;
4. uploads `site/` and deploys it to Pages;
5. dumps the database back to `history.sql` and commits it to `data` when it changed.

History lives in git rather than the Actions cache, which GitHub evicts. The dump is plain SQL, so
each commit stores only the new rows. To rebuild locally from the published history:

```bash
git fetch origin data
git show origin/data:history.sql > history.sql
uv run ipo-analyser restore-history history.sql
```

A source that fails, for example because it blocks GitHub's runners, does not stop the run. Its
earlier observations stay in the database and the site still publishes. The failure appears as a
warning on the run, in the run summary, in the site footer, and in `api/status.json`.

The static site has the same JSON as the server, at relative paths:

| Server | Static site |
| --- | --- |
| `/api/ipos` | `api/ipos.json` |
| `/api/ipos/{slug}` | `api/ipos/{slug}.json` |
| `/api/market` | `api/market.json` |
| — | `api/status.json` (generation time and the last collection report) |

The interactive `/docs` page and `/health` exist only on the server.

### Self-hosting the server

The FastAPI server still works anywhere Python or Docker runs:

```bash
docker compose up --build -d app
docker compose --profile tools run --rm collector
```

The named volume persists the SQLite database. Schedule the collector with the host's cron.
PostgreSQL also works; set `IPO_DATABASE_URL` as shown under Configuration.

Because observations are unique by IPO, source, and source timestamp, replaying published history
does not duplicate those points. Fresh current-page and subscription snapshots receive collection
timestamps and are retained so their progression can be analysed later.

## Project layout

```text
src/ipo_analyser/
├── sources/       # Replaceable external adapters and parsers
├── services/      # Collection, consensus, trends, and score
├── templates/     # Dashboard templates, shared by the server and the static export
├── static/        # CSS, plus app.js for filtering and sorting on the static site
├── models.py      # Historical SQLAlchemy schema
├── rendering.py   # Template filters and dashboard filtering/sorting
├── main.py        # FastAPI HTML and JSON routes
├── export.py      # Static site export and history dump/restore
└── cli.py         # Collection, export, and server commands
```

The long-term Investment Score described in the original idea is intentionally not faked in this
MVP. It requires prospectus financial extraction, valuation normalization, and a separately tested
methodology. The present app only implements the Listing Signal.
