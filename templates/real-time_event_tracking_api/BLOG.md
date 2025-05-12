# Build a Real-Time Event Tracking API with Tinybird

Tracking and analyzing user events in real-time is crucial for understanding user behavior across web and mobile applications. Whether you're monitoring page views, sign-ups, or purchases, the ability to query and analyze this data instantly can provide a competitive edge. This tutorial will guide you through creating a real-time analytics solution using Tinybird, a data analytics backend for software developers. With Tinybird, you can build real-time analytics APIs without the hassle of setting up or managing the underlying infrastructure. This tutorial leverages Tinybird's data sources and pipes to ingest, transform, and expose user event data through API [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints). ## Understanding the data

Imagine your data looks like this:

```json
{"event_id": "ev_46755", "event_type": "page_view", "user_id": "user_755", "session_id": "sess_1755", "timestamp": "2025-05-12 07:04:14", "platform": "android", "app_version": "3.5.5", "device_type": "tablet", "os": "Windows", "country": "FR", "properties": "{\"referrer\":\"twitter\",\"value\":755}"}
```

This sample represents a typical event tracked from a web or mobile application, containing unique identifiers, event types, timestamps, platform details, and custom properties. Now, let's create a Tinybird data source to store this data:

```json
DESCRIPTION >
    Raw events from web and mobile applications

SCHEMA >
    `event_id` String `json:$.event_id`,
    `event_type` String `json:$.event_type`,
    `user_id` String `json:$.user_id`,
    `session_id` String `json:$.session_id`,
    `timestamp` DateTime `json:$.timestamp`,
    `platform` String `json:$.platform`,
    `app_version` String `json:$.app_version`,
    `device_type` String `json:$.device_type`,
    `os` String `json:$.os`,
    `country` String `json:$.country`,
    `properties` String `json:$.properties`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(timestamp)"
ENGINE_SORTING_KEY "timestamp, event_type, user_id"
```

The schema reflects the structure of our JSON events, with considerations for optimizing query performance through sorting keys. For data ingestion, Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request. It's designed for real-time data streaming with low latency, perfect for event tracking applications:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=events" \
    -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
    -d '{
      "event_id": "e123456",
      "event_type": "page_view",
      "user_id": "user_abc",
      "session_id": "sess_123",
      "timestamp": "2023-07-15 14:30:00",
      "platform": "web",
      "app_version": "1.2.3",
      "device_type": "desktop",
      "os": "Windows",
      "country": "US",
      "properties": "{\"page\":\"home\",\"referrer\":\"google\"}"
    }'
```

Additionally, Tinybird provides other ingestion methods such as the Kafka connector for event or streaming data and the [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api) or S3 connector for batch or file data. ## Transforming data and publishing APIs

With data ingestion set up, let's move on to transforming this data and publishing real-time APIs using Tinybird [pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes). ### Batch transformations and real-time transformations

Tinybird pipes allow for both batch and real-time data transformations. While this tutorial does not include [Materialized views](https://www.tinybird.co/docs/forward/work-with-data/optimize/materialized-views), they are a powerful feature for optimizing data pipelines by pre-aggregating data for faster query performance. ### Creating API endpoints

Let's create API endpoints to expose our transformed data. Here are three examples:


#### get_events

```sql
DESCRIPTION >
    Endpoint to query events with filtering options

NODE get_events_node
SQL >
    SELECT
        event_id,
        event_type,
        user_id,
        session_id,
        timestamp,
        platform,
        app_version,
        device_type,
        os,
        country,
        properties
    FROM events
    WHERE 1=1
    AND event_type = {{String(event_type, '')}}
    AND user_id = {{String(user_id, '')}}
    AND platform = {{String(platform, '')}}
    AND timestamp >= {{DateTime(start_date, '2023-01-01 00:00:00')}}
    AND timestamp <= {{DateTime(end_date, '2023-12-31 23:59:59')}}
    ORDER BY timestamp DESC
    LIMIT {{Int32(limit, 100)}}

TYPE endpoint
```

This endpoint queries raw events with various filtering options, such as event type and platform. The SQL logic demonstrates how to use query parameters to make the API flexible. #### user_activity

```sql
DESCRIPTION >
    Provides user activity data including session and event details

NODE user_activity_node
SQL >
    SELECT
        user_id,
        countDistinct(session_id) as session_count,
        count() as event_count,
        min(timestamp) as first_seen,
        max(timestamp) as last_seen,
        groupArray(10)(event_type) as recent_events,
        countDistinct(platform) as platforms_used
    FROM events
    WHERE user_id = {{String(user_id, '')}}
    GROUP BY user_id

TYPE endpoint
```

This endpoint provides detailed information about specific user activities, leveraging SQL's aggregate functions to compute session counts and event details. #### event_stats

```sql
DESCRIPTION >
    Provides aggregated statistics for events

NODE event_stats_node
SQL >
    SELECT
        event_type,
        count() as event_count,
        countDistinct(user_id) as unique_users,
        min(timestamp) as first_seen,
        max(timestamp) as last_seen,
        countDistinct(session_id) as session_count
    FROM events
    WHERE 1=1
    GROUP BY event_type
    ORDER BY event_count DESC

TYPE endpoint
```

This endpoint aggregates event data to provide statistics, such as event counts and unique user counts, showing the power of SQL for data analytics. ## Deploying to production

To deploy your project to Tinybird Cloud, use the following command:

```bash
tb --cloud deploy
```

This command creates production-ready, scalable API endpoints. Tinybird manages resources as code, integrating smoothly with CI/CD pipelines. For securing your APIs, Tinybird uses token-based authentication:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_events.json?token=$TB_ADMIN_TOKEN&event_type=page_view&platform=web"
```


## Conclusion

In this tutorial, you've learned how to build a real-time event tracking API using Tinybird. From ingesting data with the Events API to transforming this data and publishing API endpoints, Tinybird offers a comprehensive solution for real-time data analytics. By leveraging Tinybird's capabilities, you can focus on analyzing and understanding user behavior without worrying about the underlying infrastructure. [Sign up for Tinybird](https://cloud.tinybird.co/signup) to build and deploy your first real-time data APIs in a few minutes.