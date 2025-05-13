# Build a Real-time Mobile Analytics API with Tinybird

In today's digital age, understanding user interactions within mobile applications can be the key to optimizing user experience and increasing engagement. To achieve this, developers and product managers rely on real-time analytics to track and analyze user behavior, app performance, and system events. However, building a backend capable of processing and serving this data in real time can be challenging. This is where Tinybird comes into play. Tinybird is a data analytics backend for software developers. You use Tinybird to build real-time analytics APIs without needing to set up or manage the underlying infrastructure. Tinybird offers a local-first development workflows, git-based deployments, resource definitions as code, and features for AI-native developers. By leveraging Tinybird's data sources and [pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV), developers can easily ingest streaming event data from mobile applications, transform this data, and publish APIs to serve real-time analytics. This tutorial will guide you through creating a real-time mobile analytics API. You'll learn how to ingest event data from mobile apps, transform this data to derive meaningful insights, and then publish APIs to access these insights in real time. 

## Understanding the data

Imagine your data looks like this:

```json
{
  "event_id": "evt_254834",
  "user_id": "user_4834",
  "event_type": "error",
  "event_time": "2025-05-11 22:01:58",
  "app_version": "5.4.4",
  "device_type": "Desktop",
  "os_version": "15.4",
  "country": "FR",
  "properties": "{\"screen\":\"product\",\"value\":834}",
  "session_id": "sess_4834"
}
```

This sample represents an event logged by a mobile application, capturing details such as the event type, user, and device information. To store and query this data efficiently in Tinybird, you need to create a data source. Here's how you define the `app_events` data source in Tinybird:

```json
{
  "DESCRIPTION": "Mobile application events data source for storing all app events",
  "SCHEMA": [
    {"name": "event_id", "type": "String", "json_path": "$.event_id"},
    {"name": "user_id", "type": "String", "json_path": "$.user_id"},
    {"name": "event_type", "type": "String", "json_path": "$.event_type"},
    {"name": "event_time", "type": "DateTime", "json_path": "$.event_time"},
    {"name": "app_version", "type": "String", "json_path": "$.app_version"},
    {"name": "device_type", "type": "String", "json_path": "$.device_type"},
    {"name": "os_version", "type": "String", "json_path": "$.os_version"},
    {"name": "country", "type": "String", "json_path": "$.country"},
    {"name": "properties", "type": "String", "json_path": "$.properties"},
    {"name": "session_id", "type": "String", "json_path": "$.session_id"}
  ],
  "ENGINE": "MergeTree",
  "ENGINE_PARTITION_KEY": "toYYYYMM(event_time)",
  "ENGINE_SORTING_KEY": "event_time, event_type, user_id"
}
```

In this schema, we've defined columns corresponding to each piece of data we're interested in, along with their types. The sorting key is chosen to optimize query performance, especially for time-based queries and filtering by event type or user ID. To ingest data, Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request. Here's how you can send data to the `app_events` data source:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=app_events&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV" \
    -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
    -d '{
        "event_id": "e123456789",
        "user_id": "u987654321",
        "event_type": "app_open",
        "event_time": "2023-04-15 08:30:45",
        "app_version": "1.2.3",
        "device_type": "smartphone",
        "os_version": "iOS 16.2",
        "country": "US",
        "properties": "{\"key\":\"screen\",\"value\":\"home\"}",
        "session_id": "sess_abc123"
    }'
```

For event/streaming data, the Kafka connector is an excellent option for high-volume, real-time data ingestion. For batch or file-based data, you can use the [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) or S3 connector, depending on your data source. 

## Transforming data and publishing APIs

With your data flowing into Tinybird, the next step is to transform this data and publish APIs to access real-time insights. Tinybird's pipes enable you to do both. 

### Batch transformations and real-time views

First, let's assume you've created some [Materialized views](https://www.tinybird.co/docs/forward/work-with-data/optimize/materialized-views?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) to optimize your data pipeline. These views pre-aggregate or restructure your data to speed up query performance. Unfortunately, the original README does not include materialized views, so let's focus on the endpoint pipes. 

### API Endpoints

Each of the following pipes creates an API endpoint for a specific analysis or query:


#

### Events by Type

```sql
SELECT 
    event_type,
    count() as event_count
FROM app_events
WHERE 1=1
{% if defined(start_date) %}
AND event_time >= {{DateTime(start_date, '2023-01-01 00:00:00')}}
{% end %}
{% if defined(end_date) %}
AND event_time <= {{DateTime(end_date, '2023-12-31 23:59:59')}}
{% end %}
{% if defined(app_version) %}
AND app_version = {{String(app_version, 'all')}}
{% end %}
GROUP BY event_type
ORDER BY event_count DESC
```

This query aggregates events by type, allowing you to filter by date range and app version. Query parameters make this API flexible and adaptable to different use cases. 

#### Event Properties

```sql
SELECT 
    event_type,
    JSONExtractString(properties, 'key') as property_key,
    JSONExtractString(properties, 'value') as property_value,
    count() as count
FROM app_events
WHERE 1=1
{% if defined(event_type) %}
AND event_type = {{String(event_type, 'app_open')}}
{% end %}
{% if defined(start_date) %}
AND event_time >= {{DateTime(start_date, '2023-01-01 00:00:00')}}
{% end %}
{% if defined(end_date) %}
AND event_time <= {{DateTime(end_date, '2023-12-31 23:59:59')}}
{% end %}
GROUP BY event_type, property_key, property_value
ORDER BY count DESC
LIMIT 100
```

This endpoint allows you to drill down into the properties of specific event types, providing insights into additional data captured for each event. 

#### User Sessions

```sql
SELECT 
    date(event_time) as day,
    count(distinct session_id) as total_sessions,
    count(distinct user_id) as total_users,
    count(distinct session_id) / count(distinct user_id) as sessions_per_user
FROM app_events
WHERE 1=1
{% if defined(start_date) %}
AND event_time >= {{DateTime(start_date, '2023-01-01 00:00:00')}}
{% end %}
{% if defined(end_date) %}
AND event_time <= {{DateTime(end_date, '2023-12-31 23:59:59')}}
{% end %}
{% if defined(country) %}
AND country = {{String(country, 'US')}}
{% end %}
{% if defined(device_type) %}
AND device_type = {{String(device_type, 'all')}}
{% end %}
GROUP BY day
ORDER BY day DESC
```

This query calculates daily user session metrics, such as total sessions, unique users, and sessions per user, with filtering options for country and device type. 

## Deploying to production

To deploy these analytics APIs to production, use Tinybird's CLI with the `tb --cloud deploy` command. This command deploys your data sources and pipes to Tinybird Cloud, making your real-time analytics APIs scalable and production-ready. Tinybird manages resources as code, enabling integration with CI/CD pipelines and ensuring that your analytics backend is as agile as your application codebase. Use token-based authentication to secure your APIs and ensure that only authorized users can access your data. Here's an example command to call one of your deployed [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV):

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/events_by_type.json?token=%24TB_ADMIN_TOKEN&start_date=2023-01-01+00%3A00%3A00&end_date=2023-12-31+23%3A59%3A59&app_version=1.2.3&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV"
```


## Conclusion

Throughout this tutorial, you've seen how to ingest mobile app event data into Tinybird, transform it to derive insights, and publish real-time analytics APIs. Tinybird simplifies the process of building and scaling real-time analytics backends, freeing you to focus on what matters: delivering exceptional app experiences and insights. [Sign up for Tinybird](https://cloud.tinybird.co/signup?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) to build and deploy your first real-time data APIs in a few minutes.