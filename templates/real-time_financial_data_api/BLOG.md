# Build a Real-Time Stock Market Data API with Tinybird

Creating a real-time API for stock market data analysis can be a daunting task, especially when handling vast amounts of data and requiring low-latency responses. This tutorial will guide you through building a real-time API to query stock trade data, allowing you to get the latest prices, calculate trading volumes, and analyze historical price trends for different stock symbols using Tinybird. Tinybird is a data analytics backend for software developers. You use Tinybird to build real-time analytics APIs without needing to set up or manage the underlying infrastructure. Tinybird offers a local-first development workflows, git-based deployments, resource definitions as code, and features for AI-native developers. By leveraging Tinybird's data sources and [pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV), you can efficiently ingest, transform, and serve large-scale data in real-time. 

## Understanding the data

Imagine your data looks like this:

```json
{"timestamp": "2025-05-12 06:54:15", "symbol": "AAPL", "price": 2542097440, "volume": 630}
{"timestamp": "2025-05-11 20:28:56", "symbol": "INTC", "price": 661465878, "volume": 349}
{"timestamp": "2025-05-11 17:02:42", "symbol": "AMZN", "price": 3995567626, "volume": 323}
... ```

Each record represents an individual stock trade event, including a timestamp, stock symbol, price, and volume. To store this data in Tinybird, you'll need to create a data source designed to efficiently query and analyze these records. Here's how the `stock_trades.datasource` file might look:

```json
DESCRIPTION >
    Trades of stocks with timestamp, symbol, price, and volume. SCHEMA >
    `timestamp` DateTime `json:$.timestamp`,
    `symbol` String `json:$.symbol`,
    `price` Float64 `json:$.price`,
    `volume` UInt32 `json:$.volume`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(timestamp)"
ENGINE_SORTING_KEY "timestamp, symbol"
```

This schema definition includes types for each column, ensuring data integrity and optimizing query performance. The sorting key is particularly important, as it affects the efficiency of queries filtering by `timestamp` and `symbol`. To ingest data into this datasource, Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request. The real-time nature of the Events API ensures low latency, making it ideal for financial market data. ```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=stock_trades&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{"timestamp":"2023-09-20 10:30:45","symbol":"AAPL","price":175.32,"volume":100}'
```

For event/streaming data, the Kafka connector is beneficial for integrating with existing Kafka pipelines. For batch/file data, Tinybird's [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) and S3 connectors offer flexible and efficient data ingestion methods. 

## Transforming the data and publishing APIs

With your data ingested, the next step is to transform this data and publish APIs using Tinybird's pipes. Pipes allow for batch transformations, real-time transformations, and the creation of API [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV). Let's look at the `latest_price.pipe` as an example:

```sql
DESCRIPTION >
    Returns the latest price for a given stock symbol. NODE latest_price_node
SQL >
    SELECT
        symbol,
        argMax(price, timestamp) AS latest_price,
        max(timestamp) AS last_updated
    FROM stock_trades
    WHERE symbol = {{String(stock_symbol, 'AAPL')}}
    GROUP BY symbol

TYPE endpoint
```

This pipe defines an endpoint that returns the latest trading price for a specified stock symbol. It uses the `argMax` function to find the price corresponding to the latest timestamp for the given symbol. The query parameter `stock_symbol` adds flexibility, allowing users to specify different stock symbols in their API requests. Example API call:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/latest_price.json?token=%24TB_ADMIN_TOKEN&stock_symbol=AAPL&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV"
```

By creating similar pipes for `volume_today` and `historical_prices`, you can expose endpoints for calculating the total trading volume for the current day and retrieving the price history within a specified date range. 

## Deploying to production

Deploying your project to Tinybird Cloud is straightforward with the `tb --cloud deploy` command. This command creates production-ready, scalable API endpoints. Tinybird manages resources as code, facilitating integration with CI/CD pipelines and ensuring your data APIs are easily maintainable and version-controlled. Secure your APIs with token-based authentication, ensuring only authorized users can access your endpoints. Example `curl` command to call a deployed endpoint:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/latest_price.json?token=%24TB_PROD_TOKEN&stock_symbol=AAPL&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV"
```


## Conclusion

In this tutorial, you've learned how to build a real-time API for stock market data analysis using Tinybird. You ingested trade event data, transformed it through pipes, and published scalable endpoints for querying the latest prices, trading volumes, and historical price trends. Tinybird simplifies the development and deployment of real-time data analytics APIs, allowing you to focus on creating value from your data without worrying about the underlying infrastructure. [Sign up for Tinybird](https://cloud.tinybird.co/signup?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) to build and deploy your first real-time data APIs in a few minutes.