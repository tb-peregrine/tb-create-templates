
# A/B Testing Analytics API

## Tinybird

### Overview
This Tinybird project provides a real-time A/B testing analytics API. It enables tracking and analyzing the performance of A/B tests, including conversion rates, revenue metrics, and segment-based analysis to help make data-driven decisions about feature implementations.

### Data Sources

#### ab_test_events
This data source collects events from A/B tests, including test identification, user information, conversion data, and revenue metrics. Each event represents a user interaction within an A/B test variant.

**Sample Ingestion:**
```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=ab_test_events" \
  -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
  -d '{
    "timestamp": "2023-06-15 14:30:00",
    "user_id": "user_12345",
    "test_id": "homepage_redesign",
    "variant": "B",
    "event_type": "page_view",
    "conversion": 1,
    "revenue": 29.99,
    "session_id": "session_789012",
    "device": "mobile",
    "country": "US"
  }'
```

### Endpoints

#### test_summary
Provides aggregate metrics for each A/B test, including user counts, conversions, conversion rates, and revenue data. This endpoint helps compare the performance of different test variants.

**Sample Request:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/test_summary.json?token=$TB_ADMIN_TOKEN&test_id=homepage_redesign&start_date=2023-06-01%2000:00:00&end_date=2023-06-30%2023:59:59"
```

#### test_segments
Analyzes A/B test performance across different user segments, such as device type or country. This helps identify how different user groups respond to the test variants.

**Sample Request:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/test_segments.json?token=$TB_ADMIN_TOKEN&test_id=homepage_redesign&segment_by=device&start_date=2023-06-01%2000:00:00&end_date=2023-06-30%2023:59:59"
```

#### test_timeseries
Provides time-based metrics for A/B tests to analyze performance trends over time. This endpoint helps visualize how test performance evolves throughout the test duration.

**Sample Request:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/test_timeseries.json?token=$TB_ADMIN_TOKEN&test_id=homepage_redesign&interval=Day&start_date=2023-06-01%2000:00:00&end_date=2023-06-30%2023:59:59"
```
