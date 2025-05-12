
# Industrial Equipment Predictive Maintenance API

## Tinybird

### Overview
This project provides an API for predictive maintenance insights for industrial equipment. It collects sensor data from industrial equipment and provides endpoints to analyze equipment health, detect anomalies, and track performance trends over time.

### Data sources

#### equipment_logs
This datasource stores raw data from industrial equipment sensors including temperature, vibration, pressure, noise levels, operational status, and maintenance indicators.

**Sample Ingestion:**
```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=equipment_logs" \
  -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
  -d '{
    "equipment_id": "EQ-1001",
    "timestamp": "2023-06-15 14:30:00",
    "temperature": 85.3,
    "vibration": 0.45,
    "pressure": 102.7,
    "noise_level": 72.5,
    "status": "normal",
    "maintenance_due": 0
  }'
```

### Endpoints

#### equipment_health
This endpoint provides overall health metrics and maintenance predictions for equipment. It calculates average readings and the ratio of abnormal readings to help identify equipment that needs attention.

**Parameters:**
- `equipment_id` (optional): Filter by specific equipment ID
- `start_date`: Start date for analysis (format: YYYY-MM-DD HH:MM:SS)
- `end_date`: End date for analysis (format: YYYY-MM-DD HH:MM:SS)

**Example Request:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/equipment_health.json?token=$TB_ADMIN_TOKEN&equipment_id=EQ-1001&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59"
```

#### equipment_anomalies
This endpoint detects anomalies in equipment readings based on statistical thresholds. It identifies readings that deviate significantly from the average (more than 3 standard deviations) across various metrics.

**Parameters:**
- `equipment_id` (optional): Filter by specific equipment ID
- `start_date`: Start date for analysis (format: YYYY-MM-DD HH:MM:SS)
- `end_date`: End date for analysis (format: YYYY-MM-DD HH:MM:SS)
- `limit`: Maximum number of records to return (default: 1000)

**Example Request:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/equipment_anomalies.json?token=$TB_ADMIN_TOKEN&equipment_id=EQ-1001&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&limit=500"
```

#### equipment_trends
This endpoint provides time-based trends for equipment metrics to identify patterns over time. Data is aggregated by day to show how metrics evolve.

**Parameters:**
- `equipment_id` (optional): Filter by specific equipment ID
- `start_date`: Start date for analysis (format: YYYY-MM-DD HH:MM:SS)
- `end_date`: End date for analysis (format: YYYY-MM-DD HH:MM:SS)

**Example Request:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/equipment_trends.json?token=$TB_ADMIN_TOKEN&equipment_id=EQ-1001&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59"
```
