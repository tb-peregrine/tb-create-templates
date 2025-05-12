
# Tourist Movement Analytics API

This project provides a real-time API for analyzing tourist movement patterns, helping to understand visitor behavior and optimize tourism services.

## Tinybird

### Overview

This Tinybird project enables real-time analysis of tourist movement data, providing insights into visitor patterns, popular locations, and tourist demographics. The API supports filtering by time periods, locations, and activities, making it useful for tourism boards, city planners, and businesses in the hospitality industry.

### Data Sources

#### tourist_movements

This datasource stores records of tourist movements including location, timestamp, and tourist information. It serves as the primary data source for all analytics endpoints.

**Sample data ingestion:**

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=tourist_movements" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "tourist_id": "t12345",
       "location_id": "loc789",
       "location_name": "Sagrada Familia",
       "latitude": 41.4036,
       "longitude": 2.1744,
       "country": "Spain",
       "city": "Barcelona",
       "timestamp": "2023-06-15 14:30:00",
       "activity_type": "sightseeing",
       "duration_minutes": 120,
       "tourist_origin": "Germany",
       "age_group": "25-34"
     }'
```

### Endpoints

#### hourly_movement_patterns

Analyzes tourist movement patterns by hour of day, providing insights into peak visiting hours and duration trends.

**Sample request:**

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/hourly_movement_patterns.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&location_id=loc789&activity_type=sightseeing"
```

#### tourist_origin_analysis

Analyzes tourist movements by their country of origin, showing which nationalities visit most frequently and their behavior patterns.

**Sample request:**

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/tourist_origin_analysis.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&destination_country=Spain&limit=10"
```

#### popular_locations

Retrieves the most popular tourist locations within a given time period, ranked by visit count and showing additional metrics.

**Sample request:**

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/popular_locations.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&country=Spain&city=Barcelona&limit=5"
```
