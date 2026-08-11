# IPO Analyser

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

## Scheduling

Run the collector every two hours. Example cron entry for a machine already configured to use IST:

```cron
0 */2 * * * cd /path/to/ipo-analyser && uv run ipo-analyser collect
```

Because observations are unique by IPO, source, and source timestamp, replaying published history
does not duplicate those points. Fresh current-page and subscription snapshots receive collection
timestamps and are retained so their progression can be analysed later.

## Deployment

### Docker Compose

```bash
docker compose up --build -d app
docker compose --profile tools run --rm collector
```

The named volume persists the SQLite database. Schedule the collector command with the host's cron
or your platform's scheduled-job feature.

### Render Blueprint (recommended)

The included `render.yaml` provisions three resources in Singapore:

- a Docker web service;
- a shared PostgreSQL database for durable history;
- a cron job running the prebuilt `ipo-analyser collect --json` executable every two hours.

Push this directory to a GitHub or GitLab repository. For a new GitHub repository:

```bash
git init
git add .
git commit -m "Deploy IPO Analyser"
gh repo create ipo-analyser --private --source=. --push
```

In Render, choose **New → Blueprint**, connect the repository, and deploy the detected
`render.yaml`. The first deploy collects an initial snapshot; subsequent data refreshes use the
schedule `30 */2 * * *`. Render schedules are UTC, so this runs on exact even hours in IST: 00:00,
02:00, 04:00, and so on.

The Blueprint deliberately uses a durable `basic-256mb` PostgreSQL instance. For a temporary trial,
change its plan to `free`; free Render Postgres databases expire after 30 days. The web service uses
the free plan and can cold-start after inactivity. The cron service uses Render's smallest supported
paid cron plan.

After deployment, verify:

```text
https://<your-service>.onrender.com/health
https://<your-service>.onrender.com/
```

The cron job can also be triggered manually from its **Runs** page to verify collection immediately.

### Railway

The production Railway project uses native Railpack/UV builds with three services:

- `web`, which serves the dashboard and checks `/health`;
- `collector`, which runs `ipo-analyser collect --json` on `30 */2 * * *` (UTC); and
- managed PostgreSQL, shared by both application services through `IPO_DATABASE_URL`.

Railway cron schedules use UTC. Because IST is UTC+05:30, `30 */2 * * *` runs on exact even hours
in IST: 00:00, 02:00, 04:00, and so on. The collector is a finite command and exits after every run.

Both application services deploy the `main` branch from GitHub. `railway.toml` selects Railpack;
the web entrypoint is auto-detected from the root `main.py`, while the collector command and cron
schedule are configured on its Railway service. The optional Dockerfile lives under `deploy/` so
Railway does not auto-detect it instead of the native build.

### Cloud Run

Build with `docker build -f deploy/Dockerfile .` and pair Cloud Run with Cloud Scheduler and Cloud
SQL. Set `IPO_DATABASE_URL` to the managed PostgreSQL connection and schedule
`ipo-analyser collect --json` every two hours.

## Project layout

```text
src/ipo_analyser/
├── sources/       # Replaceable external adapters and parsers
├── services/      # Collection, consensus, trends, and score
├── templates/     # Server-rendered dashboard
├── static/        # Self-contained CSS
├── models.py      # Historical SQLAlchemy schema
├── main.py        # FastAPI HTML and JSON routes
└── cli.py         # Collection and server commands
```

The long-term Investment Score described in the original idea is intentionally not faked in this
MVP. It requires prospectus financial extraction, valuation normalization, and a separately tested
methodology. The present app only implements the Listing Signal.
