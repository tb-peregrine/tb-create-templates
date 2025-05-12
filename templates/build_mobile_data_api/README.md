# Mobile Analytics API

## Tinybird

### Overview
This project provides a simple API for analyzing streaming event data from mobile applications. It enables tracking and analyzing various mobile app events, such as app opens, button clicks, purchases, and user behavior, allowing you to gain insights into user engagement and app performance.

### Data Sources

#### app_events
This data source stores all events from mobile applications, including user interactions, system events, and metrics. Each event contains metadata about the user, device, and context of the event.

**Sample Data Ingestion**:
```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=app_events" \
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

### Endpoints

#### events_by_type
This endpoint provides aggregated event counts by event type, with options to filter by date range and app version.

**Sample Usage**:
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/events_by_type.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&app_version=1.2.3"
```

#### event_properties
This endpoint allows exploration of event properties for specific event types, helping to understand what additional data is being captured for each event type.

**Sample Usage**:
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/event_properties.json?token=$TB_ADMIN_TOKEN&event_type=app_open&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59"
```

#### user_sessions
This endpoint provides daily session metrics, including total sessions, unique users, and sessions per user, with filtering options for country and device type.

**Sample Usage**:
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_sessions.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&country=US&device_type=smartphone"
```
