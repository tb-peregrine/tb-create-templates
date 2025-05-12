
# Database Query Performance Analytics API

## Tinybird

### Overview
This project creates a real-time API for analyzing database query performance. It ingests database query logs and provides endpoints to analyze query trends, performance by query type, and identify slow queries that may require optimization.

### Data sources

#### query_logs
Stores database query logs containing performance metrics such as duration, resource usage, and status information.

Example of how to ingest data:
```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=query_logs" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "query_id": "b3f1c8a5-7d84-4f93-9c64-8f7b36c5e1d2",
       "database": "production",
       "query_text": "SELECT * FROM users WHERE created_at > NOW() - INTERVAL 30 DAY",
       "query_type": "SELECT",
       "user": "analytics_user",
       "start_time": "2023-06-15 08:32:47",
       "end_time": "2023-06-15 08:32:49",
       "duration_ms": 2156.32,
       "rows_read": 1250000,
       "bytes_read": 524288000,
       "memory_usage": 67108864,
       "status": "completed",
       "error_message": "",
       "client_ip": "10.0.0.123"
     }'
```

### Endpoints

#### query_trends
Analyzes trends in query performance over time, grouped by hour. This helps identify performance patterns and potential degradation periods.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/query_trends.json?token=$TB_ADMIN_TOKEN&start_time=2023-06-01%2000:00:00&end_time=2023-06-30%2023:59:59&database=production&query_type=SELECT"
```

Parameters:
- `start_time`: DateTime (format: YYYY-MM-DD HH:MM:SS)
- `end_time`: DateTime (format: YYYY-MM-DD HH:MM:SS)
- `database`: String (optional)
- `query_type`: String (optional)

#### query_performance_by_type
Analyzes query performance metrics grouped by query type, helping identify which types of queries are consuming the most resources.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/query_performance_by_type.json?token=$TB_ADMIN_TOKEN&start_time=2023-06-01%2000:00:00&end_time=2023-06-30%2023:59:59&database=production&status=completed"
```

Parameters:
- `start_time`: DateTime (format: YYYY-MM-DD HH:MM:SS)
- `end_time`: DateTime (format: YYYY-MM-DD HH:MM:SS)
- `database`: String (optional)
- `status`: String (optional)

#### slow_queries
Identifies and provides details about slow queries that exceed a specified duration threshold, helping teams focus on optimization opportunities.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/slow_queries.json?token=$TB_ADMIN_TOKEN&duration_threshold_ms=2000&start_time=2023-06-01%2000:00:00&end_time=2023-06-30%2023:59:59&limit=50"
```

Parameters:
- `duration_threshold_ms`: Float64 (default: 1000)
- `start_time`: DateTime (format: YYYY-MM-DD HH:MM:SS)
- `end_time`: DateTime (format: YYYY-MM-DD HH:MM:SS)
- `database`: String (optional)
- `query_type`: String (optional)
- `limit`: Int32 (default: 100)
