# Build a Real-Time Subscription Analytics API with Tinybird

Tinybird is a data analytics backend for software developers. You use Tinybird to build real-time analytics APIs without needing to set up or manage the underlying infrastructure. Tinybird offers a local-first development workflows, git-based deployments, resource definitions as code, and features for AI-native developers. In this tutorial, we'll leverage Tinybird to create a real-time API that provides powerful insights into subscription data, helping you analyze user behavior, revenue trends, and churn rates effectively. Understanding how your subscription model performs is crucial for any business that relies on recurring revenue. Tracking subscription events and statuses in real time enables you to make informed decisions quickly. We'll use Tinybird's data sources and [pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes) to ingest, transform, and expose our subscription data through APIs. By the end of this tutorial, you'll know how to deploy a production-ready API for subscription analytics. ## Understanding the data

Imagine your data looks like this:

**`subscription_events.ndjson`:**
```json
{"event_id": "evt_f6ae836cc42970d3", "user_id": "usr_904", "subscription_id": "sub_1904", "event_type": "downgraded", "plan_id": "plan_4", "plan_name": "Starter", "amount": 84, "currency": "CAD", "billing_period": "yearly", "timestamp": "2025-02-27 17:07:56", "metadata": "{\"source\":\"api\",\"notes\":\"System generated\"}"}
```

**`subscriptions.ndjson`:**
```json
{"subscription_id": "sub_89a9478b4edd5d7b", "user_id": "user_324", "plan_id": "plan_5", "plan_name": "Custom", "status": "unpaid", "amount": 43.99, "currency": "AUD", "billing_period": "quarterly", "start_date": "2025-01-08 17:08:03", "end_date": "2025-09-13 17:08:03", "trial_end_date": "2025-05-16 17:08:03", "cancel_at_period_end": 0, "created_at": "2025-01-08 17:08:03", "updated_at": "2025-05-08 17:08:03"}
```

This data represents subscription events and current statuses, essential for analyzing user subscriptions' lifecycle. To store this data, we create two Tinybird [data sources](https://www.tinybird.co/docs/forward/get-data-in/data-sources):

**`subscriptions.datasource`:**
```json
{
  "DESCRIPTION": "Stores current subscription status and details",
  "SCHEMA": [
    {"name": "subscription_id", "type": "String"},
    {"name": "user_id", "type": "String"},
    {"name": "plan_id", "type": "String"},
    {"name": "plan_name", "type": "String"},
    {"name": "status", "type": "String"},
    {"name": "amount", "type": "Float64"},
    {"name": "currency", "type": "String"},
    {"name": "billing_period", "type": "String"},
    {"name": "start_date", "type": "DateTime"},
    {"name": "end_date", "type": "DateTime"},
    {"name": "trial_end_date", "type": "DateTime"},
    {"name": "cancel_at_period_end", "type": "UInt8"},
    {"name": "created_at", "type": "DateTime"},
    {"name": "updated_at", "type": "DateTime"}
  ],
  "ENGINE": "MergeTree",
  "ENGINE_PARTITION_KEY": "toYYYYMM(created_at)",
  "ENGINE_SORTING_KEY": "user_id, subscription_id, plan_id"
}
```

**`subscription_events.datasource`:**
```json
{
  "DESCRIPTION": "Stores subscription-related events like creation, cancellation, renewal, and upgrades",
  "SCHEMA": [
    {"name": "event_id", "type": "String"},
    {"name": "user_id", "type": "String"},
    {"name": "subscription_id", "type": "String"},
    {"name": "event_type", "type": "String"},
    {"name": "plan_id", "type": "String"},
    {"name": "plan_name", "type": "String"},
    {"name": "amount", "type": "Float64"},
    {"name": "currency", "type": "String"},
    {"name": "billing_period", "type": "String"},
    {"name": "timestamp", "type": "DateTime"},
    {"name": "metadata", "type": "String"}
  ],
  "ENGINE": "MergeTree",
  "ENGINE_PARTITION_KEY": "toYYYYMM(timestamp)",
  "ENGINE_SORTING_KEY": "user_id, subscription_id, timestamp"
}
```

Schema design choices and column types are selected to optimize query performance and storage efficiency. For example, using `MergeTree` as the engine with appropriate partition and sorting keys ensures fast data retrieval and query execution. ### Data Ingestion

Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request. This feature enables low-latency, real-time data ingestion. **Sample ingestion code:**
```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=subscriptions" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{"subscription_id":"sub_123","user_id":"user_456",...}'
```

For event/streaming data, Tinybird's Kafka connector can be beneficial, providing a robust method for ingesting high-volume data streams. For batch or file data, the [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api) and S3 connector offer efficient ways to ingest and manage large datasets. ## Transforming data and publishing APIs

Tinybird transforms data and publishes APIs through pipes. Pipes allow for batch transformations, real-time transformations, and API endpoint creation. ### `user_subscription_history.pipe`

This pipe retrieves subscription history for a specific user. It demonstrates how to filter data using query parameters, making the API flexible and dynamic. ```sql
SELECT 
    se.event_id,
    se.user_id,
    se.subscription_id,
    se.event_type,
    ... FROM subscription_events se
WHERE se.user_id = {{String(user_id, '')}}
ORDER BY se.timestamp DESC
```

**Example API call:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_subscription_history.json?token=$TB_ADMIN_TOKEN&user_id=user_456"
```


### `active_subscriptions.pipe`

This pipe returns active subscriptions, optionally filtered by plan and date range, illustrating group by and aggregation operations. ```sql
SELECT 
    plan_name,
    plan_id,
    ... avg(amount) as avg_amount
FROM subscriptions
WHERE status = 'active'
GROUP BY plan_name, plan_id, billing_period
ORDER BY total_revenue DESC
```


### `subscription_metrics.pipe`

Provides key subscription metrics, showcasing complex SQL operations like window functions and conditional aggregations. ```sql
WITH 
    active_subs AS (
        SELECT 
            toStartOfMonth(start_date) as month,
            ... ),
    cancelled_subs AS (
        SELECT 
            toStartOfMonth(timestamp) as month,
            ... )
SELECT 
    a.month,
    a.mrr,
    ... FROM active_subs a
LEFT JOIN cancelled_subs c ON a.month = c.month
ORDER BY a.month
```


## Deploying to production

Deploy your project to Tinybird Cloud with `tb --cloud deploy`. This command uploads your data sources and pipes, creating scalable, production-ready API [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints). Tinybird manages resources as code, facilitating integration with CI/CD pipelines and ensuring reproducibility. Token-based authentication secures your APIs, ensuring only authorized access. **Example call to a deployed endpoint:**
```bash
curl -X GET "https://api.tinybird.co/v0/pipes/active_subscriptions.json?token=$TB_PUBLIC_TOKEN&plan_id=plan_A"
```


## Conclusion

In this tutorial, we've built a real-time subscription analytics API using Tinybird. We covered data ingestion, transformation, and API deployment, showcasing Tinybird's capabilities for real-time data analytics. By following these steps, you can analyze subscription data effectively, gaining valuable insights into user behavior and revenue trends. [Sign up for Tinybird](https://cloud.tinybird.co/signup) to build and deploy your first real-time data APIs in a few minutes. Tinybird is free to start, with no time limit and no credit card required.