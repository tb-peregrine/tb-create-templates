# Clickstream Analytics API

## Tinybird

### Overview
This project is an API for processing and analyzing clickstream data to provide insights into user journeys across a website or application. The API allows you to track user behavior, analyze session data, and identify popular pages.

### Data sources

#### clickstream_events
This datasource stores raw clickstream events from your website or application. It captures user interactions, page views, and session information with timestamps and device details.

**How to ingest data:**
```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=clickstream_events" \
    -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
    -d '{
        "event_id": "ev_12345",
        "user_id": "usr_abc123",
        "session_id": "sess_xyz789",
        "event_type": "pageview",
        "page_url": "https://example.com/products",
        "page_title": "Product Catalog",
        "referrer": "https://example.com/home",
        "timestamp": "2023-09-15 14:30:45",
        "device_type": "desktop",
        "browser": "chrome",
        "properties": "{\"scroll_depth\":75,\"time_on_page\":120}"
    }'
```

### Endpoints

#### get_user_journey
Retrieves the complete journey of a specific user across multiple sessions, showing how they navigate through your website.

**Usage:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_user_journey.json?token=$TB_ADMIN_TOKEN&user_id=usr_abc123&start_date=2023-09-01%2000:00:00&end_date=2023-09-30%2023:59:59"
```

**Parameters:**
- `user_id` (required): The ID of the user whose journey you want to analyze
- `start_date` (optional): Filter events starting from this date (format: YYYY-MM-DD HH:MM:SS)
- `end_date` (optional): Filter events until this date (format: YYYY-MM-DD HH:MM:SS)

#### get_session_events
Retrieves all events for a specific session, allowing you to analyze a user's behavior during a single visit.

**Usage:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_session_events.json?token=$TB_ADMIN_TOKEN&session_id=sess_xyz789"
```

**Parameters:**
- `session_id` (required): The ID of the session you want to analyze

#### get_popular_pages
Identifies the most popular pages on your website based on pageview count, helping you understand which content attracts the most attention.

**Usage:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_popular_pages.json?token=$TB_ADMIN_TOKEN&limit=5&start_date=2023-09-01%2000:00:00&end_date=2023-09-30%2023:59:59"
```

**Parameters:**
- `limit` (optional): Number of popular pages to return (default: 10)
- `start_date` (optional): Filter events starting from this date (format: YYYY-MM-DD HH:MM:SS)
- `end_date` (optional): Filter events until this date (format: YYYY-MM-DD HH:MM:SS)
