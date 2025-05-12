# Home Automation Monitoring API

## Tinybird

### Overview
This Tinybird project provides a real-time API for monitoring home automation systems. It ingests events from various home devices (thermostats, lights, motion sensors, door sensors) and exposes endpoints to monitor room temperature, device history, and current device status.

### Data sources

#### home_automation_events
This datasource stores all events from various home automation devices. Each record contains information about the device, its location, event type, status, and measurements.

**Sample ingestion:**
```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=home_automation_events" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "device_id": "thermo_123",
       "device_type": "thermostat",
       "room": "living_room",
       "event_type": "temperature_reading",
       "status": "active",
       "value": 22.5,
       "battery_level": 85.0,
       "timestamp": "2023-06-15 14:30:00"
     }'
```

### Endpoints

#### room_temperature
Returns the average temperature in each room that has thermostats, with optional date range filtering.

**Sample request:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/room_temperature.json?token=$TB_ADMIN_TOKEN&start_date=2023-06-01%2000:00:00&end_date=2023-06-15%2023:59:59"
```

#### device_history
Returns historical data for a specific device over a time period.

**Sample request:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/device_history.json?token=$TB_ADMIN_TOKEN&device_id=thermo_123&start_date=2023-06-01%2000:00:00&end_date=2023-06-15%2023:59:59&limit=50"
```

#### device_status
Returns the current status of devices in the home automation system, with optional filtering by device type or room.

**Sample request:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/device_status.json?token=$TB_ADMIN_TOKEN&device_type=thermostat&room=living_room&min_battery=20"
```
