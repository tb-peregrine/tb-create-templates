
## Tinybird

### Overview

This Tinybird project provides real-time analytics and insights into EV charging station usage. It offers endpoints to retrieve charging session data, analyze user behavior, and monitor station performance.

### Data sources

#### charging_sessions

This data source stores raw data about individual EV charging sessions.

To ingest data into the `charging_sessions` data source, you can use the following `curl` command:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=charging_sessions" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
           "session_id": "session123",
           "station_id": "station456",
           "user_id": "user789",
           "start_time": "2024-01-26 10:00:00",
           "end_time": "2024-01-26 11:00:00",
           "energy_consumed": 15.5,
           "amount_paid": 10.00,
           "charging_type": "AC",
           "location": "Main Street",
           "timestamp": "2024-01-26 10:00:00"
         }'
```

### Endpoints

#### user_usage

This endpoint retrieves usage statistics for individual EV charging users, including total sessions, energy consumed, amount spent, and station diversity.

To use the `user_usage` endpoint, you can use the following `curl` command:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_usage.json?token=$TB_ADMIN_TOKEN&amp;user_id=user789&amp;start_date=2024-01-01 00:00:00&amp;end_date=2024-01-31 23:59:59&amp;limit=10"
```

#### get_sessions

This endpoint retrieves charging sessions, allowing filtering by station ID, user ID, and time period.

To use the `get_sessions` endpoint, you can use the following `curl` command:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_sessions.json?token=$TB_ADMIN_TOKEN&amp;station_id=station456&amp;user_id=user789&amp;start_date=2024-01-01 00:00:00&amp;end_date=2024-01-31 23:59:59&amp;limit=10"
```

#### station_analytics

This endpoint provides analytics for charging stations, including total sessions, energy consumption, revenue, and session duration.

To use the `station_analytics` endpoint, you can use the following `curl` command:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/station_analytics.json?token=$TB_ADMIN_TOKEN&amp;location=Main Street&amp;start_date=2024-01-01 00:00:00&amp;end_date=2024-01-31 23:59:59&amp;limit=10"
```
