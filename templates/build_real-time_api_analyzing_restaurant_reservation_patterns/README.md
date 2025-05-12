
# Restaurant Reservation Analytics API

A real-time API built with Tinybird for analyzing restaurant reservation patterns and occupancy.

## Tinybird

### Overview

This project provides a real-time analytics API for restaurant reservations. It allows restaurants to monitor daily and hourly reservation patterns, track reservation statuses, and analyze guest volumes to optimize staffing and table management.

### Data Sources

#### Reservations

Stores restaurant reservation data including customer information, reservation time, and party size.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=reservations" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "reservation_id": "res12345",
       "restaurant_id": "rest123",
       "customer_id": "cust789",
       "reservation_time": "2023-05-15 19:30:00",
       "party_size": 4,
       "status": "confirmed",
       "created_at": "2023-05-10 14:22:00",
       "special_requests": "Window table preferred",
       "table_number": "A12"
     }'
```

### Endpoints

#### Restaurant Daily Occupancy

Shows daily occupancy patterns for a restaurant, with the total reservations and guests by day.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/restaurant_daily_occupancy.json?token=$TB_ADMIN_TOKEN&restaurant_id=rest123&start_date=2023-01-01&end_date=2023-12-31"
```

#### Restaurant Hourly Reservations

Analyzes reservation patterns by hour for a specific restaurant.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/restaurant_hourly_reservations.json?token=$TB_ADMIN_TOKEN&restaurant_id=rest123&date_from=2023-01-01 00:00:00&date_to=2023-12-31 23:59:59"
```

#### Reservation Status Summary

Provides a summary of reservation statuses for a restaurant with counts by status type.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/reservation_status_summary.json?token=$TB_ADMIN_TOKEN&restaurant_id=rest123&start_date=2023-01-01 00:00:00&end_date=2023-12-31 23:59:59"
```
