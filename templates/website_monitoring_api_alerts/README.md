
# Website Performance Monitoring API

A real-time API for tracking website performance metrics with automated alerts. This API allows you to monitor page load times, server response times, and error rates across different devices and browsers, helping you optimize web performance and improve user experience.

## Tinybird

### Overview

This Tinybird project creates a robust API for monitoring website performance metrics in real-time. It collects various performance data points such as page load times, server response times, DOM interactive times, and error counts. The API provides endpoints for performance analysis, trend visualization, and automated alerting when performance metrics exceed defined thresholds.

### Data sources

#### website_performance

This data source collects website performance metrics such as page load time, response time, and error rates.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=website_performance" \
    -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
    -d '{
        "timestamp": "2023-11-15 10:30:00",
        "website_id": "website_123",
        "page_url": "https://example.com/homepage",
        "page_load_time_ms": 1500,
        "server_response_time_ms": 300,
        "dom_interactive_time_ms": 800,
        "request_count": 25,
        "error_count": 0,
        "user_id": "user_456",
        "device_type": "mobile",
        "browser": "Chrome",
        "country": "US",
        "status_code": 200
    }'
```

#### performance_thresholds

This data source stores alert thresholds for different websites and metrics, allowing for customized alerting.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=performance_thresholds" \
    -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
    -d '{
        "website_id": "website_123",
        "page_load_threshold_ms": 3000,
        "response_time_threshold_ms": 1000,
        "error_threshold_count": 5,
        "created_at": "2023-11-01 09:00:00",
        "updated_at": "2023-11-01 09:00:00"
    }'
```

### Endpoints

#### performance_overview

Provides an aggregated hourly overview of website performance metrics including average load times, response times, and error rates.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/performance_overview.json?token=$TB_ADMIN_TOKEN&start_date=2023-11-01%2000:00:00&end_date=2023-11-15%2023:59:59&website_id=website_123"
```

#### website_performance_metrics

Allows detailed querying of website performance metrics with comprehensive filtering options.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/website_performance_metrics.json?token=$TB_ADMIN_TOKEN&website_id=website_123&start_date=2023-11-01%2000:00:00&end_date=2023-11-15%2023:59:59&device_type=mobile&limit=50"
```

#### performance_by_device

Analyzes performance metrics across different device types and browsers to identify platform-specific issues.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/performance_by_device.json?token=$TB_ADMIN_TOKEN&start_date=2023-11-01%2000:00:00&end_date=2023-11-15%2023:59:59&website_id=website_123"
```

#### slow_pages

Identifies the slowest loading pages to help prioritize optimization efforts.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/slow_pages.json?token=$TB_ADMIN_TOKEN&start_date=2023-11-01%2000:00:00&end_date=2023-11-15%2023:59:59&website_id=website_123&limit=10"
```

#### performance_alerts

Detects performance issues in real-time and generates alerts based on configured thresholds.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/performance_alerts.json?token=$TB_ADMIN_TOKEN&website_id=website_123&page_load_threshold=2500&response_threshold=800&error_threshold=3&time_window=30"
```
