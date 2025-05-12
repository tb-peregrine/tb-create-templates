# Parking Space API

## Tinybird

### Overview
This Tinybird project provides an API for tracking and querying parking space availability across multiple parking lots. It enables real-time monitoring of available parking spaces and provides historical analysis of parking usage patterns.

### Data sources

#### parking_spaces
This data source stores parking space availability information including parking lot identification, location, total number of spaces, and real-time availability metrics.

Example of how to ingest data:
```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=parking_spaces" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{"parking_lot_id":"A123","location":"Downtown","total_spaces":200,"available_spaces":45,"occupied_spaces":155,"timestamp":"2023-09-15 08:30:00"}'
```

### Endpoints

#### current_availability
Returns the current availability of parking spaces across all parking lots or for a specific lot.

Example usage:
```bash
# Get availability for all parking lots
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/current_availability.json?token=$TB_ADMIN_TOKEN"

# Get availability for a specific parking lot
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/current_availability.json?token=$TB_ADMIN_TOKEN&parking_lot_id=A123"

# Get availability for a specific location
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/current_availability.json?token=$TB_ADMIN_TOKEN&location=Downtown"
```

#### parking_lot_stats
Provides summary statistics for parking lots including average, minimum, and maximum available spaces.

Example usage:
```bash
# Get stats for all parking lots
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/parking_lot_stats.json?token=$TB_ADMIN_TOKEN"

# Get stats for a specific time period
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/parking_lot_stats.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01 00:00:00&end_date=2023-01-31 23:59:59"
```

#### availability_by_time
Analyzes parking space availability patterns over time, aggregated by hour.

Example usage:
```bash
# Get hourly availability patterns
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/availability_by_time.json?token=$TB_ADMIN_TOKEN"

# Get hourly patterns for a specific location and time period
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/availability_by_time.json?token=$TB_ADMIN_TOKEN&location=Downtown&start_date=2023-09-01 00:00:00&end_date=2023-09-15 23:59:59"
```
