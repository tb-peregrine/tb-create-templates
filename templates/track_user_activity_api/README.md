
# Multi-Tenant User Session Tracking API

## Tinybird

### Overview
This project implements a user session tracking API for multi-tenant applications. It captures user activity across sessions and provides endpoints to analyze session data, view active sessions, and get detailed session information across different tenants.

### Data sources

#### user_sessions
Stores user session activity data across multiple tenants. Each record represents an event or action taken by a user during their session.

**Sample ingestion:**
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

### Endpoints

#### get_active_sessions
Returns active user sessions with filtering options by tenant, user, and time range.

**Sample request:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_active_sessions.json?token=$TB_ADMIN_TOKEN&tenant_id=tenant_42&from_date=2023-07-01%2000:00:00&to_date=2023-07-31%2023:59:59&limit=50"
```

Parameters:
- `tenant_id`: (optional) Filter by tenant ID
- `user_id`: (optional) Filter by user ID
- `from_date`: (optional) Start date in format YYYY-MM-DD HH:MM:SS
- `to_date`: (optional) End date in format YYYY-MM-DD HH:MM:SS
- `limit`: (optional) Maximum number of results to return, defaults to 100

#### tenant_activity_summary
Returns a summary of activity metrics by tenant, including session counts, user counts, and event totals.

**Sample request:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/tenant_activity_summary.json?token=$TB_ADMIN_TOKEN&from_date=2023-07-01%2000:00:00&to_date=2023-07-31%2023:59:59"
```

Parameters:
- `from_date`: (optional) Start date in format YYYY-MM-DD HH:MM:SS
- `to_date`: (optional) End date in format YYYY-MM-DD HH:MM:SS
- `limit`: (optional) Maximum number of tenants to return, defaults to 50

#### get_session_details
Returns detailed event information for a specific session.

**Sample request:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_session_details.json?token=$TB_ADMIN_TOKEN&session_id=sess_12345"
```

Parameters:
- `session_id`: (required) The session ID to get details for
