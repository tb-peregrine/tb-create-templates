
# Log Anomaly Detection API

This project provides a real-time API for monitoring system logs and detecting anomalies based on configurable thresholds.

## Tinybird

### Overview

This Tinybird project implements a real-time log anomaly detection system. It ingests system logs, applies configurable thresholds to detect anomalies, and provides endpoints to retrieve both raw logs and anomaly information.

### Data sources

#### system_logs

Stores system logs containing messages, severity levels, timestamps, and other system information.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=system_logs" \
  -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
  -d '{
    "timestamp": "2023-06-01 14:30:00",
    "server_id": "srv-001",
    "service": "authentication",
    "severity": "ERROR",
    "message": "Failed login attempt",
    "error_code": "AUTH-401",
    "resource_id": "user-123",
    "metadata": "{\"ip\": \"192.168.1.1\", \"browser\": \"Chrome\"}"
  }'
```

#### log_anomaly_thresholds

Stores configurable thresholds for anomaly detection in system logs.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=log_anomaly_thresholds" \
  -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
  -d '{
    "service": "authentication",
    "severity": "ERROR",
    "threshold_per_minute": 10.5,
    "active": 1,
    "updated_at": "2023-06-01 12:00:00"
  }'
```

### Endpoints

#### recent_logs

Retrieves recent system logs with filtering options for time range, severity, and service.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/recent_logs.json?token=$TB_ADMIN_TOKEN&start_time=2023-06-01%2000:00:00&end_time=2023-06-02%2000:00:00&severity=ERROR&service=authentication&limit=50"
```

#### error_distribution

Provides distribution of errors by service and severity for a specified time range.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/error_distribution.json?token=$TB_ADMIN_TOKEN&start_time=2023-06-01%2000:00:00&end_time=2023-06-02%2000:00:00&severity=ERROR&service=authentication&limit=50"
```

#### log_anomalies

Detects anomalies in system logs based on frequency thresholds over time intervals.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/log_anomalies.json?token=$TB_ADMIN_TOKEN&time_window_minutes=60&service=authentication&severity=ERROR&limit=50"
```
