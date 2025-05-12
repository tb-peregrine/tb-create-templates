# Build a Real-Time Customer Segmentation API with Tinybird

In today's data-driven world, understanding customer behavior is paramount for creating personalized experiences and targeted marketing campaigns. A real-time customer segmentation API serves as a critical tool for analyzing and segmenting customers based on their behavior and attributes. This tutorial will guide you through creating such an API using Tinybird, focusing on retrieving customer segments, analyzing engagement patterns, and summarizing segment data to support marketing efforts. Tinybird is a data analytics backend for software developers. You use Tinybird to build real-time analytics APIs without needing to set up or manage the underlying infrastructure. Tinybird offers a local-first development workflow, git-based deployments, resource definitions as code, and features for AI-native developers. By leveraging Tinybird's data sources and [pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes), you can ingest, transform, and serve large volumes of data through APIs with minimal latency, enabling real-time decision-making and personalization at scale. ## Understanding the data

Imagine your data looks like this: a collection of customer profiles and a log of their activities. The customer profiles include demographics and a unique customer ID, while the activity log tracks events such as purchases and page views. To store this data in Tinybird, you create two [data sources](https://www.tinybird.co/docs/forward/get-data-in/data-sources): `customers` and `customer_events`. Here's how you define their schemas:


### Datasource for customer information:
```json
DESCRIPTION >
    Customer information including demographic data and customer IDs

SCHEMA >
    `customer_id` String `json:$.customer_id`,
    `name` String `json:$.name`,
    `email` String `json:$.email`,
    `age` Int32 `json:$.age`,
    `gender` String `json:$.gender`,
    `location` String `json:$.location`,
    `signup_date` DateTime `json:$.signup_date`,
    `lifetime_value` Float64 `json:$.lifetime_value`,
    `timestamp` DateTime `json:$.timestamp`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(timestamp)"
ENGINE_SORTING_KEY "customer_id, timestamp"
```


### Datasource for customer events:
```json
DESCRIPTION >
    Customer activity events like purchases, logins, page views, etc. SCHEMA >
    `event_id` String `json:$.event_id`,
    `customer_id` String `json:$.customer_id`,
    `event_type` String `json:$.event_type`,
    `event_value` Float64 `json:$.event_value`,
    `product_id` String `json:$.product_id`,
    `category` String `json:$.category`,
    `timestamp` DateTime `json:$.timestamp`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(timestamp)"
ENGINE_SORTING_KEY "customer_id, timestamp"
```

These schemas are designed to optimize query performance, with sorting keys based on customer ID and timestamp to facilitate fast data retrieval. For data ingestion, Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request. This real-time nature of the Events API ensures low latency and immediate availability of data for querying. Here's a sample ingestion code for each of the data sources:


### Ingesting customer data:
```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=customers" \
  -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
  -d '{
    "customer_id": "cust123",
    "name": "John Doe",
    ... }'
```


### Ingesting customer event data:
```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=customer_events" \
  -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
  -d '{
    "event_id": "evt456",
    ... }'
```

Beyond the Events API, Tinybird also supports data ingestion via Kafka connectors for event/streaming data and the [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api) and S3 connectors for batch/file data. ## Transforming data and publishing APIs

In Tinybird, pipes are used to transform data and publish APIs. Pipes can perform batch transformations, create real-time [Materialized views](https://www.tinybird.co/docs/forward/work-with-data/optimize/materialized-views), and expose the transformed data through API endpoints. ### customer_segment_lookup

This endpoint categorizes customers into value and loyalty segments based on lifetime value and signup date. ```sql
DESCRIPTION >
    Endpoint to look up a customer's segment based on their customer ID

SQL >
    SELECT 
        c.customer_id,
        ... CASE
            WHEN DATEDIFF('day', c.signup_date, now()) > 365 THEN 'Loyal'
            ... FROM customers c
    WHERE c.customer_id = {{String(customer_id, '')}}

TYPE endpoint
```

This SQL logic leverages conditional statements to segment customers, using the `customer_id` as a query parameter to retrieve individual customer segments. ### customer_engagement_analysis

This endpoint analyzes customer engagement by counting activities and summing event values within a specified date range and for certain event types. ```sql
DESCRIPTION >
    Analyze customer engagement based on events, with filters for date range and event types

SQL >
    SELECT 
        c.customer_id,
        ... FROM customers c
    LEFT JOIN customer_events e ON c.customer_id = e.customer_id
    ... LIMIT {{Int32(limit, 100)}}

TYPE endpoint
```

The SQL logic for this endpoint includes joining tables, conditional filtering, and aggregation functions to provide insights into customer engagement. ### customer_segments_summary

Summarizes customer segments, showing counts and average lifetime value by segment, with optional filters for location and age. ```sql
DESCRIPTION >
    Summary of customer segments showing counts and average lifetime value by segment

SQL >
    SELECT 
        CASE
            ... FROM customers
    ... ORDER BY avg_lifetime_value DESC

TYPE endpoint
```

This pipe uses SQL CASE statements for segmenting, and GROUP BY to aggregate data, facilitated by query parameters for dynamic filtering. Example API call:
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/customer_segments_summary.json?location=New%20York&min_age=25&max_age=45&token=$TB_ADMIN_TOKEN"
```


## Deploying to production

Deploying your project to Tinybird Cloud is as simple as running `tb --cloud deploy` in your command line. This command deploys your data sources and pipes, creating production-ready, scalable API [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints). Tinybird manages your resources as code, making it easy to integrate with CI/CD pipelines for automated deployments. To secure your APIs, Tinybird uses token-based authentication, ensuring that only authorized requests can access your data. Here's how you might call a deployed endpoint:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/customer_engagement_analysis.json?token=$TB_ADMIN_TOKEN&event_type=purchase&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&limit=50"
```


## Conclusion

Throughout this tutorial, you've learned how to ingest, transform, and expose customer data through real-time APIs using Tinybird. By building a customer segmentation API, you can analyze customer behavior, segment customers based on their attributes and activities, and support targeted marketing efforts and personalized experiences. Tinybird simplifies the process of working with large volumes of data in real-time, enabling you to focus on creating value from your data rather than managing infrastructure. [Sign up for Tinybird](https://cloud.tinybird.co/signup) to build and deploy your first real-time data APIs in a few minutes.