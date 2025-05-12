# Support Ticket Analysis API

This project provides an API for analyzing customer support ticket trends and metrics.

## Tinybird

### Overview

The Tinybird project sets up a data pipeline to ingest, analyze, and expose support ticket data via API endpoints. It allows for trend analysis, resolution time tracking, and category distribution analysis of support tickets.

### Data sources

#### support_tickets

This datasource stores support ticket data with information about the ticket lifecycle, including creation and resolution times, priorities, categories, and assignment details.

**Sample ingestion**:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=support_tickets" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "ticket_id": "TKT-12345",
       "customer_id": "CUST-789",
       "category": "billing",
       "subject": "Monthly invoice discrepancy",
       "description": "The amount on my invoice doesn't match my plan",
       "priority": "high",
       "status": "resolved",
       "created_at": "2023-09-15 10:30:00",
       "resolved_at": "2023-09-15 14:45:00",
       "assigned_to": "agent_123",
       "resolution_time_mins": 255
     }'
```

### Endpoints

#### resolution_time_analysis

This endpoint analyzes resolution times for support tickets, broken down by category and priority. It provides average, minimum, and maximum resolution times along with ticket counts.

**Usage**:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/resolution_time_analysis.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&category=billing"
```

**Parameters**:
- `start_date`: Filter tickets created after this date (format: YYYY-MM-DD HH:MM:SS)
- `end_date`: Filter tickets created before this date (format: YYYY-MM-DD HH:MM:SS)
- `category`: Filter by ticket category

#### ticket_volume_by_time

This endpoint tracks support ticket volume over time, allowing filtering by category, priority, and status to identify trends and patterns.

**Usage**:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/ticket_volume_by_time.json?token=$TB_ADMIN_TOKEN&start_date=2023-09-01%2000:00:00&end_date=2023-09-30%2023:59:59&category=billing&priority=high&status=resolved"
```

**Parameters**:
- `start_date`: Filter tickets created after this date (format: YYYY-MM-DD HH:MM:SS)
- `end_date`: Filter tickets created before this date (format: YYYY-MM-DD HH:MM:SS)
- `category`: Filter by ticket category
- `priority`: Filter by ticket priority
- `status`: Filter by ticket status

#### common_ticket_categories

This endpoint identifies the most common support ticket categories and their distribution, helping to prioritize resources and improvements.

**Usage**:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/common_ticket_categories.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59"
```

**Parameters**:
- `start_date`: Filter tickets created after this date (format: YYYY-MM-DD HH:MM:SS)
- `end_date`: Filter tickets created before this date (format: YYYY-MM-DD HH:MM:SS)
