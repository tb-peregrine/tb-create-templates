
# Event Attendance Analytics API

This project provides a real-time API for analyzing event attendance patterns, allowing you to track check-ins, compare venues, and analyze attendance statistics.

## Tinybird

### Overview

This Tinybird project enables real-time analysis of event attendance data. It provides APIs to track check-in patterns, compare venue performance, and analyze attendance statistics for specific events.

### Data Sources

#### `event_attendance`

Records of attendance at different events, including user information and timestamps.

**Ingest data example:**

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=event_attendance" \
    -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
    -d '{
      "event_id": "event_001", 
      "user_id": "user_123", 
      "attendance_status": "checked_in", 
      "check_in_time": "2023-10-15 14:30:00", 
      "event_type": "conference", 
      "venue": "Convention Center", 
      "timestamp": "2023-10-15 14:30:00"
    }'
```

### Endpoints

#### `venue_attendance_comparison`

Compare attendance metrics across different venues or event types. This endpoint provides insights into which venues have the highest attendance rates and total check-ins.

**Example usage:**

```bash
# Get attendance comparison for all venues
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/venue_attendance_comparison.json?token=$TB_ADMIN_TOKEN"

# Filter by event type
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/venue_attendance_comparison.json?token=$TB_ADMIN_TOKEN&event_type=workshop"
```

#### `hourly_check_ins`

Analyze check-in patterns by hour of day for a specific event. This helps identify peak check-in times and optimize staffing.

**Example usage:**

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/hourly_check_ins.json?token=$TB_ADMIN_TOKEN&event_id=event_001"
```

#### `event_attendance_stats`

Retrieve comprehensive attendance statistics for a specific event, including total attendees, check-in rates, and attendance by status.

**Example usage:**

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/event_attendance_stats.json?token=$TB_ADMIN_TOKEN&event_id=event_001"
```
