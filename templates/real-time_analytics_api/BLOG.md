# Build a Real-Time SaaS Usage Analytics API with Tinybird

In the realm of SaaS applications, understanding user behavior and engagement is critical for driving product improvement and user satisfaction. This tutorial will guide you through creating a real-time analytics API capable of tracking and analyzing user behavior in SaaS applications. By leveraging Tinybird, you'll learn how to ingest session data, monitor feature usage patterns, and compute active user metrics to derive meaningful insights from user interactions. Tinybird is a data analytics backend for software developers. You use Tinybird to build real-time analytics APIs without needing to set up or manage the underlying infrastructure. Tinybird offers a local-first development workflows, git-based deployments, resource definitions as code, and features for AI-native developers. In this tutorial, we'll explore how Tinybird's data sources and [pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) facilitate the creation of APIs that perform complex analytics in real-time, enabling immediate insights into user behavior within SaaS platforms. Let's dive into the technical steps required to implement this solution, starting with understanding the data we'll be working with. 

## Understanding the data

Imagine your data looks like this:

```json
{"event_id": "evt_372713", "user_id": "user_2713", "session_id": "sess_22713", "event_type": "login", "feature": "billing", "timestamp": "2025-05-11 21:25:07", "device_type": "mobile", "browser": "Firefox", "os": "iOS", "location": "UK", "metadata": "{\"subscription_tier\":\"basic\",\"duration\":323}"}
```

This data represents user events within a SaaS application, capturing details like user IDs, session IDs, event types (e.g., login, click), features interacted with (e.g., billing), and device information. To store this data, we first create a Tinybird datasource. Below is the `.datasource` file used to create the `app_events` datasource:

```json
DESCRIPTION >
    Captures all user events from SaaS applications

SCHEMA >
    `event_id` String `json:$.event_id`,
    `user_id` String `json:$.user_id`,
    `session_id` String `json:$.session_id`,
    `event_type` String `json:$.event_type`,
    `feature` String `json:$.feature`,
    `timestamp` DateTime `json:$.timestamp`,
    `device_type` String `json:$.device_type`,
    `browser` String `json:$.browser`,
    `os` String `json:$.os`,
    `location` String `json:$.location`,
    `metadata` String `json:$.metadata`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(timestamp)"
ENGINE_SORTING_KEY "timestamp, user_id, event_type"
```

The schema design choices, such as using `timestamp`, `user_id`, and `event_type` as sorting keys, are made to optimize query performance for analytics. For ingesting data, Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request. This is crucial for real-time analytics, as it ensures low latency from event occurrence to availability for querying. Here's how you can ingest events into the `app_events` datasource:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=app_events&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '[Your JSON payload here]'
```

For different ingestion needs, Tinybird provides:
- A Kafka connector for event/streaming data, enabling scalable and reliable ingestion from Kafka clusters. - The [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) and S3 connector for batch or file-based data, useful for bulk uploads or regular batch processes. These ingestion methods can be executed using the Tinybird CLI, enhancing your workflow for managing data pipelines. 

## Transforming data and publishing APIs


#

## pipes in Tinybird serve multiple purposes:

1. **Batch transformations**: For preprocessing or aggregating data in batches. 2. **Real-time transformations**: Acting as [Materialized views](https://www.tinybird.co/docs/forward/work-with-data/optimize/materialized-views?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV), they preprocess data upon ingestion and store it for faster querying. 3. **Creating API endpoints**: pipes can be designated as endpoints, enabling them to serve data directly over HTTP. For this tutorial, let's focus on the API endpoints created for session insights, feature usage, and active users. Each of these endpoints is implemented as a pipe in Tinybird. 

#### Session Insights Endpoint

```sql
DESCRIPTION >
    Provides insights on user sessions including duration and engagement metrics

NODE session_insights_node
SQL >
    SELECT
        session_id,
        user_id,
        min(timestamp) AS session_start,
        max(timestamp) AS session_end,
        dateDiff('second', min(timestamp), max(timestamp)) AS session_duration_seconds,
        count() AS event_count,
        device_type,
        browser,
        os,
        location
    FROM app_events
    WHERE timestamp BETWEEN {{DateTime(start_date, '2023-01-01 00:00:00')}} AND {{DateTime(end_date, '2024-12-31 23:59:59')}}
    AND user_id = {{String(user_id)}} 
    GROUP BY session_id, user_id, device_type, browser, os, location
    HAVING session_duration_seconds > 0
    ORDER BY session_start DESC
    LIMIT {{Int(limit, 100)}}

TYPE endpoint
```

This pipe calculates session duration, event counts, and other engagement metrics, filtering by date and optionally by user. The SQL logic demonstrates Tinybird's capability to handle complex aggregations and filtering with high performance. Example API call for session insights:

```bash
curl -X GET "https://api.tinybird.co/v0/pipes/session_insights.json?token=%24TB_ADMIN_TOKEN&start_date=2023-01-01+00%3A00%3A00&end_date=2023-12-31+23%3A59%3A59&user_id=usr_789&limit=50&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV"
```


#

### Feature Usage and Active Users Endpoints

Similarly, the `feature_usage.pipe` and `active_users.pipe` provide analytics on how features are used and user engagement over time, respectively. Their SQL follows a similar pattern, aggregating data based on specified criteria and making it accessible via API [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV). 

## Deploying to production

Deploying your project to Tinybird Cloud is straightforward with the `tb --cloud deploy` command. This command packages your [data sources](https://www.tinybird.co/docs/forward/get-data-in/data-sources?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) and pipes, creating scalable, production-ready API endpoints in the cloud. Tinybird manages these resources as code, facilitating seamless integration with CI/CD pipelines for automated deployments. To secure your APIs, Tinybird employs token-based authentication, ensuring that only authorized users can access your analytics data. Example curl command to call a deployed endpoint:

```bash
curl -X GET "https://api.tinybird.co/v0/pipes/active_users.json?token=%24TB_DEPLOYED_API_TOKEN&start_date=2023-01-01+00%3A00%3A00&end_date=2023-12-31+23%3A59%3A59&interval=1+week&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV"
```


## Conclusion

Throughout this tutorial, we've built a real-time analytics API for SaaS applications using Tinybird. We covered data ingestion, transformation, and the creation of API endpoints, all without managing any infrastructure. Tinybird's capabilities allow for scalable, real-time data processing, enabling immediate insights into user behavior. [Sign up for Tinybird](https://cloud.tinybird.co/signup?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) to build and deploy your first real-time data APIs in a few minutes. Start for free, with no time limit and no credit card required, and unlock the full potential of real-time data analytics for your applications.