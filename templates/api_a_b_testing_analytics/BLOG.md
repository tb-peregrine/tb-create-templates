## Build a Real-time A/B Testing Analytics API with Tinybird

A/B testing is a fundamental strategy for optimizing website performance and user experience. By comparing different versions of a web page (or any other user interface), developers and marketers can make data-driven decisions to improve engagement, conversion rates, and overall revenue. However, the challenge lies in efficiently tracking and analyzing the performance of these tests in real time. This is where building a real-time A/B testing analytics API comes into play. Tinybird is a data analytics backend for software developers. You use Tinybird to build real-time analytics APIs without needing to set up or manage the underlying infrastructure. Tinybird offers a local-first development workflows, git-based deployments, resource definitions as code, and features for AI-native developers. In this tutorial, you'll learn how to leverage Tinybird's data sources and [pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) to implement a real-time A/B testing analytics API. This API will enable you to track and analyze the performance of A/B tests, including conversion rates, revenue metrics, and segment-based analysis. 

### Understanding the data

Imagine your data looks like this:

```json
{"timestamp": "2025-04-28 18:42:22", "user_id": "user_455", "test_id": "test_5", "variant": "variant_a", "event_type": "click", "conversion": 1, "revenue": 84.55, "session_id": "session_3455", "device": "desktop", "country": "AU"}
```

This sample data represents an event from an A/B test, capturing details such as the timestamp of the event, user ID, test ID, variant (e.g., control, variant_a), event type (e.g., click, impression), conversion status, revenue generated, session ID, device used, and the user's country. To store this data, you'll create a Tinybird datasource with the following schema:

```json
DESCRIPTION >
    Collects A/B test events from users, including test ID, variant, conversions, and related metrics

SCHEMA >
    `timestamp` DateTime `json:$.timestamp`,
    `user_id` String `json:$.user_id`,
    `test_id` String `json:$.test_id`,
    `variant` String `json:$.variant`,
    `event_type` String `json:$.event_type`,
    `conversion` UInt8 `json:$.conversion`,
    `revenue` Float64 `json:$.revenue`,
    `session_id` String `json:$.session_id`,
    `device` String `json:$.device`,
    `country` String `json:$.country`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(timestamp)"
ENGINE_SORTING_KEY "timestamp, test_id, variant, user_id"
```

The schema design choices, such as using `DateTime` for timestamps and `String` for user and test IDs, are straightforward. The sorting keys are chosen to optimize query performance, especially for time-series data and filtering by test ID or variant. To ingest data, Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request. This real-time nature and low latency make it ideal for tracking user interactions as they happen. Here's how you can send data to your datasource:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=ab_test_events&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV" \
  -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
  -d '{
    "timestamp": "2023-06-15 14:30:00",
    "user_id": "user_12345",
    "test_id": "homepage_redesign",
    "variant": "B",
    "event_type": "page_view",
    "conversion": 1,
    "revenue": 29.99,
    "session_id": "session_789012",
    "device": "mobile",
    "country": "US"
  }'
```

For event/streaming data, the Kafka connector is beneficial for integrating with existing Kafka streams. For batch/file data, the [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) and S3 connector provide options for bulk ingestion. 

### Transforming data and publishing APIs

Tinybird's pipes are powerful tools for transforming data and creating API [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV). You can use pipes for batch transformations, real-time transformations, and to make data accessible via fast, scalable endpoints. Let's start with the `test_summary` endpoint, which provides aggregate metrics for each A/B test:

```sql
DESCRIPTION >
    Provides summary metrics for each A/B test, including users, conversions, conversion rate, and revenue

NODE test_summary_node
SQL >
    SELECT 
        test_id,
        variant,
        count(DISTINCT user_id) AS users,
        countIf(conversion = 1) AS conversions,
        round(countIf(conversion = 1) / count(DISTINCT user_id), 4) AS conversion_rate,
        sum(revenue) AS total_revenue,
        round(sum(revenue) / count(DISTINCT user_id), 4) AS revenue_per_user
    FROM ab_test_events
    WHERE 1=1
        AND test_id = {{String(test_id, '')}}
        AND timestamp >= {{DateTime(start_date, '2023-01-01 00:00:00')}}
        AND timestamp <= {{DateTime(end_date, '2023-12-31 23:59:59')}}
    GROUP BY test_id, variant
    ORDER BY test_id, variant

TYPE endpoint
```

This SQL query calculates the number of users, conversions, conversion rate, total revenue, and revenue per user for each test variant. Query parameters like `test_id`, `start_date`, and `end_date` make the API flexible and applicable to various scenarios. Here's how to call this endpoint:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/test_summary.json?token=%24TB_ADMIN_TOKEN&test_id=homepage_redesign&start_date=2023-06-01+00%3A00%3A00&end_date=2023-06-30+23%3A59%3A59&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV"
```

The `test_segments` and `test_timeseries` endpoints follow a similar pattern, analyzing A/B test performance across different segments and over time, respectively. 

### Deploying to production

To deploy your project to Tinybird Cloud, use the Tinybird CLI:

```bash
tb --cloud deploy
```

This command creates production-ready, scalable API endpoints. Tinybird resources are managed as code, enabling integration with CI/CD pipelines. Secure your APIs with token-based authentication for reliable access. Example API call:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/test_summary.json?token=%24TB_PROD_TOKEN&test_id=homepage_redesign&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV"
```


#

## Conclusion

In this tutorial, you've learned how to build a real-time A/B testing analytics API using Tinybird. By creating [data sources](https://www.tinybird.co/docs/forward/get-data-in/data-sources?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) to store event data, transforming this data with pipes, and deploying scalable API endpoints, you can track and analyze A/B test performance with ease. Tinybird simplifies the process, allowing you to focus on extracting valuable insights from your data. [Sign up for Tinybird](https://cloud.tinybird.co/signup?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) to build and deploy your first real-time data APIs in a few minutes.