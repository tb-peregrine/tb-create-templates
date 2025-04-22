# API Monitoring Platform

This project provides a comprehensive API monitoring solution that allows you to track, analyze, and visualize API performance metrics including response times, success rates, and regional performance differences.

## Tinybird

### Overview

This Tinybird project implements a real-time API monitoring system that ingests API logs and provides several analytical endpoints for monitoring performance. It allows you to identify slow requests, analyze response time statistics with percentiles, track performance trends over time, and compare performance across different geographic regions.

### Data sources

#### api_logs

This datasource stores detailed API request logs including timestamps, endpoint information, response times, and success indicators. It's optimized for time-series analysis with appropriate partitioning and sorting keys.

**Sample ingestion:**

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=api_logs" \
    -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
    -d '{
        "timestamp": "2023-10-15 14:30:00", 
        "api_id": "payment-api", 
        "endpoint": "/v1/process", 
        "method": "POST", 
        "status_code": 200, 
        "response_time_ms": 150, 
        "user_id": "user-123", 
        "region": "us-east", 
        "success": 1
    }'
```

### Endpoints

#### api_slow_requests

Identifies API requests that exceed a configurable response time threshold, helping you pinpoint performance issues quickly.

**Sample usage:**

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/api_slow_requests.json?token=$TB_ADMIN_TOKEN&threshold_ms=500&api_id=payment-api"
```

**Parameters:**
- `threshold_ms`: Minimum response time in milliseconds to be considered slow (default: 1000)
- `api_id`: Filter by specific API ID (optional)
- `endpoint`: Filter by specific endpoint (optional)
- `method`: Filter by HTTP method (optional)
- `start_date`: Start of date range (format: YYYY-MM-DD HH:MM:SS, default: 24 hours ago)
- `end_date`: End of date range (format: YYYY-MM-DD HH:MM:SS, default: now)
- `limit`: Maximum number of results to return (default: 100)

#### api_response_time_stats

Provides comprehensive statistics about API response times including averages and various percentiles (p50, p90, p95, p99).

**Sample usage:**

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/api_response_time_stats.json?token=$TB_ADMIN_TOKEN&start_date=2023-10-01%2000:00:00"
```

**Parameters:**
- `api_id`: Filter by specific API ID (optional)
- `endpoint`: Filter by specific endpoint (optional)
- `method`: Filter by HTTP method (optional)
- `start_date`: Start of date range (format: YYYY-MM-DD HH:MM:SS, default: 24 hours ago)
- `end_date`: End of date range (format: YYYY-MM-DD HH:MM:SS, default: now)

#### api_response_time_by_time

Shows how API response times trend over time with configurable time intervals and percentile analysis.

**Sample usage:**

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/api_response_time_by_time.json?token=$TB_ADMIN_TOKEN&interval=1%20hour&group_by_endpoint=true"
```

**Parameters:**
- `interval`: Time bucket size (e.g., '15 minute', '1 hour', '1 day', default: '15 minute')
- `api_id`: Filter by specific API ID (optional)
- `endpoint`: Filter by specific endpoint (optional)
- `method`: Filter by HTTP method (optional)
- `group_by_endpoint`: Set to true to group results by endpoint (optional)
- `group_by_method`: Set to true to group results by HTTP method (optional)
- `start_date`: Start of date range (format: YYYY-MM-DD HH:MM:SS, default: 24 hours ago)
- `end_date`: End of date range (format: YYYY-MM-DD HH:MM:SS, default: now)

#### api_response_time_by_region

Analyzes API performance across different geographic regions to help identify regional performance issues.

**Sample usage:**

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/api_response_time_by_region.json?token=$TB_ADMIN_TOKEN&region=us-east"
```

**Parameters:**
- `api_id`: Filter by specific API ID (optional)
- `endpoint`: Filter by specific endpoint (optional)
- `region`: Filter by specific region (optional)
- `group_by_endpoint`: Set to true to group results by endpoint (optional)
- `start_date`: Start of date range (format: YYYY-MM-DD HH:MM:SS, default: 24 hours ago)
- `end_date`: End of date range (format: YYYY-MM-DD HH:MM:SS, default: now)
