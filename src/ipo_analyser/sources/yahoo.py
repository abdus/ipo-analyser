from datetime import UTC, datetime
from decimal import Decimal

import httpx

from ipo_analyser.sources.base import MarketPoint


class YahooMarketSource:
    name = "yahoo-finance"
    endpoint = "https://query1.finance.yahoo.com/v8/finance/chart/{symbol}"
    symbols = {"NIFTY 50": "%5ENSEI", "SENSEX": "%5EBSESN"}

    def __init__(self, client: httpx.AsyncClient):
        self.client = client

    async def collect(self) -> list[MarketPoint]:
        points: list[MarketPoint] = []
        for index_name, symbol in self.symbols.items():
            url = self.endpoint.format(symbol=symbol)
            response = await self.client.get(url, params={"range": "10d", "interval": "1d"})
            response.raise_for_status()
            points.extend(self.parse(response.json(), index_name, str(response.url)))
        return points

    @staticmethod
    def parse(payload: dict, index_name: str, source_url: str) -> list[MarketPoint]:
        result = payload["chart"]["result"][0]
        timestamps = result.get("timestamp", [])
        quotes = result["indicators"]["quote"][0]
        closes = quotes.get("close", [])
        valid = [
            (ts, close) for ts, close in zip(timestamps, closes, strict=False) if close is not None
        ]
        points: list[MarketPoint] = []
        previous: Decimal | None = None
        for timestamp, close in valid:
            value = Decimal(str(round(close, 2)))
            change = ((value - previous) / previous * 100) if previous else None
            points.append(
                MarketPoint(
                    index_name=index_name,
                    observed_at=datetime.fromtimestamp(timestamp, tz=UTC),
                    value=value,
                    percent_change=change,
                    source_url=source_url,
                )
            )
            previous = value
        return points
