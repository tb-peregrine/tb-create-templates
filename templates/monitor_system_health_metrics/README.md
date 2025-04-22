
# System Health Monitoring API

## Tinybird

### Overview

This Tinybird project provides a comprehensive system health monitoring API that tracks system metrics, detects anomalies, and generates alerts when thresholds are exceeded. The API enables real-time monitoring of host performance metrics such as CPU, memory, disk usage, and network traffic, helping teams quickly identify and respond to system issues.

### Data Sources

#### system_metrics

Stores system health metrics data including CPU, memory, disk usage and network statistics for monitored hosts.

**Sample ingestion:**

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=system_metrics" \
    -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
    -d '{
        "timestamp": "2023-06-15 14:30:00",
        "host_id": "srv-001",
        "host_name": "web-server-1",
        "cpu_usage_percent": 45.2,
        "memory_usage_percent": 62.8,
        "disk_usage_percent": 78.5,
        "network_in_bytes": 1024000,
        "network_out_bytes": 512000,
        "system_load_1m": 1.25,
        "system_load_5m": 1.15,
        "system_load_15m": 0.95,
        "is_healthy": 1
    }'
```

#### system_alerts

Stores system alerts triggered when metrics exceed thresholds or anomalies are detected.

**Sample ingestion:**

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=system_alerts" \
    -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
    -d '{
        "alert_id": "alert-123",
        "timestamp": "2023-06-15 14:35:00",
        "host_id": "srv-001",
        "host_name": "web-server-1",
        "alert_type": "high_cpu",
        "metric_name": "cpu_usage_percent",
        "metric_value": 92.5,
        "threshold": 90.0,
        "severity": "critical",
        "message": "CPU usage exceeds critical threshold",
        "status": "active",
        "resolved_at": null
    }'
```

### Endpoints

#### get_host_metrics

Retrieves system metrics for specific hosts with optional time range and filtering.

**Sample usage:**

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_host_metrics.json?token=$TB_ADMIN_TOKEN&host_id=srv-001&start_time=2023-06-15%2000:00:00&end_time=2023-06-15%2023:59:59&limit=100"
```

#### get_system_alerts

Retrieves system alerts with various filtering options by host, alert type, severity and status.

**Sample usage:**

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_system_alerts.json?token=$TB_ADMIN_TOKEN&host_id=srv-001&severity=critical&status=active&start_time=2023-06-15%2000:00:00&end_time=2023-06-15%2023:59:59"
```

#### host_health_summary

Provides a summary of system health by host with average metrics and alert counts.

**Sample usage:**

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/host_health_summary.json?token=$TB_ADMIN_TOKEN&start_time=2023-06-14%2000:00:00&end_time=2023-06-15%2023:59:59"
```

#### metric_anomaly_detection

Detects anomalies in system metrics by comparing current values with historical averages.

**Sample usage:**

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/metric_anomaly_detection.json?token=$TB_ADMIN_TOKEN&recent_window_start=2023-06-15%2013:00:00&recent_window_end=2023-06-15%2014:00:00&historical_window_start=2023-06-08%2000:00:00&historical_window_end=2023-06-15%2012:00:00&z_score_threshold=3&only_anomalies=1"
```

#### alert_trends

Analyzes alert trends over time, showing frequency and distribution by type, severity, and host.

**Sample usage:**

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/alert_trends.json?token=$TB_ADMIN_TOKEN&start_time=2023-05-15%2000:00:00&end_time=2023-06-15%2023:59:59&group_by=day"
```
