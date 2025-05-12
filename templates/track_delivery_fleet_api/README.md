# Delivery Fleet Tracking API

## Tinybird

This project provides a real-time API for tracking the movements and status of a delivery fleet. It includes endpoints for retrieving the current location of a vehicle, historical movements, and a summary of the entire fleet.

### Overview

The API leverages Tinybird to ingest, store, and query real-time data about delivery vehicle movements. By using Tinybird's SQL engine and API endpoint capabilities, we can efficiently track and analyze fleet data.

### Data sources

#### `fleet_movements`

This datasource stores the real-time data about each vehicle's location, speed, and status.

**Schema:**

*   `event_time` (DateTime): The timestamp of the event.
*   `vehicle_id` (String): The unique identifier of the vehicle.
*   `latitude` (Float64): The latitude of the vehicle's location.
*   `longitude` (Float64): The longitude of the vehicle's location.
*   `speed` (Float32): The speed of the vehicle.
*   `status` (String): The current status of the vehicle (e.g., "en route", "delivered", "idle").

**Ingestion Example:**

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=fleet_movements" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{"event_time":"2024-01-01 12:00:00","vehicle_id":"vehicle_123","latitude":37.7749,"longitude":-122.4194,"speed":60.5,"status":"en route"}'
```

### Endpoints

#### `current_location`

This endpoint returns the current location of a specified vehicle.

**Usage Example:**

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/current_location.json?token=$TB_ADMIN_TOKEN&vehicle_id=vehicle_123"
```

#### `vehicle_history`

This endpoint returns the historical movements of a specific vehicle within a given time range.

**Usage Example:**

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/vehicle_history.json?token=$TB_ADMIN_TOKEN&vehicle_id=vehicle_123&start_time=2024-01-01 00:00:00&end_time=2024-01-01 23:59:59"
```

#### `fleet_summary`

This endpoint provides a summary of the entire fleet's current status, including the last known location and status of each vehicle.

**Usage Example:**

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/fleet_summary.json?token=$TB_ADMIN_TOKEN"
```
