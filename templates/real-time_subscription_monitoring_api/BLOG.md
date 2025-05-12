# Build a Real-Time Subscription Analytics API with Tinybird

In the digital age, where subscription-based models are prevalent across industries, monitoring and analyzing subscription data in real-time can be a game-changer for businesses. Tracking subscription renewals, churn rates, and overall patterns requires a robust solution that can handle streaming data and provide immediate insights through APIs. This is where Tinybird steps in. Tinybird is a data analytics backend for software developers. You use Tinybird to build real-time analytics APIs without needing to set up or manage the underlying infrastructure. It offers a local-first development workflow, git-based deployments, resource definitions as code, and features for AI-native developers. By leveraging Tinybird's data sources and [pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes), developers can efficiently ingest, transform, and expose subscription data through high-performance APIs. This tutorial guides you through building a real-time Subscription Analytics API using Tinybird, focusing on tracking subscription events and analyzing metrics such as renewal rates, churn patterns, and more. ## Understanding the data

Imagine your data looks like this:

```json
{"subscription_id": "sub_24", "customer_id": "cust_24", "plan_id": "plan_5", "event_type": "downgraded", "timestamp": "2023-03-11 08:00:00", "amount": 33.99, "currency": "AUD", "next_renewal_date": "2024-03-10 00:00:00", "status": "active"}
{"subscription_id": "sub_4627", "customer_id": "cust_627", "plan_id": "plan_3", "event_type": "cancelled", "timestamp": "2023-03-09 03:00:00", "amount": 36.99, "currency": "GBP", "next_renewal_date": "2024-03-08 00:00:00", "status": "failed"}
... ```

This dataset represents subscription events, including new subscriptions, renewals, cancellations, and changes in subscription plans. Each event captures details such as the subscription ID, customer ID, plan ID, event type, timestamp, amount, currency, next renewal date, and status. To store this data, you'll create a Tinybird datasource named `subscription_events`:

```json
DESCRIPTION >
    Track subscription events including creation, renewal, and cancellation

SCHEMA >
    `subscription_id` String `json:$.subscription_id`,
    `customer_id` String `json:$.customer_id`,
    `plan_id` String `json:$.plan_id`,
    `event_type` String `json:$.event_type`, 
    `timestamp` DateTime `json:$.timestamp`,
    `amount` Float32 `json:$.amount`,
    `currency` String `json:$.currency`,
    `next_renewal_date` DateTime `json:$.next_renewal_date`,
    `status` String `json:$.status`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(timestamp)"
ENGINE_SORTING_KEY "customer_id, subscription_id, timestamp"
```

For ingestion, Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api) enables you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request. This approach ensures low latency and real-time data availability. Here's how you can ingest data into your `subscription_events` datasource:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=subscription_events" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
        "subscription_id": "sub_12345",
        "customer_id": "cust_789",
        "plan_id": "plan_monthly",
        "event_type": "new",
        "timestamp": "2023-06-15 10:30:00",
        "amount": 29.99,
        "currency": "USD",
        "next_renewal_date": "2023-07-15 10:30:00",
        "status": "active"
     }'
```

Additionally, for event/streaming data, the Kafka connector provides a robust method for ingesting data in real-time. For batch/file data, the [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api) and S3 connector facilitate efficient data uploads. ## Transforming data and publishing APIs

Tinybird's pipes enable you to perform batch transformations, create [Materialized views](https://www.tinybird.co/docs/forward/work-with-data/optimize/materialized-views) for optimized data querying, and publish API endpoints directly from your SQL queries. ### Subscription Overview API

This endpoint provides a comprehensive overview of subscription metrics:

```sql
DESCRIPTION >
    API endpoint providing overview of subscription metrics

NODE subscription_overview_node
SQL >
    %
    SELECT 
        count() AS total_subscriptions,
        countIf(event_type = 'new') AS new_subscriptions,
        countIf(event_type = 'renewal') AS renewals,
        countIf(event_type = 'cancellation') AS cancellations,
        round(countIf(event_type = 'renewal') / countIf(event_type = 'new') * 100, 2) AS renewal_rate,
        round(countIf(event_type = 'cancellation') / (countIf(event_type = 'new') + countIf(event_type = 'renewal')) * 100, 2) AS churn_rate
    FROM subscription_events
... TYPE endpoint
```

This SQL query calculates total subscriptions, new subscriptions, renewals, cancellations, renewal rate, and churn rate. The query parameters allow for filtering based on time range and subscription plan. ### Churn Analysis API

Analyzing subscription churn patterns is crucial for understanding customer retention:

```sql
DESCRIPTION >
    API endpoint for analyzing subscription churn patterns

NODE churn_analysis_node
SQL >
    %
    SELECT 
        toStartOfMonth(timestamp) AS month,
        plan_id,
        count() AS total_cancellations,
        sum(amount) AS lost_revenue
    FROM subscription_events
... TYPE endpoint
```

This query groups cancellations by month and plan, providing insights into churn patterns and potential revenue loss. ### Renewal Rates API

Tracking renewal rates over time helps assess the effectiveness of retention strategies:

```sql
DESCRIPTION >
    API endpoint for tracking subscription renewal rates over time

NODE renewal_rates_node
SQL >
    %
... TYPE endpoint
```

The query calculates the renewal rate by comparing eligible renewals against actual renewals, grouped by month and plan. ## Deploying to production

Deploy your project to Tinybird Cloud with the following command:

```bash
tb --cloud deploy
```

This command prepares your data sources and pipes for production, creating scalable, high-performance API [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints). Tinybird manages your resources as code, making it straightforward to integrate with CI/CD pipelines. Secure your APIs with token-based authentication. To call your deployed endpoints, use:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/your_endpoint.json?token=$TB_ADMIN_TOKEN&parameters"
```


## Conclusion

In this tutorial, you've learned how to build a Subscription Analytics API using Tinybird, from ingesting streaming data to transforming it and publishing real-time APIs. Tinybird simplifies complex data engineering tasks, enabling you to focus on delivering value from your data. [Sign up for Tinybird](https://cloud.tinybird.co/signup) to build and deploy your first real-time data APIs in a few minutes.