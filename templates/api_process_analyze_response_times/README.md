
# Customer Support Response Time Analytics API

## Tinybird

### Overview

This project provides a real-time API for analyzing customer support ticket response times and agent performance. It enables organizations to track SLA compliance, evaluate agent efficiency, and identify trends in customer support operations.

### Data sources

#### support_tickets

This datasource stores customer support tickets with timestamps for tracking response and resolution times.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=support_tickets" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "ticket_id": "TKT-12345",
       "customer_id": "CUST-789",
       "agent_id": "AGT-101",
       "priority": "high",
       "category": "technical",
       "status": "resolved",
       "created_at": "2023-01-15 09:30:00",
       "first_response_at": "2023-01-15 09:45:00",
       "resolved_at": "2023-01-15 11:30:00",
       "response_time_seconds": 900,
       "resolution_time_seconds": 7200
     }'
```

### Endpoints

#### average_response_time

Calculates average response time for customer support tickets with filtering capabilities.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/average_response_time.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&time_range=week&group_by=category&priority=high"
```

Parameters:
- `start_date`: Filter tickets created after this date (format: YYYY-MM-DD HH:MM:SS)
- `end_date`: Filter tickets created before this date (format: YYYY-MM-DD HH:MM:SS)
- `time_range`: Group results by 'day', 'week', or 'month'
- `group_by`: Dimension to group results ('agent', 'category', or 'priority')
- `priority`: Filter by ticket priority
- `category`: Filter by ticket category
- `agent_id`: Filter by specific agent

#### sla_compliance_report

Generates reports on SLA compliance for response and resolution times.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/sla_compliance_report.json?token=$TB_ADMIN_TOKEN&time_grouping=month&response_sla=3600&resolution_sla=86400&priority=high"
```

Parameters:
- `time_grouping`: Group results by 'day', 'week', or 'month'
- `response_sla`: SLA threshold for response time in seconds (default: 3600)
- `resolution_sla`: SLA threshold for resolution time in seconds (default: 86400)
- `start_date`: Filter tickets created after this date (format: YYYY-MM-DD HH:MM:SS)
- `end_date`: Filter tickets created before this date (format: YYYY-MM-DD HH:MM:SS)
- `priority`: Filter by ticket priority
- `category`: Filter by ticket category

#### agent_performance

Evaluates customer support agent performance metrics.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/agent_performance.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&sort_by=resolution_rate&sla_response_time=3600&sla_resolution_time=86400"
```

Parameters:
- `start_date`: Filter tickets created after this date (format: YYYY-MM-DD HH:MM:SS)
- `end_date`: Filter tickets created before this date (format: YYYY-MM-DD HH:MM:SS)
- `sort_by`: Sort results by 'response_time', 'resolution_time', 'ticket_volume', or 'resolution_rate'
- `sla_response_time`: SLA threshold for response time in seconds (default: 3600)
- `sla_resolution_time`: SLA threshold for resolution time in seconds (default: 86400)

#### resolution_time_analysis

Analyzes ticket resolution times by various dimensions.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/resolution_time_analysis.json?token=$TB_ADMIN_TOKEN&group_by=priority&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59"
```

Parameters:
- `group_by`: Dimension to analyze ('agent', 'category', or 'priority')
- `start_date`: Filter tickets created after this date (format: YYYY-MM-DD HH:MM:SS)
- `end_date`: Filter tickets created before this date (format: YYYY-MM-DD HH:MM:SS)
- `priority`: Filter by ticket priority
- `category`: Filter by ticket category
