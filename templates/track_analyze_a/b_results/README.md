
# A/B Testing Analytics API

This project provides a comprehensive API for tracking and analyzing A/B test results with statistical significance calculations.

## Tinybird

### Overview

This Tinybird project implements a complete A/B testing analytics platform. It allows you to track test events, analyze test results with statistical significance, segment users, and monitor metrics over time to make data-driven decisions for your product experiments.

### Data sources

#### ab_test_events

This data source stores raw events data for A/B tests including user interactions and conversions. It captures each interaction a user has with your application during an A/B test.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=ab_test_events" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
           "user_id": "u123456",
           "session_id": "sess_abcdef",
           "test_id": "test_001",
           "variant": "control",
           "event_type": "conversion",
           "event_name": "purchase",
           "value": 29.99,
           "timestamp": "2023-04-15 13:45:22",
           "metadata": "{\"country\":\"US\",\"device\":\"mobile\",\"browser\":\"chrome\"}"
         }'
```

#### ab_test_definitions

This data source stores the definitions of A/B tests including start date, end date, variants, and metrics to track. It serves as a configuration store for all your A/B tests.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=ab_test_definitions" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
           "test_id": "test_001",
           "test_name": "Homepage Redesign",
           "description": "Testing new homepage layout against current version",
           "start_date": "2023-04-01 00:00:00",
           "end_date": "2023-04-30 23:59:59",
           "variants": "[\"control\",\"variant_a\"]",
           "primary_metric": "purchase",
           "secondary_metrics": "[\"add_to_cart\",\"page_view\"]",
           "created_at": "2023-03-25 09:00:00",
           "updated_at": "2023-03-25 09:00:00",
           "status": "active"
         }'
```

### Endpoints

#### test_summary

This endpoint retrieves summary statistics for a specific A/B test, including conversion rates and revenue metrics.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/test_summary.json?token=$TB_ADMIN_TOKEN&test_id=test_001&metric=purchase&start_date=2023-04-01%2000:00:00&end_date=2023-04-30%2023:59:59"
```

#### segment_analysis

This endpoint analyzes A/B test results by user segments based on metadata, allowing you to understand how different user groups respond to your test variants.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/segment_analysis.json?token=$TB_ADMIN_TOKEN&test_id=test_001&segment_key=country&metric=purchase&start_date=2023-04-01%2000:00:00&end_date=2023-04-30%2023:59:59"
```

#### active_tests

This endpoint lists all active A/B tests, making it easy to check which experiments are currently running.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/active_tests.json?token=$TB_ADMIN_TOKEN&status=active"
```

#### test_significance

This endpoint calculates statistical significance between variants in an A/B test, helping you determine if your test results are statistically valid.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/test_significance.json?token=$TB_ADMIN_TOKEN&test_id=test_001&metric=purchase&start_date=2023-04-01%2000:00:00&end_date=2023-04-30%2023:59:59"
```

#### test_metrics_over_time

This endpoint tracks conversion metrics over time for each variant in an A/B test, allowing you to visualize trends and changes throughout the test period.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/test_metrics_over_time.json?token=$TB_ADMIN_TOKEN&test_id=test_001&metric=purchase&start_date=2023-04-01%2000:00:00&end_date=2023-04-30%2023:59:59"
```
