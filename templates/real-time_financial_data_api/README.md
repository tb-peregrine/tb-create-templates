
# Real-time Stock Market Data API

## Tinybird

### Overview
This project provides a real-time API for financial market data analysis. It allows users to query stock trade data to get the latest prices, calculate trading volumes, and analyze historical price trends for different stock symbols.

### Data sources

#### stock_trades
This datasource stores individual stock trade events with timestamp, symbol, price, and volume information. Each record represents a single trade transaction.

**Sample ingestion:**
```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=stock_trades" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{"timestamp":"2023-09-20 10:30:45","symbol":"AAPL","price":175.32,"volume":100}'
```

### Endpoints

#### latest_price
Returns the most recent trading price for a specified stock symbol.

**Sample request:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/latest_price.json?token=$TB_ADMIN_TOKEN&stock_symbol=AAPL"
```

#### volume_today
Calculates the total trading volume for a specified stock symbol for the current day.

**Sample request:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/volume_today.json?token=$TB_ADMIN_TOKEN&stock_symbol=AAPL"
```

#### historical_prices
Retrieves the price history for a specified stock symbol within a given date range.

**Sample request:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/historical_prices.json?token=$TB_ADMIN_TOKEN&stock_symbol=AAPL&start_date=2023-01-01%2000:00:00&end_date=2023-01-02%2000:00:00"
```

Note: DateTime parameters must be formatted as YYYY-MM-DD HH:MM:SS, or else the query will fail.
