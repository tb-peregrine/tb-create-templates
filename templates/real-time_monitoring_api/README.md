
# Service Health Monitoring API

## Tinybird

### Overview
This project provides a real-time API for monitoring microservice health metrics. It tracks various performance indicators such as response times, request counts, and error rates across different services and endpoints, enabling real-time monitoring and analysis of system health.

### Data Sources

#### service_health_metrics
This datasource stores health metrics for various microservices including response times, status codes, and error counts.

**Ingestion Example:**
```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=service_health_metrics" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
           "timestamp": "2023-01-01 10:00:00",
           "service_name": "auth-service",
           "endpoint": "/login",
           "response_time_ms": 150,
           "status_code": 200,
           "error_count": 0,
           "request_count": 100
         }'
```

### Endpoints

#### endpoint_performance
This endpoint analyzes performance metrics for specific service endpoints, providing average, maximum, and minimum response times, as well as request counts and error rates.

**Usage Example:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/endpoint_performance.json?token=$TB_ADMIN_TOKEN&service_name=auth-service&endpoint=/login&start_date=2023-01-01%2000:00:00&end_date=2023-01-02%2000:00:00"
```

**Parameters:**
- `service_name` (optional): Filter by service name (default: 'auth-service')
- `endpoint` (optional): Filter by endpoint path (default: '/login')
- `start_date` (optional): Start date for filtering (format: YYYY-MM-DD HH:MM:SS, default: 1 day ago)
- `end_date` (optional): End date for filtering (format: YYYY-MM-DD HH:MM:SS, default: current time)

#### service_timeseries_metrics
This endpoint provides time series metrics for service health analysis, allowing you to track performance trends over time.

**Usage Example:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/service_timeseries_metrics.json?token=$TB_ADMIN_TOKEN&service_name=auth-service&interval=1%20hour&start_date=2023-01-01%2000:00:00&end_date=2023-01-02%2000:00:00"
```

**Parameters:**
- `service_name` (optional): Filter by service name (default: 'auth-service')
- `interval` (optional): Time bucket interval (default: '1 hour')
- `start_date` (optional): Start date for filtering (format: YYYY-MM-DD HH:MM:SS, default: 1 day ago)
- `end_date` (optional): End date for filtering (format: YYYY-MM-DD HH:MM:SS, default: current time)

#### service_health_overview
This endpoint provides a high-level overview of service health metrics across all services.

**Usage Example:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/service_health_overview.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-01-02%2000:00:00"
```

**Parameters:**
- `start_date` (optional): Start date for filtering (format: YYYY-MM-DD HH:MM:SS, default: 1 day ago)
- `end_date` (optional): End date for filtering (format: YYYY-MM-DD HH:MM:SS, default: current time)
