
# API Usage Analytics for Multi-tenant Applications

A real-time API analytics solution for tracking usage, performance, and rate limits in multi-tenant applications.

## Tinybird

### Overview

This Tinybird project provides a comprehensive solution for monitoring API usage and performance metrics for multi-tenant applications. It allows tracking of API requests, rate limiting, error analysis, and user activity across different tenants. The analytics can be used to optimize API performance, identify issues, and ensure fair usage across tenants.

### Data Sources

#### api_logs

Stores raw API usage logs for multi-tenant applications, including request details, response times, status codes, and error information.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=api_logs" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "timestamp": "2023-10-15 14:30:45",
       "request_id": "req_12345",
       "tenant_id": "tenant_abc",
       "user_id": "user_123",
       "endpoint": "/api/v1/resources",
       "method": "GET",
       "status_code": 200,
       "response_time_ms": 150,
       "request_size_bytes": 512,
       "response_size_bytes": 2048,
       "ip_address": "192.168.1.1",
       "user_agent": "Mozilla/5.0",
       "error_type": "",
       "error_message": "",
       "region": "us-east-1"
     }'
```

#### tenant_rate_limits

Stores rate limit configurations for each tenant, defining the maximum number of requests allowed per minute, hour, and day for specific endpoints.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=tenant_rate_limits" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "tenant_id": "tenant_abc",
       "endpoint": "/api/v1/resources",
       "requests_per_minute": 100,
       "requests_per_hour": 1000,
       "requests_per_day": 10000,
       "created_at": "2023-10-01 00:00:00",
       "updated_at": "2023-10-01 00:00:00"
     }'
```

### Endpoints

#### time_series_metrics

Provides time series metrics for API usage with various time granularities (minute, hour, day).

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/time_series_metrics.json?token=$TB_ADMIN_TOKEN&granularity=hour&start_date=2023-10-01%2000:00:00&end_date=2023-10-31%2023:59:59&tenant_id=tenant_abc&endpoint=/api/v1/resources"
```

#### rate_limit_usage

Shows current usage against rate limits for tenants, indicating how close they are to hitting their limits.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/rate_limit_usage.json?token=$TB_ADMIN_TOKEN&tenant_id=tenant_abc&endpoint=/api/v1/resources"
```

#### endpoint_performance

Retrieves API performance metrics by endpoint with filtering options, including response times and success/error rates.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/endpoint_performance.json?token=$TB_ADMIN_TOKEN&start_date=2023-10-01%2000:00:00&end_date=2023-10-31%2023:59:59&tenant_id=tenant_abc&method=GET&limit=10"
```

#### api_usage_by_tenant

Retrieves API usage metrics grouped by tenant with filtering options.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/api_usage_by_tenant.json?token=$TB_ADMIN_TOKEN&start_date=2023-10-01%2000:00:00&end_date=2023-10-31%2023:59:59&limit=10"
```

#### user_activity

Retrieves API usage metrics by user within a tenant.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_activity.json?token=$TB_ADMIN_TOKEN&tenant_id=tenant_abc&start_date=2023-10-01%2000:00:00&end_date=2023-10-31%2023:59:59&limit=10"
```

#### error_analysis

Provides detailed analysis of API errors by type and message.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/error_analysis.json?token=$TB_ADMIN_TOKEN&start_date=2023-10-01%2000:00:00&end_date=2023-10-31%2023:59:59&tenant_id=tenant_abc&limit=10"
```

#### geographic_distribution

Analyzes API usage based on geographic regions.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/geographic_distribution.json?token=$TB_ADMIN_TOKEN&start_date=2023-10-01%2000:00:00&end_date=2023-10-31%2023:59:59&tenant_id=tenant_abc"
```
