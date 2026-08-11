from datetime import datetime
from decimal import Decimal
from zoneinfo import ZoneInfo

from ipo_analyser.sources.base import canonical_slug
from ipo_analyser.sources.ipocracker import IPOCrackerSource
from ipo_analyser.sources.ipogram import IPOGramSource
from ipo_analyser.sources.iporise import IPORiseSource
from ipo_analyser.sources.yahoo import YahooMarketSource

IST = ZoneInfo("Asia/Kolkata")


def test_canonical_slug_removes_legal_and_ipo_suffixes():
    assert canonical_slug("Example Technologies Limited IPO GMP") == "example-technologies"
    assert canonical_slug("Q&T Foods Ltd.") == "q-and-t-foods"


def test_iporise_list_and_history_parser():
    list_html = """
    <table><tbody id="gmpTbody"><tr data-name="shiprocket ipo" data-seg="mainboard"
      data-status="upcoming" data-gmp="26.00"
      onclick="window.location='https://www.iporise.com/ipo/shiprocket-ipo/gmp'">
      <td>Shiprocket IPO</td><td>₹26 (26.8%)</td><td>₹97</td><td>₹123</td><td>–</td>
      <td>₹4,004</td><td>12 Aug</td><td>14 Aug</td><td>19 Aug</td>
    </tr></tbody></table>
    """
    now = datetime(2026, 8, 10, 12, tzinfo=IST)
    records = IPORiseSource.parse_list(list_html, now)
    assert len(records) == 1
    assert records[0].slug == "shiprocket"
    assert records[0].price_upper == Decimal("97")
    assert records[0].gmp[0].premium == Decimal("26.00")
    assert records[0].open_date.isoformat() == "2026-08-12"

    history_html = """
    <h2>GMP History</h2><table><tbody>
      <tr><td>Aug 10, 2026 <span>5:31 pm</span></td><td>+₹26.00</td></tr>
      <tr><td>Aug 09, 2026 <span>4:00 pm</span></td><td>+₹21.00</td></tr>
    </tbody></table>
    """
    history = IPORiseSource.parse_history(history_html, "https://example.test")
    assert [point.premium for point in history] == [Decimal("26.00"), Decimal("21.00")]
    assert history[0].observed_at.hour == 17


def test_iporise_subscription_history_parser():
    html = """
    <section>
      <div><h2>Day-wise Subscription History</h2></div>
      <div>
        <details><summary><span>Fri, Aug 07, 2026</span></summary><table><tbody>
          <tr><td>QIB</td><td>100</td><td>102</td><td>1.02×</td></tr>
          <tr><td>NII</td><td>100</td><td>77</td><td>0.77×</td></tr>
          <tr><td>Individual Investors</td><td>100</td><td>55</td><td>0.55×</td></tr>
          <tr><td>Total</td><td>300</td><td>201</td><td>0.67×</td></tr>
        </tbody></table></details>
        <details><summary><span>Mon, Aug 10, 2026</span></summary><table><tbody>
          <tr><td>QIB</td><td>100</td><td>102</td><td>1.02×</td></tr>
          <tr><td>NII</td><td>100</td><td>21</td><td>0.21×</td></tr>
          <tr><td>Individual Investors</td><td>100</td><td>87</td><td>0.87×</td></tr>
          <tr><td>Total</td><td>300</td><td>231</td><td>0.77×</td></tr>
        </tbody></table></details>
      </div>
    </section>
    """
    records = IPORiseSource.parse_subscription_history(
        html,
        "https://example.test/subscription",
        "Optimystix Entertainment",
        "optimystix-entertainment-india",
        now=datetime(2026, 8, 10, 15, 20, tzinfo=IST),
    )
    assert len(records) == 2
    assert records[0].qib == Decimal("1.02")
    assert records[0].retail == Decimal("0.55")
    assert records[0].observed_at.hour == 18
    assert records[1].nii == Decimal("0.21")
    assert records[1].total == Decimal("0.77")
    assert records[1].observed_at.date().isoformat() == "2026-08-10"
    assert records[1].observed_at.strftime("%H:%M") == "15:20"


def test_ipogram_gmp_and_subscription_parser():
    html = """
    <table class="ipg3-tbl"><tbody><tr data-s="open" data-c="Mainboard"
      data-n="shiprocket" data-gmp="24" data-gpct="24.74" data-open-ts="1786492800"
      data-close-ts="1786665600" data-listing-ts="1787097600">
      <td><a class="ipg3-name" href="https://ipogram.in/ipo-gmp/shiprocket/">Shiprocket IPO GMP</a>
      <span>10 Aug 08:36 AM IST</span></td><td>₹24</td><td>24.74%</td><td>₹121</td>
    </tr></tbody></table>
    <table class="ipg3-sub-tbl"><tbody><tr>
      <td><a class="ipg3-sub-link" href="https://ipogram.in/ipo-subscription/shiprocket/">
        Shiprocket IPO Subscription Status</a></td>
      <td>8.10x</td><td>8.20x</td><td>12.40x</td><td>5.70x</td>
    </tr></tbody></table>
    """
    now = datetime(2026, 8, 10, 12, tzinfo=IST)
    ipos, subscriptions = IPOGramSource.parse(html, now)
    assert ipos[0].price_upper == Decimal("97")
    assert ipos[0].gmp[0].premium == Decimal("24")
    assert subscriptions[0].qib == Decimal("8.20")
    assert subscriptions[0].nii == Decimal("12.40")
    assert subscriptions[0].retail == Decimal("5.70")


def test_ipocracker_parser():
    html = """
    <table id="gmp-table"><tbody><tr data-type="mainboard" data-status="upcoming"
      data-name="shiprocket"><td><a href="/ipo-gmp/shiprocket">Shiprocket</a></td>
      <td>+₹27 (+27.8%)</td><td>₹92 – 97</td><td>Aug 12</td><td>Aug 14</td>
      <td>—</td><td>10 Aug, 07:26 pm</td></tr></tbody></table>
    """
    now = datetime(2026, 8, 10, 22, tzinfo=IST)
    record = IPOCrackerSource.parse(html, now)[0]
    assert record.slug == "shiprocket"
    assert record.price_lower == Decimal("92")
    assert record.price_upper == Decimal("97")
    assert record.gmp[0].premium == Decimal("27")
    assert record.gmp[0].observed_at.hour == 19


def test_yahoo_market_parser_calculates_daily_change():
    payload = {
        "chart": {
            "result": [
                {
                    "timestamp": [1000, 2000],
                    "indicators": {"quote": [{"close": [100.0, 102.0]}]},
                }
            ]
        }
    }
    points = YahooMarketSource.parse(payload, "NIFTY 50", "https://example.test")
    assert len(points) == 2
    assert points[-1].value == Decimal("102.0")
    assert points[-1].percent_change == Decimal("2.00")
