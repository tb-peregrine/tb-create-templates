# Build a Real-Time User Behavior Analytics API with Tinybird

Tinybird is a data analytics backend for software developers. You use Tinybird to build real-time analytics APIs without needing to set up or manage the underlying infrastructure. Tinybird offers a local-first development workflows, git-based deployments, resource definitions as code, and features for AI-native developers. This tutorial will guide you through creating a real-time analytics API leveraging Tinybird to track and analyze user behavior on websites or applications. You'll learn how to collect user events, analyze session data, view user timelines, and track activity metrics to better understand user engagement. The API you'll build with Tinybird focuses on capturing detailed information about user interactions, such as page views, clicks, and other events. By utilizing Tinybird's data sources and pipes, we can ingest, transform, and expose this data through scalable, real-time APIs. This tutorial will take you through setting up the data sources, transforming the data, and deploying the API [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints). ## Understanding the data

Imagine your data looks like this:

```json
{"event_id": "ev_73902", "user_id": "user_902", "session_id": "session_3902", "event_type": "scroll", "page_url": "https://example.com/about", "referrer": "https://twitter.com", "device_type": "tablet", "browser": "Safari", "country": "Canada", "city": "Toronto", "properties": "{\"button_id\":\"btn_2\",\"page_section\":\"main\"}", "timestamp": "2025-05-11 17:49:55"}
```

This data represents user events, capturing interactions such as scrolls, page views, and clicks, along with the user, session identifiers, and metadata like the device type, location, and custom properties. To store this data in Tinybird, you create a data source with a schema tailored to your data:

```json
DESCRIPTION >
    Tracks user events such as page views, clicks, and other interactions

SCHEMA >
    `event_id` String `json:$.event_id`,
    `user_id` String `json:$.user_id`,
    `session_id` String `json:$.session_id`,
    `event_type` String `json:$.event_type`,
    `page_url` String `json:$.page_url`,
    `referrer` String `json:$.referrer`,
    `device_type` String `json:$.device_type`,
    `browser` String `json:$.browser`,
    `country` String `json:$.country`,
    `city` String `json:$.city`,
    `properties` String `json:$.properties`,
    `timestamp` DateTime `json:$.timestamp`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(timestamp)"
ENGINE_SORTING_KEY "timestamp, user_id, event_type"
```

The schema design choices, such as the sorting key on `timestamp, user_id, event_type`, directly impact query performance by optimizing data access patterns. To ingest data into this source, Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request. This method ensures low latency and real-time data availability:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=user_events" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "event_id": "e123456",
       "user_id": "u789012",
       "session_id": "s345678",
       "event_type": "page_view",
       ... "timestamp": "2023-06-15 14:32:45"
     }'
```

Additionally, for batch or file data, the [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api) and S3 connector are available, along with a Kafka connector for streaming data. ## Transforming data and publishing APIs

Tinybird transforms data and publishes APIs through [pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes). Pipes can perform batch transformations, real-time transformations, and create API endpoints. Let's start by defining an endpoint for session-level statistics:

```sql
DESCRIPTION >
    Provides session-level statistics for user behavior

NODE user_session_stats_node
SQL >
    SELECT
        session_id,
        any(user_id) as user_id,
        min(timestamp) as session_start,
        ... any(country) as country
    FROM user_events
    WHERE 
        ... GROUP BY session_id
    ORDER BY session_start DESC
    LIMIT {{Int32(limit, 100)}}

TYPE endpoint
```

This SQL logic aggregates event data to provide session statistics, such as session duration and event counts, filtering by parameters like `user_id` and time range. The query parameters make the API flexible, allowing users to retrieve specific slices of the data. Now, for a timeline of user events:

```sql
DESCRIPTION >
    Provides a chronological timeline of events for a specific user

NODE user_event_timeline_node
SQL >
    SELECT
        event_id,
        ... timestamp
    FROM user_events
    WHERE user_id = {{String(user_id, '')}}
        ... ORDER BY timestamp DESC
    LIMIT {{Int32(limit, 100)}}

TYPE endpoint
```

This endpoint sorts events by timestamp, offering a detailed view of a user's interaction sequence. Finally, an endpoint for user activity metrics:

```sql
DESCRIPTION >
    Provides aggregated metrics on user activity over a time period

NODE user_activity_metrics_node
SQL >
    SELECT
        toDate(timestamp) as date,
        ... round(countIf(event_type = 'click') / countIf(event_type = 'page_view'), 2) as click_through_rate
    FROM user_events
    WHERE 
        ... GROUP BY date
    ORDER BY date DESC

TYPE endpoint
```

Here, data is aggregated to provide daily metrics on user activity, useful for trend analysis. ## Deploying to production

Deploying your project to the Tinybird Cloud is simple. Run `tb --cloud deploy` to create production-ready, scalable API endpoints. This command deploys all your [data sources](https://www.tinybird.co/docs/forward/get-data-in/data-sources) and pipes as defined in your project, ensuring your API is ready for real-world usage. Tinybird manages resources as code, facilitating integration with CI/CD pipelines and enabling a streamlined development to production workflow. For security, Tinybird uses token-based authentication:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_session_stats.json?token=$TB_ADMIN_TOKEN&..."
```

By including an authorization token, you ensure that only authorized users can access your APIs. ## Conclusion

Throughout this tutorial, we've built a real-time analytics API capable of tracking and analyzing user behavior on websites or applications. We've covered setting up data sources to ingest user events, transforming this data with pipes to generate actionable endpoints, and deploying these endpoints to production with Tinybird. By using Tinybird, you've learned how to leverage real-time data processing and API publication capabilities without the overhead of managing infrastructure. This solution enables software developers to focus on creating value from their data with minimal setup. [Sign up for Tinybird](https://cloud.tinybird.co/signup) to build and deploy your first real-time data APIs in a few minutes. Tinybird is free to start, with no time limit and no credit card required.