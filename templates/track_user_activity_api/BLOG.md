# Build a Multi-Tenant User Session Tracking API with Tinybird

Tracking user sessions and analyzing their behavior across different tenants in a multi-tenant application can be quite a challenge. This tutorial will guide you through building a user session tracking API that captures user activity across sessions and provides [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints) to analyze session data, view active sessions, and get detailed session information for multi-tenant applications using Tinybird. Tinybird is a data analytics backend for software developers. You use Tinybird to build real-time analytics APIs without needing to set up or manage the underlying infrastructure. Tinybird offers a local-first development workflow, git-based deployments, resource definitions as code, and features for AI-native developers. By leveraging Tinybird's data sources and pipes, we'll implement a scalable solution that allows us to ingest, transform, and query large volumes of session data in real-time. Let's dive into how we can achieve this. ## Understanding the data

Imagine your data looks like this:

```json
{"session_id": "sess_ffc43cbd9abd4ab7", "user_id": "user_85", "tenant_id": "tenant_85", "event_type": "pageview", "event_data": "{\"action\":\"view\",\"target\":\"home\"}", "page_url": "https://example.com/settings", "referrer": "https://example.com/home", "device_type": "tablet", "browser": "Firefox", "ip_address": "192.168.50.50", "created_at": "2025-05-07 16:41:42", "updated_at": "2025-05-07 16:41:42"}
```

This data represents an event or action taken by a user during their session, including metadata such as the session ID, user ID, tenant ID, event type, and various attributes related to the event. To store this data in Tinybird, we first need to create a data source:

```json
DESCRIPTION >
    Stores user session activity data for multi-tenant applications

SCHEMA >
    `session_id` String `json:$.session_id`,
    `user_id` String `json:$.user_id`,
    `tenant_id` String `json:$.tenant_id`,
    `event_type` String `json:$.event_type`,
    `event_data` String `json:$.event_data`,
    `page_url` String `json:$.page_url`,
    `referrer` String `json:$.referrer`,
    `device_type` String `json:$.device_type`,
    `browser` String `json:$.browser`,
    `ip_address` String `json:$.ip_address`,
    `created_at` DateTime `json:$.created_at`,
    `updated_at` DateTime `json:$.updated_at`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(created_at)"
ENGINE_SORTING_KEY "tenant_id, session_id, created_at"
```

This `.datasource` file defines the schema for our `user_sessions` data source, specifying the column types and how we expect to ingest the data (using JSON paths). The sorting key is chosen to optimize query performance by tenant, session, and creation time. Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request. This real-time nature and its low latency make it ideal for tracking user sessions:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=user_sessions" \
  -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
  -d '{
    "session_id": "sess_12345",
    "user_id": "user_789",
    "tenant_id": "tenant_42",
    "event_type": "page_view",
    "event_data": "{\"page\":\"dashboard\"}",
    "page_url": "https://app.example.com/dashboard",
    "referrer": "https://app.example.com/home",
    "device_type": "desktop",
    "browser": "Chrome",
    "ip_address": "192.168.1.1",
    "created_at": "2023-07-15 14:30:00",
    "updated_at": "2023-07-15 14:30:00"
  }'
```

For event/streaming data, the Kafka connector can provide additional benefits by allowing you to ingest data directly from a Kafka topic. For batch/file data, the [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api) and S3 connector offer flexible options for bulk ingestion. ## Transforming data and publishing APIs

In Tinybird, pipes are used for batch transformations (copies), real-time transformations ([Materialized views](https://www.tinybird.co/docs/forward/work-with-data/optimize/materialized-views)), and creating API endpoints. ### Active Sessions Endpoint

Consider the `get_active_sessions` endpoint, which returns active user sessions with filtering options by tenant, user, and time range:

```sql
DESCRIPTION >
    Get active sessions with optional filtering by tenant_id, time range, and user_id

NODE get_active_sessions_node
SQL >
    %
    SELECT 
        session_id,
        user_id,
        tenant_id,
        min(created_at) as session_start,
        max(updated_at) as last_activity,
        max(updated_at) - min(created_at) as session_duration_seconds,
        count() as event_count,
        groupArray(event_type) as events
    FROM user_sessions
    WHERE 1=1
    {% if defined(tenant_id) %}
        AND tenant_id = {{String(tenant_id, '')}}
    {% end %}
    {% if defined(user_id) %}
        AND user_id = {{String(user_id, '')}}
    {% end %}
    {% if defined(from_date) %}
        AND created_at >= {{DateTime(from_date, '2023-01-01 00:00:00')}}
    {% end %}
    {% if defined(to_date) %}
        AND created_at <= {{DateTime(to_date, '2023-12-31 23:59:59')}}
    {% end %}
    GROUP BY session_id, user_id, tenant_id
    ORDER BY last_activity DESC
    LIMIT {{Int32(limit, 100)}}

TYPE endpoint
```

This query aggregates session data, calculating metrics such as session duration and event count. It demonstrates the use of query parameters (`tenant_id`, `user_id`, `from_date`, and `to_date`) to filter the results. **Example API call:**

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/[pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes)/get_active_sessions.json?token=$TB_ADMIN_TOKEN&tenant_id=tenant_42&from_date=2023-07-01%2000:00:00&to_date=2023-07-31%2023:59:59&limit=50"
```

Similarly, the `tenant_activity_summary` and `get_session_details` endpoints provide summaries of tenant activity and detailed events for specific sessions, respectively. ## Deploying to production

Deploy your project to Tinybird Cloud using:

```bash
tb --cloud deploy
```

This command creates production-ready, scalable API endpoints. Tinybird manages resources as code, enabling integration with CI/CD pipelines. Token-based authentication secures your APIs, ensuring that only authorized users can access them. **Example API call:**

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_session_details.json?token=$TB_ADMIN_TOKEN&session_id=sess_12345"
```


## Conclusion

Throughout this tutorial, you've learned how to use Tinybird to build a multi-tenant user session tracking API. We've covered how to ingest data, transform it, and publish real-time analytics APIs. Tinybird's ability to process and query large volumes of data in real-time makes it an ideal choice for developers looking to implement scalable data analytics backends. [Sign up for Tinybird](https://cloud.tinybird.co/signup) to build and deploy your first real-time data APIs in a few minutes.