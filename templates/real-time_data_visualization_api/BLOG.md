# Build a Real-time E-commerce Data API with Tinybird

In the realm of e-commerce, understanding product performance, tracking events, and analyzing revenue trends are crucial for making data-driven decisions. This tutorial will guide you through creating a real-time API that tackles these needs using Tinybird. Tinybird is a data analytics backend for software developers. You use Tinybird to build real-time analytics APIs without needing to set up or manage the underlying infrastructure. Tinybird offers a local-first development workflows, git-based deployments, resource definitions as code, and features for AI-native developers. By leveraging Tinybird's data sources and [pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes), this API enables you to ingest e-commerce event data and transform it into actionable metrics. You'll learn how to track top-selling products, event counts by country, and revenue trends over time, all in real-time. Let's dive into the technical process of building this API from the ground up. ## Understanding the data

Imagine your data looks like this:

```json
{
  "event_time": "2025-05-12 03:18:44",
  "event_type": "remove_from_cart",
  "user_id": "user_298",
  "product_id": "prod_298",
  "category": "Books",
  "price": 698,
  "quantity": 4,
  "session_id": "session_298",
  "country": "France"
}
```

This sample represents an e-commerce event, capturing details like event time, type, user and product IDs, category, price, quantity, session ID, and country. To store this data, we'll create Tinybird [data sources](https://www.tinybird.co/docs/forward/get-data-in/data-sources). Here's how you define the `ecommerce_events` data source:

```json
DESCRIPTION >
    Raw e-commerce events

SCHEMA >
    `event_time` DateTime `json:$.event_time`,
    `event_type` String `json:$.event_type`,
    `user_id` String `json:$.user_id`,
    `product_id` String `json:$.product_id`,
    `category` String `json:$.category`,
    `price` Float64 `json:$.price`,
    `quantity` Int64 `json:$.quantity`,
    `session_id` String `json:$.session_id`,
    `country` String `json:$.country`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(event_time)"
ENGINE_SORTING_KEY "event_time, product_id"
```

In this schema, we use the `MergeTree` engine for efficient data storage and querying, partitioned by month and sorted by event time and product ID to optimize query performance. Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request, perfect for real-time data ingestion with low latency. Here's how you can ingest data into the `ecommerce_events` data source:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=ecommerce_events" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{"event_time":"2024-10-27 10:00:00","event_type":"purchase","user_id":"user123","product_id":"product456","category":"electronics","price":100.0,"quantity":1,"session_id":"session789","country":"US"}'
```

For different ingestion needs, Tinybird also offers a Kafka connector for streaming data and a [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api) along with an S3 connector for batch or file-based data. ## Transforming data and publishing APIs

Tinybird's pipes enable batch and real-time transformations, as well as the creation of API [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints). Let's create endpoints for our three key metrics: top-selling products, event counts by country, and total revenue trends. ### Top-selling products

```sql
DESCRIPTION >
    Top selling products

NODE top_products_node
SQL >
    SELECT
        product_id,
        sum(quantity) AS total_quantity,
        sum(price * quantity) AS total_revenue
    FROM ecommerce_events
    WHERE event_type = 'purchase'
    GROUP BY product_id
    ORDER BY total_revenue DESC
    LIMIT 10

TYPE endpoint
```

This pipe computes the top 10 selling products based on total revenue, providing a clear insight into which products generate the most sales. The SQL logic aggregates data by `product_id`, summing up `quantity` and total revenue (`price * quantity`), and orders the result by `total_revenue`. ### Events by country

```sql
DESCRIPTION >
    Number of events per country

NODE events_by_country_node
SQL >
    SELECT
        country,
        count() AS event_count
    FROM ecommerce_events
    GROUP BY country
    ORDER BY event_count DESC

TYPE endpoint
```

This endpoint returns the count of events per country, offering a geographical overview of where user interactions are happening the most. ### Total revenue over time

```sql
DESCRIPTION >
    Total revenue over time

NODE total_revenue_node
SQL >
    SELECT
        toStartOfInterval(event_time, INTERVAL 15 MINUTE) AS time_bin,
        sum(price * quantity) AS total_revenue
    FROM ecommerce_events
    WHERE event_type = 'purchase'
    GROUP BY time_bin
    ORDER BY time_bin

TYPE endpoint
```

Here, we aggregate total revenue into 15-minute intervals, allowing you to track revenue trends in near real-time. ## Deploying to production

Deploying your project to Tinybird Cloud is straightforward. Use the command `tb --cloud deploy` to create production-ready, scalable API endpoints. This process turns your data transformations and logic into highly available services that can handle large volumes of requests. Tinybird manages resources as code, facilitating integration with CI/CD pipelines for automated deployments. Additionally, Tinybird provides token-based authentication to secure your APIs. Here's how you might call one of the deployed endpoints:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/top_products.json?token=$TB_ADMIN_TOKEN"
```


## Conclusion

In this tutorial, you've learned how to build a real-time e-commerce data API with Tinybird, covering data ingestion, transformation, and API endpoint creation. This approach provides valuable insights into product performance, user activity, and revenue trends, all in real-time. Using Tinybird for this use case enables you to focus on developing your application's logic and features, rather than managing data infrastructure. The simplicity and efficiency of Tinybird's data analytics backend can significantly accelerate the development of real-time analytics applications. [Sign up for Tinybird](https://cloud.tinybird.co/signup) to build and deploy your first real-time data APIs in a few minutes.