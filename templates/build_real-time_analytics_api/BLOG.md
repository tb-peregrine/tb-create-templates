# Build a Real-Time Product Usage Analytics API with Tinybird

In the realm of software development, understanding how users interact with your product is crucial for driving improvements and tailoring features to user needs. This tutorial walks you through setting up a real-time API to analyze product usage data, leveraging Tinybird for efficient data ingestion, transformation, and insight exposure through low-latency [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV). Tinybird is a data analytics backend for software developers. You use Tinybird to build real-time analytics APIs without needing to set up or manage the underlying infrastructure. Tinybird offers a local-first development workflows, git-based deployments, resource definitions as code, and features for AI-native developers. Using Tinybird's data sources and pipes, this tutorial demonstrates how to create an API that tracks user activity, feature usage, and overall product engagement, enabling real-time monitoring of key performance indicators. 

## Understanding the data

Imagine your data looks like this:

```json
{"event_id": "evt_10787", "user_id": "user_787", "session_id": "session_787", "event_type": "form_submit", "event_name": "profile_view", "page": "/settings", "feature": "payment_form", "properties": "{\"action\":\"submit\",\"duration\":287}", "timestamp": "2025-05-12 06:45:22"}
```

This sample represents a user event, capturing details such as the type of event, the feature interacted with, and a timestamp. To manage this data in Tinybird, we start by creating a data source. Here's how the schema for our `events` data source might look:

```json
DESCRIPTION >
    Raw events collected from product usage

SCHEMA >
    `event_id` String `json:$.event_id`,
    `user_id` String `json:$.user_id`,
    `session_id` String `json:$.session_id`,
    `event_type` String `json:$.event_type`,
    `event_name` String `json:$.event_name`,
    `page` String `json:$.page`,
    `feature` String `json:$.feature`,
    `properties` String `json:$.properties`,
    `timestamp` DateTime `json:$.timestamp`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(timestamp)"
ENGINE_SORTING_KEY "timestamp, user_id, event_type"
```

In choosing the schema, we prioritize query performance. Sorting keys, for example, are selected based on common query patterns to speed up data retrieval. For data ingestion, Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request. This is exemplified in the sample ingestion code:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=events&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{"event_id":"123e4567-e89b-12d3-a456-426614174000","user_id":"user123","session_id":"session456","event_type":"feature_click","event_name":"button_click","page":"homepage","feature":"search_bar","properties":"{\"query\":\"example\"}","timestamp":"2024-10-27 10:00:00"}'
```

The Events API is designed for low latency, ensuring real-time data availability. Other ingestion methods include the Kafka connector for streaming data and the [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) or S3 connector for batch or file data. 

## Transforming data and publishing APIs

Tinybird's pipes facilitate data transformation and API endpoint creation. Pipes can perform batch transformations, real-time transformations through [Materialized views](https://www.tinybird.co/docs/forward/work-with-data/optimize/materialized-views?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV), and directly expose data through API endpoints. For instance, to analyze feature usage patterns, the `feature_usage` pipe might be defined as follows:

```sql
DESCRIPTION >
    Analyze usage patterns for specific features

NODE feature_usage_node
SQL >
    %
    SELECT 
        feature,
        count(*) as usage_count,
        count(DISTINCT user_id) as unique_users
    FROM events
    WHERE 1=1
    {% if defined(start_date) %}
        AND timestamp >= {{DateTime(start_date, '2023-01-01 00:00:00')}}
    {% end %}
    {% if defined(end_date) %}
        AND timestamp <= {{DateTime(end_date, '2023-12-31 23:59:59')}}
    {% end %}
    {% if defined(feature) %}
        AND feature = {{String(feature, '')}}
    {% else %}
        AND feature != ''
    {% end %}
    GROUP BY feature
    ORDER BY usage_count DESC

TYPE endpoint
```

This SQL query aggregates event data by feature, providing counts of total usage and unique users. Parameters like `start_date`, `end_date`, and `feature` make the API flexible, catering to various analytical needs. To call the `feature_usage` endpoint, you might use a command like:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/[pipes?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV](https://www.tinybird.co/docs/forward/work-with-data/pipes?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV)/feature_usage.json?token=$TB_ADMIN_TOKEN&feature=search_bar&start_date=2024-10-26 00:00:00&end_date=2024-10-27 23:59:59"
```


## Deploying to production

Deploying your project to Tinybird Cloud is straightforward with the `tb --cloud deploy` command. This action creates production-ready, scalable API endpoints. Tinybird manages resources as code, facilitating integration with CI/CD pipelines and ensuring secure API access through token-based authentication. For example, to call a deployed endpoint:

```bash
curl -X GET "https://api.tinybird.co/v0/pipes/your_pipe_name.json?token=your_token&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV"
```


## Conclusion

Throughout this tutorial, we've covered setting up a real-time product usage analytics API using Tinybird. From defining [data sources](https://www.tinybird.co/docs/forward/get-data-in/data-sources?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) and ingesting data to transforming that data and publishing API endpoints, Tinybird streamlines the process, enabling developers to focus on creating value through data analysis. [Sign up for Tinybird](https://cloud.tinybird.co/signup?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) to build and deploy your first real-time data APIs in a few minutes. Start for free, with no time limit and no credit card required, and unlock the potential of real-time data analytics for your applications.