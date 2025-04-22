# Customer Support Analytics API

This project provides a robust API for tracking and analyzing customer support ticket metrics, helping teams measure performance, identify bottlenecks, and improve customer satisfaction.

## Tinybird

### Overview

This Tinybird project provides a comprehensive customer support analytics API that enables tracking of support tickets, monitoring agent performance, analyzing SLA compliance, and identifying trends over time. It helps support teams improve their service quality by providing actionable insights.

### Data sources

#### support_tickets

This datasource stores raw data about customer support tickets, including creation time, response time, resolution time, agent details, and customer satisfaction scores.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=support_tickets" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "ticket_id": "T12345",
       "customer_id": "C789",
       "agent_id": "A123",
       "category": "billing",
       "priority": "high",
       "status": "resolved",
       "created_at": "2023-06-15 09:30:00",
       "first_response_at": "2023-06-15 09:45:00",
       "resolved_at": "2023-06-15 11:30:00",
       "satisfaction_score": 4,
       "tags": ["invoice", "payment"]
     }'
```

### Endpoints

#### time_trends

Analyzes time-based trends for support tickets, providing insights into ticket volumes, resolution rates, and average response/resolution times over specified periods.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/time_trends.json?token=$TB_ADMIN_TOKEN&time_interval=yyyy-MM-dd&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&category=billing"
```

#### sla_performance

Analyzes SLA performance for response and resolution times across different priority levels.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/sla_performance.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&high_priority_response_sla=30&medium_priority_response_sla=60&low_priority_response_sla=120"
```

#### agent_performance

Tracks individual agent performance metrics including resolution rates, satisfaction scores, and SLA compliance.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/agent_performance.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&agent_id=A123"
```

#### ticket_details

Retrieves detailed information about specific tickets with extensive filtering options.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/ticket_details.json?token=$TB_ADMIN_TOKEN&customer_id=C789&status=resolved&limit=50"
```

#### category_analysis

Analyzes ticket distribution and metrics by category, showing which types of issues are most common and their resolution metrics.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/category_analysis.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&priority=high"
```

#### ticket_metrics

Provides aggregate support ticket metrics with various filtering options for custom reporting.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/ticket_metrics.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&category=billing&priority=high"
```
