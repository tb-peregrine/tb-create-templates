
# Application Error Monitoring API

## Tinybird

### Overview
This Tinybird project provides a robust API for monitoring and analyzing application errors and exceptions. It enables developers to track, analyze, and troubleshoot errors across different services, environments, and severity levels to improve application reliability.

### Data Sources

#### app_errors
This data source stores application errors and exceptions with timestamp, severity level, error message, stack trace, and relevant metadata to facilitate error tracking and debugging.

**Ingestion Example:**
```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=app_errors" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "timestamp": "2023-10-15 14:32:45",
       "app_id": "shopping-cart-service",
       "service_name": "payment-processor",
       "environment": "production",
       "severity": "ERROR",
       "error_type": "PaymentGatewayException",
       "error_message": "Failed to process payment: Gateway timeout",
       "stack_trace": "at PaymentService.processPayment(PaymentService.java:125)\nat CheckoutController.completeOrder(CheckoutController.java:87)",
       "user_id": "usr_12345",
       "request_id": "req_78901",
       "metadata": "{\"transaction_id\":\"tx_456\",\"payment_provider\":\"stripe\"}"
     }'
```

### Endpoints

#### top_errors
Get the most frequent error types or messages within a time range. Helps identify recurring issues that need immediate attention.

**Usage:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/top_errors.json?token=$TB_ADMIN_TOKEN&start_date=2023-10-01%2000:00:00&end_date=2023-10-15%2023:59:59&group_by=error_type&environment=production&limit=10"
```

#### error_distribution
Get distribution of errors by various dimensions such as severity, app_id, service_name, etc. Provides insights on how errors are distributed across different categories.

**Usage:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/error_distribution.json?token=$TB_ADMIN_TOKEN&dimension=severity&start_date=2023-10-01%2000:00:00&end_date=2023-10-15%2023:59:59"
```

#### get_errors_by_severity
Get errors filtered by severity level, time range, and other optional filters. Enables detailed investigation of specific error categories.

**Usage:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_errors_by_severity.json?token=$TB_ADMIN_TOKEN&severity=ERROR&environment=production&start_date=2023-10-15%2000:00:00&end_date=2023-10-15%2023:59:59&limit=50"
```

#### error_count_trends
Get trends of error counts over time, grouped by time interval, severity, and other dimensions. Helps identify patterns and spikes in error rates.

**Usage:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/error_count_trends.json?token=$TB_ADMIN_TOKEN&time_bucket=hour&group_by=service_name&start_date=2023-10-10%2000:00:00&end_date=2023-10-15%2023:59:59"
```
