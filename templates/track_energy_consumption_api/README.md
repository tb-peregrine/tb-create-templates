
# Energy Consumption Tracking API

This project provides an API to track and analyze energy consumption patterns across different devices and locations.

## Tinybird

### Overview

This Tinybird project allows you to collect energy consumption data from various devices, store it efficiently, and analyze consumption patterns through an API endpoint. The system is designed to help monitor and optimize energy usage by providing insights into consumption trends by device.

### Data Sources

#### energy_consumption

This datasource stores energy consumption data for various devices, including timestamp of the reading, device identifier, amount of energy consumed, and the location of the device.

**Ingesting data:**

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=energy_consumption" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "timestamp": "2023-11-15 08:30:00",
       "device_id": "device_123",
       "energy_consumed": 0.75,
       "location": "kitchen"
     }'
```

### Endpoints

#### energy_consumption_by_device

This endpoint calculates the total energy consumption for each device, allowing you to identify which devices consume the most energy.

**Example usage:**

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/energy_consumption_by_device.json?token=$TB_ADMIN_TOKEN"
```

This will return a JSON response with the total energy consumed by each device.

**Note:** Make sure both the datasource and pipe are properly deployed before trying to use the endpoint. 
