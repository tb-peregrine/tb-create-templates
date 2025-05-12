
## Tinybird

### Overview

This Tinybird project provides real-time analytics for real estate market trends. It ingests property listing data and exposes endpoints to analyze average prices by location, summarize market activity, and track price trends over time.

### Data Sources

#### property_listings

This data source contains property listing data, including price, location, and property details.

```
SCHEMA >
    `listing_id` String `json:$.listing_id`,
    `price` Float64 `json:$.price`,
    `bedrooms` Int32 `json:$.bedrooms`,
    `bathrooms` Float32 `json:$.bathrooms`,
    `sqft` Int32 `json:$.sqft`,
    `property_type` String `json:$.property_type`,
    `city` String `json:$.city`,
    `state` String `json:$.state`,
    `zip_code` String `json:$.zip_code`,
    `listing_date` DateTime `json:$.listing_date`,
    `status` String `json:$.status`,
    `days_on_market` Int32 `json:$.days_on_market`
```

Example ingestion:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=property_listings" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{"listing_id":"12345", "price":500000.0, "bedrooms":3, "bathrooms":2.0, "sqft":1500, "property_type":"Single Family", "city":"San Francisco", "state":"CA", "zip_code":"94101", "listing_date":"2024-01-15 12:00:00", "status":"active", "days_on_market":10}'
```

### Endpoints

#### avg_price_by_location

This endpoint calculates the average property prices by location, allowing filtering by state, city, property type, and date range.

Example usage:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/avg_price_by_location.json?token=$TB_ADMIN_TOKEN&state=CA&city=San Francisco&property_type=Single Family&start_date=2023-01-01 00:00:00&end_date=2023-12-31 23:59:59"
```

#### market_activity_summary

This endpoint provides a summary of market activity, including listing counts, average price, days on market, and square footage. It allows grouping by city, state or property type, and filtering by state, city, property type, and date range.

Example usage:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/market_activity_summary.json?token=$TB_ADMIN_TOKEN&group_by=state&state=CA&start_date=2023-01-01 00:00:00&end_date=2023-12-31 23:59:59"
```

#### price_trends_over_time

This endpoint analyzes property price trends over time, grouping by month and allowing filtering by state, city, property type, location_type(city or state), and date range.

Example usage:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/price_trends_over_time.json?token=$TB_ADMIN_TOKEN&property_type=Single Family&location_type=state&start_date=2023-01-01 00:00:00&end_date=2023-12-31 23:59:59"
```
