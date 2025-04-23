
# Product Performance Monitoring API

An API for tracking and analyzing product performance metrics, including error rates, latency, page load times, and user engagement patterns.

## Tinybird

### Overview

This Tinybird project provides a comprehensive solution for monitoring product performance in real-time. It captures various metrics such as page load times, API latency, error rates, and user engagement across different products, devices, and geographic locations. The API enables product teams to identify performance issues, track error patterns, and understand user behavior to improve product quality and user experience.

### Data Sources

#### product_events

This data source captures raw events data related to product usage and performance. It stores information such as event type, user interactions, error codes, performance metrics, and contextual data about the device and location.

**Sample Ingestion:**

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=product_events" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
           "event_id": "e12345",
           "timestamp": "2023-06-15 10:30:45",
           "product_id": "prod-123",
           "product_name": "Analytics Dashboard",
           "event_type": "page_view",
           "user_id": "user-abc123",
           "duration_ms": 3500,
           "error_code": "",
           "page_load_time_ms": 1200,
           "api_latency_ms": 350,
           "is_error": 0,
           "source": "web-app",
           "device_type": "desktop",
           "country": "US"
         }'
```

### Endpoints

#### product_performance_overview

Provides a high-level overview of performance metrics for each product, including total events, error counts and rates, average page load times, API latency, and unique user counts within a specified time period.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/product_performance_overview.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&product_id=prod-123"
```

#### top_errors

Identifies the most frequent errors by error code for each product, helping teams prioritize which issues to fix first.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/top_errors.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&product_id=prod-123"
```

#### geographic_performance

Compares product performance metrics across different countries, allowing teams to identify region-specific issues or optimize for regional performance.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/geographic_performance.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&product_id=prod-123&country=US"
```

#### performance_by_device

Analyzes product performance metrics across different device types (desktop, mobile, tablet, etc.), revealing how device type impacts user experience.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/performance_by_device.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&product_id=prod-123"
```

#### error_rate_over_time

Tracks error rates for products over time with daily or hourly granularity, helping identify patterns or spikes in errors.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/error_rate_over_time.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&product_id=prod-123&granularity=hour"
```

#### user_engagement

Measures user engagement with products through event frequency analysis, providing insights into how users interact with different features.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_engagement.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&product_id=prod-123"
```
