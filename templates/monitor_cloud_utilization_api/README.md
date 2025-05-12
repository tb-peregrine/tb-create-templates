# Cloud Resource Monitoring API

A real-time API for monitoring cloud resource metrics and detecting anomalies.

## Tinybird

### Overview

This Tinybird project creates an API for monitoring cloud resource utilization metrics. It collects metrics data from various cloud resources, provides endpoints for querying this data, and includes anomaly detection to identify unusual resource behavior.

### Data sources

#### cloud_resource_metrics

This datasource stores raw metrics data from cloud resources such as CPU, memory, disk, and network utilization.

Example data ingestion:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=cloud_resource_metrics" \
  -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
  -d '{
    "timestamp": "2023-11-15 12:30:45",
    "resource_id": "i-0abc123def456",
    "resource_type": "ec2-instance",
    "resource_name": "web-server-01",
    "metric_name": "cpu_utilization",
    "metric_value": 78.5,
    "region": "us-east-1",
    "account_id": "123456789012",
    "environment": "production"
  }'
```

### Endpoints

#### get_resource_metrics

Returns raw resource metrics data with flexible filtering options.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_resource_metrics.json?token=$TB_ADMIN_TOKEN&resource_type=ec2-instance&metric_name=cpu_utilization&start_date=2023-11-15%2000:00:00&end_date=2023-11-15%2023:59:59&limit=100"
```

Parameters:
- `resource_id` (optional): Filter by specific resource ID
- `resource_type` (optional): Filter by resource type (e.g., ec2-instance, rds, lambda)
- `metric_name` (optional): Filter by metric name (e.g., cpu_utilization, memory_usage)
- `region` (optional): Filter by AWS region
- `environment` (optional): Filter by environment (e.g., production, staging)
- `start_date` (optional): Filter for metrics after this date/time (format: YYYY-MM-DD HH:MM:SS)
- `end_date` (optional): Filter for metrics before this date/time (format: YYYY-MM-DD HH:MM:SS)
- `limit` (optional, default: 1000): Maximum number of records to return

#### get_resource_summary

Returns summary statistics (avg, min, max) for resource metrics.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_resource_summary.json?token=$TB_ADMIN_TOKEN&resource_type=ec2-instance&metric_name=cpu_utilization&start_date=2023-11-15%2000:00:00&environment=production"
```

Parameters:
- `resource_type` (optional): Filter by resource type
- `metric_name` (optional): Filter by metric name
- `region` (optional): Filter by region
- `environment` (optional): Filter by environment
- `start_date` (optional, default: 24 hours ago): Beginning of time range
- `end_date` (optional, default: now): End of time range
- `limit` (optional, default: 100): Maximum number of records to return

#### get_resource_anomalies

Detects anomalies in resource metrics based on standard deviation from average values.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_resource_anomalies.json?token=$TB_ADMIN_TOKEN&resource_type=ec2-instance&metric_name=cpu_utilization&threshold=3.5"
```

Parameters:
- `resource_type` (optional): Filter by resource type
- `metric_name` (optional): Filter by metric name
- `region` (optional): Filter by region
- `environment` (optional): Filter by environment
- `start_date` (optional, default: 24 hours ago): Beginning of time range
- `end_date` (optional, default: now): End of time range
- `threshold` (optional, default: 3.0): Minimum standard deviation to consider as anomaly
- `limit` (optional, default: 100): Maximum number of records to return
