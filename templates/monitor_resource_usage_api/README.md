# System Resource Monitoring API

This project provides a comprehensive API for monitoring system resources, detecting anomalies, and performing capacity planning.

## Tinybird

### Overview

This Tinybird project provides a complete system for monitoring server resources, detecting anomalies, analyzing usage trends, planning capacity, and providing system health overviews. It's designed to help system administrators efficiently monitor their infrastructure, identify issues before they become critical, and plan for future resource needs.

### Data sources

#### resource_thresholds

Stores customizable resource thresholds and alerting configurations per host or host group.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=resource_thresholds" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "host_id": "server-001",
       "host_group": "production",
       "cpu_threshold": 85.5,
       "memory_threshold": 90.0,
       "disk_threshold": 95.0,
       "load_threshold": 4.5,
       "alert_enabled": 1,
       "alert_cooldown_minutes": 30,
       "created_at": "2023-10-15 08:00:00",
       "updated_at": "2023-10-15 08:00:00"
     }'
```

#### system_metrics

Stores system resource metrics like CPU, memory, disk, and network usage.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=system_metrics" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "timestamp": "2023-10-15 08:30:00",
       "host_id": "server-001",
       "host_name": "web-server-1",
       "cpu_usage_percent": 65.8,
       "memory_usage_percent": 78.2,
       "disk_usage_percent": 82.5,
       "disk_free_gb": 45.3,
       "network_rx_bytes": 1250000,
       "network_tx_bytes": 890000,
       "system_load_1m": 2.4,
       "system_load_5m": 2.1,
       "system_load_15m": 1.9
     }'
```

### Endpoints

#### anomaly_detection

API to detect anomalies in system resource usage based on predefined thresholds.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/anomaly_detection.json?token=$TB_ADMIN_TOKEN&host_id=server-001&start_date=2023-10-01%2000:00:00&end_date=2023-10-15%2023:59:59&min_anomaly_score=10"
```

#### capacity_planning

API for capacity planning that predicts future resource usage based on historical trends.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/capacity_planning.json?token=$TB_ADMIN_TOKEN&host_id=server-001&start_date=2023-09-01%2000:00:00&end_date=2023-10-15%2023:59:59&forecast_months=6"
```

#### system_overview

API to get a high-level overview of system health across all hosts.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/system_overview.json?token=$TB_ADMIN_TOKEN&health_status=WARNING&sort_by=cpu"
```

#### resource_usage_trends

API to analyze resource usage trends over time with aggregation by different time periods.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/resource_usage_trends.json?token=$TB_ADMIN_TOKEN&host_id=server-001&time_bucket=day&start_date=2023-10-01%2000:00:00&end_date=2023-10-15%2023:59:59"
```

#### current_system_metrics

API to get the current system metrics with filtering capabilities.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/current_system_metrics.json?token=$TB_ADMIN_TOKEN&host_id=server-001&min_timestamp=2023-10-15%2000:00:00&max_timestamp=2023-10-15%2023:59:59"
```
