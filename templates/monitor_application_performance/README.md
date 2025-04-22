
# Application Performance Monitoring API

## Tinybird

### Overview
This Tinybird project provides a comprehensive Application Performance Monitoring (APM) API that tracks crucial metrics like response times, error rates, resource usage, and user experience. It helps identify performance bottlenecks, detect errors, compare application versions, and analyze regional and device-specific patterns.

### Data Sources

#### app_performance_events
Raw events for application performance monitoring, capturing various metrics like response time, error rates, and resource usage.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=app_performance_events" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
           "timestamp": "2023-05-15 14:23:45",
           "app_id": "shopping-cart",
           "service_name": "payment-service",
           "endpoint": "/api/payments/process",
           "response_time_ms": 248,
           "status_code": 200,
           "error": "",
           "cpu_usage_percent": 45.2,
           "memory_usage_mb": 128.7,
           "user_id": "user_12345",
           "device_type": "mobile",
           "region": "europe-west",
           "version": "1.0.5"
         }'
```

### Endpoints

#### performance_trends
Tracks performance trends over time, showing how response times and error rates have evolved.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/performance_trends.json?token=$TB_ADMIN_TOKEN&interval=1%20hour&app_id=shopping-cart&service_name=payment-service&start_date=2023-05-01%2000:00:00&end_date=2023-05-15%2023:59:59"
```

#### resource_usage
Monitors CPU and memory usage over time, helping to identify resource-intensive operations.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/resource_usage.json?token=$TB_ADMIN_TOKEN&interval=15%20minute&app_id=shopping-cart&service_name=payment-service&start_date=2023-05-15%2000:00:00&end_date=2023-05-15%2023:59:59"
```

#### error_analysis
Analyzes error patterns by looking at error types, frequency, and affected endpoints.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/error_analysis.json?token=$TB_ADMIN_TOKEN&app_id=shopping-cart&service_name=payment-service&error_type=Timeout%25&start_date=2023-05-01%2000:00:00&end_date=2023-05-15%2023:59:59"
```

#### version_comparison
Compares performance metrics across different application versions to identify regressions or improvements.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/version_comparison.json?token=$TB_ADMIN_TOKEN&app_id=shopping-cart&compare_versions=('1.0.4',%20'1.0.5',%20'1.0.6')&start_date=2023-04-15%2000:00:00&end_date=2023-05-15%2023:59:59"
```

#### user_experience
Analyzes application performance from the user perspective, segmented by device type and region.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_experience.json?token=$TB_ADMIN_TOKEN&app_id=shopping-cart&device_type=mobile&region=europe-west&start_date=2023-05-15%2000:00:00&end_date=2023-05-15%2023:59:59"
```

#### api_response_time
Provides response time statistics per application, service and endpoint over a specified time range.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/api_response_time.json?token=$TB_ADMIN_TOKEN&app_id=shopping-cart&service_name=payment-service&endpoint=/api/payments/process&start_date=2023-05-15%2000:00:00&end_date=2023-05-15%2023:59:59"
```
