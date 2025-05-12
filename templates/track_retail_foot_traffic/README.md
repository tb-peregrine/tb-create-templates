
# Retail Foot Traffic Analytics API

A simple Tinybird-powered API for tracking and analyzing retail store foot traffic patterns.

## Tinybird

### Overview

This Tinybird project provides a real-time analytics API for retail store foot traffic data. It allows you to track visitor patterns, analyze traffic by store and time of day, and drill down into individual visitor behavior.

### Data sources

#### store_visits

This datasource stores raw data of customer visits to retail stores, including visit timestamps, entry/exit points, and dwell time.

**Ingestion example:**

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=store_visits" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{"visit_id":"v12345","store_id":"store001","timestamp":"2023-06-15 14:30:00","visitor_id":"cust789","entry_point":"main entrance","exit_point":"side door","dwell_time_seconds":1200,"tags":["loyalty member","weekday shopper"]}'
```

### Endpoints

#### visitor_details

This endpoint provides detailed information about specific visitors or the most recent visitors to stores.

```bash
# Get data for a specific visitor
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/visitor_details.json?token=$TB_ADMIN_TOKEN&visitor_id=cust789"

# Get latest visitors with optional date range
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/visitor_details.json?token=$TB_ADMIN_TOKEN&start_date=2023-06-01%2000:00:00&end_date=2023-06-30%2023:59:59&limit=50"
```

#### hourly_traffic_patterns

This endpoint analyzes traffic patterns by hour of day across all stores or for a specific store.

```bash
# Get hourly patterns for all stores
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/hourly_traffic_patterns.json?token=$TB_ADMIN_TOKEN"

# Get hourly patterns for a specific store and date range
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/hourly_traffic_patterns.json?token=$TB_ADMIN_TOKEN&store_id=store001&start_date=2023-06-01%2000:00:00&end_date=2023-06-30%2023:59:59"
```

#### visits_by_store

This endpoint provides aggregated visit metrics broken down by store with optional filtering.

```bash
# Get visit counts for all stores
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/visits_by_store.json?token=$TB_ADMIN_TOKEN"

# Get visit data for a specific store
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/visits_by_store.json?token=$TB_ADMIN_TOKEN&store_id=store001"

# Get visit data with date range filter
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/visits_by_store.json?token=$TB_ADMIN_TOKEN&start_date=2023-06-01%2000:00:00&end_date=2023-06-30%2023:59:59"
```
