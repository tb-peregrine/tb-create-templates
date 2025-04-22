# Server Monitoring and Anomaly Detection API

An API for monitoring server logs, detecting anomalies, and triggering alerts based on predefined thresholds.

## Tinybird

### Overview

This Tinybird project provides APIs for server monitoring and anomaly detection. It enables you to ingest server logs, set up thresholds for different metrics, detect anomalies in real-time, and retrieve statistics on service health and error rates.

### Data Sources

#### server_logs

Stores server logs data for monitoring and anomaly detection. Contains details about server operations including resource usage, response times, and status codes.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=server_logs" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "timestamp": "2023-07-15 14:30:00",
       "server_id": "srv-001",
       "level": "ERROR",
       "message": "Connection timeout",
       "service": "api-gateway",
       "resource_usage": 85.7,
       "response_time": 5200,
       "status_code": 500,
       "user_id": "user-123",
       "request_id": "req-abc-123"
     }'
```

#### anomaly_thresholds

Stores configuration for anomaly detection thresholds. Defines when a metric value is considered anomalous for a specific service.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=anomaly_thresholds" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "metric": "resource_usage",
       "service": "api-gateway",
       "threshold_value": 90.0,
       "threshold_type": "upper_limit",
       "updated_at": "2023-07-01 12:00:00"
     }'
```

#### detected_anomalies

Stores information about detected anomalies, including when they were detected and their status.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=detected_anomalies" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "detected_at": "2023-07-15 14:35:00",
       "server_id": "srv-001",
       "service": "api-gateway",
       "metric": "resource_usage",
       "value": 95.2,
       "threshold": 90.0,
       "message": "High resource usage detected",
       "status": "open"
     }'
```

### Endpoints

#### get_logs

Retrieves server logs with various filtering options.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_logs.json?token=$TB_ADMIN_TOKEN&server_id=srv-001&service=api-gateway&level=ERROR&start_date=2023-07-15%2000:00:00&end_date=2023-07-16%2000:00:00&limit=50"
```

#### detect_resource_usage_anomalies

Identifies server instances where resource usage exceeds the configured threshold.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/detect_resource_usage_anomalies.json?token=$TB_ADMIN_TOKEN&service=api-gateway&start_date=2023-07-15%2000:00:00&end_date=2023-07-16%2000:00:00&limit=50"
```

#### detect_response_time_anomalies

Identifies server instances where response time exceeds the configured threshold.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/detect_response_time_anomalies.json?token=$TB_ADMIN_TOKEN&service=api-gateway&start_date=2023-07-15%2000:00:00&end_date=2023-07-16%2000:00:00&limit=50"
```

#### service_health_stats

Retrieves health statistics for services including response times, resource usage, and error rates.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/service_health_stats.json?token=$TB_ADMIN_TOKEN&service=api-gateway&start_date=2023-07-15%2000:00:00&end_date=2023-07-16%2000:00:00"
```

#### error_rate_by_service

Calculates error rates by service, categorizing errors as client or server errors.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/error_rate_by_service.json?token=$TB_ADMIN_TOKEN&service=api-gateway&start_date=2023-07-15%2000:00:00&end_date=2023-07-16%2000:00:00"
```

#### get_anomalies

Retrieves detected anomalies with various filtering options.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_anomalies.json?token=$TB_ADMIN_TOKEN&service=api-gateway&metric=resource_usage&status=open&start_date=2023-07-15%2000:00:00&end_date=2023-07-16%2000:00:00&limit=50"
```

#### manage_anomaly_thresholds

API to retrieve current anomaly detection thresholds.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/manage_anomaly_thresholds.json?token=$TB_ADMIN_TOKEN&metric=resource_usage&service=api-gateway"
```
