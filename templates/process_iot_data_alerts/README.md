# IoT Sensor Data API

A real-time API for processing, monitoring, and alerting on IoT sensor data.

## Tinybird

### Overview
This Tinybird project provides a complete solution for processing IoT sensor data, monitoring against thresholds, and generating alerts. It enables you to ingest sensor readings from various devices, set threshold values for different sensor types, and retrieve comprehensive analytics and alerts through API endpoints.

### Data Sources

#### iot_sensor_data
Stores raw IoT sensor data from various devices including measurements, timestamps, and location information.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=iot_sensor_data" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{"device_id":"dev-001","sensor_type":"temperature","value":24.5,"unit":"celsius","timestamp":"2023-06-15 10:30:00","location":"building-a"}'
```

#### sensor_thresholds
Stores threshold settings for different sensor types, defining the acceptable min and max values.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=sensor_thresholds" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{"sensor_type":"temperature","min_threshold":18.0,"max_threshold":30.0,"created_at":"2023-01-01 00:00:00","updated_at":"2023-01-01 00:00:00"}'
```

#### alerts
Stores alerts generated when sensor values cross the defined thresholds.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=alerts" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{"alert_id":"alert-123","device_id":"dev-001","sensor_type":"temperature","value":35.2,"threshold_value":30.0,"alert_type":"above_threshold","timestamp":"2023-06-15 11:45:00","status":"active"}'
```

### Endpoints

#### get_sensor_data
Retrieves sensor data with flexible filtering options by device, sensor type, location, and time range.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_sensor_data.json?token=$TB_ADMIN_TOKEN&device_id=dev-001&sensor_type=temperature&start_date=2023-06-01%2000:00:00&end_date=2023-06-30%2023:59:59&limit=50"
```

#### get_alerts
Retrieves alerts with filtering options for device, sensor type, alert type, status, and time range.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_alerts.json?token=$TB_ADMIN_TOKEN&device_id=dev-001&alert_type=above_threshold&status=active&start_date=2023-06-01%2000:00:00&end_date=2023-06-30%2023:59:59"
```

#### recent_alert_summary
Provides a summary of recent alerts grouped by device and sensor type, showing alert counts and types.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/recent_alert_summary.json?token=$TB_ADMIN_TOKEN&start_date=2023-06-01%2000:00:00&end_date=2023-06-30%2023:59:59"
```

#### manage_thresholds
Retrieves threshold settings for different sensor types.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/manage_thresholds.json?token=$TB_ADMIN_TOKEN&sensor_type=temperature"
```

#### check_thresholds
Checks if sensor values cross defined thresholds and returns potential alerts. Useful for monitoring and generating alerts.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/check_thresholds.json?token=$TB_ADMIN_TOKEN&device_id=dev-001&sensor_type=temperature"
```

#### sensor_stats
Provides statistical data about sensor readings including min, max, and average values.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/sensor_stats.json?token=$TB_ADMIN_TOKEN&device_id=dev-001&sensor_type=temperature&start_date=2023-06-01%2000:00:00&end_date=2023-06-30%2023:59:59"
```
