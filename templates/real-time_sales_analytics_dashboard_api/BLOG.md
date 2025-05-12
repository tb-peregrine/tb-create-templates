# Build a Real-Time Sales Analytics Dashboard API with Tinybird

When managing sales data, the ability to analyze and act on insights in real-time can significantly enhance decision-making and operational efficiency. This tutorial will guide you through building a real-time sales analytics API that aggregates sales data by products, locations, and time periods. This API is particularly suited for powering dashboards and analytics interfaces, ensuring low-latency responses that are essential for real-time monitoring. We'll be leveraging Tinybird, a data analytics backend for software developers. Tinybird allows you to build real-time analytics APIs without the overhead of managing infrastructure. With Tinybird, data sources and [pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes) are used to ingest, transform, and serve your data through scalable, low-latency APIs. ## Understanding the data

Imagine your data looks like this:

```json
{"transaction_id": "tx-49789", "product_id": "prod-789", "product_name": "Charger", "category": "Audio", "price": 289, "quantity": 5, "total_amount": 1445, "customer_id": "cust-4789", "store_id": "store-39", "store_location": "San Jose", "timestamp": "2025-05-02 19:49:18"}
{"transaction_id": "tx-35538", "product_id": "prod-538", "product_name": "Camera", "category": "Computing", "price": 838, "quantity": 4, "total_amount": 3352, "customer_id": "cust-538", "store_id": "store-38", "store_location": "Dallas", "timestamp": "2025-04-14 06:00:18"}
... ```

This dataset represents sales transactions, including details such as the transaction ID, product information, price, quantity, total amount, customer and store details, and timestamps. To store this data in Tinybird, you'll create a data source named `sales_events` with the following schema:

```json
DESCRIPTION >
    Sales events data with transaction information including product, amount, customer, and timestamp

SCHEMA >
    `transaction_id` String `json:$.transaction_id`,
    `product_id` String `json:$.product_id`,
    `product_name` String `json:$.product_name`,
    `category` String `json:$.category`,
    `price` Float32 `json:$.price`,
    `quantity` Int32 `json:$.quantity`,
    `total_amount` Float32 `json:$.total_amount`,
    `customer_id` String `json:$.customer_id`,
    `store_id` String `json:$.store_id`,
    `store_location` String `json:$.store_location`,
    `timestamp` DateTime `json:$.timestamp`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(timestamp)"
ENGINE_SORTING_KEY "timestamp, product_id, store_id"
```

The schema is designed to optimize query performance, with sorting keys on `timestamp`, `product_id`, and `store_id`. For data ingestion, Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request. This real-time nature and low latency are crucial for up-to-the-minute analytics. To ingest data, you might use a command like:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=sales_events" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d @your_data_file.ndjson
```

Additionally, Tinybird offers Kafka connectors for event/streaming data, [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api), and S3 connectors for batch/file data, providing flexibility in how you ingest data. ## Transforming data and publishing APIs

Tinybird facilitates data transformation and API publication through pipes. Pipes can perform batch transformations, create real-time [Materialized views](https://www.tinybird.co/docs/forward/work-with-data/optimize/materialized-views), and establish API endpoints. ### Top Products Endpoint

Consider an endpoint to retrieve the top-selling products. Here's how the pipe looks:

```sql
DESCRIPTION >
    Get top-selling products by revenue or quantity

NODE top_products_node
SQL >
    SELECT
        product_id,
        product_name,
        category,
        sum(total_amount) as revenue,
        sum(quantity) as units_sold,
        count() as transaction_count
    FROM sales_events
    WHERE 1=1
        AND category = {{String(category, '')}}
        AND store_id = {{String(store_id, '')}}
        AND timestamp >= {{DateTime(start_date, '2023-01-01 00:00:00')}}
        AND timestamp <= {{DateTime(end_date, '2023-12-31 23:59:59')}}
    GROUP BY product_id, product_name, category
    ORDER BY revenue DESC
    LIMIT {{Int32(limit, 10)}}

TYPE endpoint
```

The SQL logic aggregates sales data, grouping by product details while allowing filters for category, store, and date range. The `{{parameter}}` syntax enables dynamic query modification based on API request parameters. Example API call:

```bash
curl -X GET "https://api.tinybird.co/v0/pipes/top_products.json?token=$TB_ADMIN_TOKEN&limit=5&sort_by=revenue"
```


### Sales by Location and Period Endpoints

Similarly, `sales_by_location` and `sales_by_period` [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints) are created to aggregate sales data by store location and time periods, respectively, offering insights into performance across different dimensions. ## Deploying to production

Deploying your project to Tinybird Cloud is straightforward with `tb --cloud deploy`. This command pushes your local development to the cloud, creating production-ready, scalable API endpoints. Tinybird manages resources as code, allowing seamless integration with CI/CD pipelines and ensuring that your data infrastructure is version-controlled and reproducible. To secure your APIs, Tinybird uses token-based authentication. Example call to a deployed endpoint:

```bash
curl -X GET "https://api.tinybird.co/v0/pipes/sales_by_location.json?token=$TB_PRODUCTION_TOKEN&start_date=2023-01-01&end_date=2023-12-31"
```


## Conclusion

In this tutorial, you've learned how to build a real-time sales analytics API with Tinybird, from understanding and ingesting your sales data to transforming this data and publishing scalable, low-latency APIs. Tinybird's [data sources](https://www.tinybird.co/docs/forward/get-data-in/data-sources) and pipes streamlined the process, enabling powerful real-time analytics without the overhead of infrastructure management. [Sign up for Tinybird](https://cloud.tinybird.co/signup) to build and deploy your first real-time data APIs in a few minutes. Tinybird is free to start, with no time limit and no credit card required, making it accessible for developers at any scale.