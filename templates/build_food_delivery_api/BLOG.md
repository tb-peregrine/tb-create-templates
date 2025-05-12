# Build a Real-Time Analytics API for Food Delivery Services with Tinybird

In the bustling world of food delivery services, real-time data analytics play a pivotal role in streamlining operations and enhancing customer satisfaction. Tracking and analyzing order trends, restaurant performance, and order status metrics are crucial for making informed decisions that propel business growth. This tutorial will guide you through building a real-time analytics API for a food delivery service using Tinybird, a data analytics backend for software developers. Tinybird enables you to construct real-time analytics APIs effortlessly, eliminating the need to manage the underlying infrastructure. It leverages data sources and [pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes) to process and analyze large volumes of data, making it an ideal solution for implementing the described API. By the end of this tutorial, you will have a clear understanding of how to use Tinybird's capabilities to monitor order trends, evaluate restaurant performance, and summarize order statuses in real time. ## Understanding the data

Imagine your data looks like this:

```json
{
  "order_id": "ord_69279",
  "customer_id": "cust_9279",
  "restaurant_id": "rest_279",
  "driver_id": "drv_279",
  "timestamp": "2025-05-03 02:36:48",
  "status": "cancelled",
  "total_amount": 2711769458,
  "delivery_fee": 9,
  "tip_amount": 9,
  "delivery_time_minutes": 39,
  "items": ["item_1", "item_2", "item_3", "item_4", "item_5"],
  "city": "Seattle",
  "payment_method": "digital_wallet"
}
```

This data represents a single food delivery order, containing details about the order, customer, restaurant, driver, payment, and delivery metrics. To store this data, we'll create Tinybird [data sources](https://www.tinybird.co/docs/forward/get-data-in/data-sources). For the `food_delivery_orders` data source, the schema and engine settings can be defined as follows:

```json
DESCRIPTION >
    Data source for food delivery orders

SCHEMA >
    `order_id` String `json:$.order_id`,
    `customer_id` String `json:$.customer_id`,
    `restaurant_id` String `json:$.restaurant_id`,
    `driver_id` String `json:$.driver_id`,
    `timestamp` DateTime `json:$.timestamp`,
    `status` String `json:$.status`,
    `total_amount` Float64 `json:$.total_amount`,
    `delivery_fee` Float64 `json:$.delivery_fee`,
    `tip_amount` Float64 `json:$.tip_amount`,
    `delivery_time_minutes` Int32 `json:$.delivery_time_minutes`,
    `items` Array(String) `json:$.items[:]`,
    `city` String `json:$.city`,
    `payment_method` String `json:$.payment_method`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(timestamp)"
ENGINE_SORTING_KEY "timestamp, city, restaurant_id"
```

This schema design reflects a thoughtful approach to organizing food delivery order data, with considerations for efficient querying and data management. The sorting keys are chosen to optimize query performance for time-based analyses and city-specific insights. For data ingestion, Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request. This method ensures low latency and real-time updates to your data source. Here's how you'd ingest an event into the `food_delivery_orders` data source:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=food_delivery_orders" \
    -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
    -d '{
        "order_id": "ord-12345",
        ... "payment_method": "credit_card"
    }'
```

In addition to the Events API, Tinybird provides other ingestion methods suitable for different scenarios:
- For event/streaming data, the Kafka connector is beneficial for integrating with existing Kafka pipelines. - For batch/file data, the [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api) and S3 connector offer straightforward ways to bulk import data. Here's how you might use the Tinybird CLI to ingest data from a file:

```bash
tb datasource append food_delivery_orders.datasource food_delivery_orders.ndjson
```


## Transforming data and publishing APIs

Tinybird transforms and analyzes your data using pipes, which can perform batch transformations, real-time transformations ([Materialized views](https://www.tinybird.co/docs/forward/work-with-data/optimize/materialized-views)), and create API endpoints. ### Daily Order Trends

Let's look at the `daily_order_trends` endpoint, which aggregates daily metrics like total orders, sales, average delivery time, delivery fees, and tips:

```sql
DESCRIPTION >
    Get daily trends of orders, sales and average delivery time

NODE daily_order_trends_node
SQL >
    SELECT 
        toDate(timestamp) AS date,
        count() AS total_orders,
        sum(total_amount) AS total_sales,
        avg(delivery_time_minutes) AS avg_delivery_time,
        sum(delivery_fee) AS total_delivery_fees,
        sum(tip_amount) AS total_tips
    FROM food_delivery_orders
    WHERE 1=1
    AND timestamp >= {{DateTime(start_date, '2023-01-01 00:00:00')}}
    AND timestamp <= {{DateTime(end_date, '2023-12-31 23:59:59')}}
    AND city = {{String(city, 'New York')}}
    GROUP BY date
    ORDER BY date DESC
    LIMIT {{Int32(limit, 30)}}

TYPE endpoint
```

This SQL code aggregates orders by date, allowing you to filter by start date, end date, and city. It demonstrates the flexibility of Tinybird's SQL templating, enabling dynamic query parameters. To call this API with different parameter values:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/daily_order_trends.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-03-01%2023:59:59&city=New%20York&limit=10"
```

Similar approaches apply to the `orders_by_restaurant` and `order_status_summary` [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints), where you can tailor queries to specific needs, using Tinybird's templating to filter data dynamically. ## Deploying to production

Deploying your Tinybird project to the cloud is straightforward with the `tb --cloud deploy` command. This action creates production-ready, scalable API endpoints. Tinybird manages resources as code, facilitating integration with CI/CD pipelines and ensuring efficient version control and deployment processes. To secure your APIs, Tinybird employs token-based authentication. Here’s how you might call a deployed endpoint:

```bash
curl -X GET "https://api.tinybird.co/v0/pipes/daily_order_trends.json?token=<YOUR_TOKEN>&start_date=2023-01-01&end_date=2023-01-31"
```


## Conclusion

Throughout this tutorial, you've learned how to leverage Tinybird to build a real-time analytics API for a food delivery service. Starting from understanding the data and creating data sources, to transforming data and publishing flexible, scalable API endpoints, and finally, deploying to production with secure, token-based access. Tinybird's capabilities significantly streamline the process of working with real-time data at scale. [Sign up for Tinybird](https://cloud.tinybird.co/signup) to build and deploy your first real-time data APIs in a few minutes. Start for free, with no time limit and no credit card required, and harness the power of real-time analytics to drive your applications forward.