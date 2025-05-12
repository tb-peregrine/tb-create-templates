# Real-time Product Usage Analytics API

## Tinybird

This project provides a real-time API for analyzing product usage data. It leverages Tinybird to ingest, transform, and expose insights through low-latency endpoints.

### Overview

The goal is to provide a simple and efficient way to track user activity, feature usage, and overall product engagement. This allows for data-driven decision-making and real-time monitoring of key performance indicators.

### Data sources

#### events

This datasource stores raw event data collected from product usage. Each event represents a user interaction, feature usage, or any other relevant activity.

**Schema:**

```
`event_id` String `json:$.event_id`,
`user_id` String `json:$.user_id`,
`session_id` String `json:$.session_id`,
`event_type` String `json:$.event_type`,
`event_name` String `json:$.event_name`,
`page` String `json:$.page`,
`feature` String `json:$.feature`,
`properties` String `json:$.properties`,
`timestamp` DateTime `json:$.timestamp`
```

**Engine settings:**

```
ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(timestamp)"
ENGINE_SORTING_KEY "timestamp, user_id, event_type"
```

**Example ingestion:**

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=events" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{"event_id":"123e4567-e89b-12d3-a456-426614174000","user_id":"user123","session_id":"session456","event_type":"feature_click","event_name":"button_click","page":"homepage","feature":"search_bar","properties":"{\"query\":\"example\"}","timestamp":"2024-10-27 10:00:00"}'
```

### Endpoints

#### feature_usage

This endpoint analyzes usage patterns for specific features, providing insights into which features are most popular and actively used.

**Request:**

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/feature_usage.json?token=$TB_ADMIN_TOKEN&feature=search_bar&start_date=2024-10-26 00:00:00&end_date=2024-10-27 23:59:59"
```

**Parameters:**

*   `feature` (optional): Filter by a specific feature. If not provided, aggregates across all features.
*   `start_date` (optional): Filter events starting from this date (YYYY-MM-DD HH:MM:SS).
*   `end_date` (optional): Filter events until this date (YYYY-MM-DD HH:MM:SS).

#### user_session_details

This endpoint retrieves detailed information about user sessions, including start and end times, event counts, and types of events within the session.

**Request:**

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_session_details.json?token=$TB_ADMIN_TOKEN&user_id=user123&session_id=session456&start_date=2024-10-26 00:00:00&end_date=2024-10-27 23:59:59"
```

**Parameters:**

*   `user_id` (optional): Filter by a specific user ID.
*   `session_id` (optional): Filter by a specific session ID.
*   `start_date` (optional): Filter events starting from this date (YYYY-MM-DD HH:MM:SS).
*   `end_date` (optional): Filter events until this date (YYYY-MM-DD HH:MM:SS).

#### active_users

This endpoint provides the count of active users per day.

**Request:**

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/active_users.json?token=$TB_ADMIN_TOKEN&start_date=2024-10-26 00:00:00&end_date=2024-10-27 23:59:59&event_type=pageview"
```

**Parameters:**

*   `start_date` (optional): Filter events starting from this date (YYYY-MM-DD HH:MM:SS).
*   `end_date` (optional): Filter events until this date (YYYY-MM-DD HH:MM:SS).
*   `event_type` (optional): Filter by a specific event type (e.g., pageview). Defaults to 'pageview'.
