
# Subscription Analytics API

## Tinybird

### Overview
This project provides a real-time API for monitoring subscription renewal patterns. It tracks subscription events and offers endpoints to analyze subscription metrics, churn patterns, and renewal rates.

### Data Sources

#### subscription_events
This datasource tracks subscription events including creation, renewal, and cancellation.

**Sample Ingestion:**
```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=subscription_events" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
        "subscription_id": "sub_12345",
        "customer_id": "cust_789",
        "plan_id": "plan_monthly",
        "event_type": "new",
        "timestamp": "2023-06-15 10:30:00",
        "amount": 29.99,
        "currency": "USD",
        "next_renewal_date": "2023-07-15 10:30:00",
        "status": "active"
     }'
```

### Endpoints

#### subscription_overview
Provides an overview of key subscription metrics including total subscriptions, new subscriptions, renewals, cancellations, renewal rate, and churn rate.

**Usage:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/subscription_overview.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&plan_id=plan_monthly"
```

Parameters:
- `start_date` (optional): Start date in format YYYY-MM-DD HH:MM:SS (default: 2023-01-01 00:00:00)
- `end_date` (optional): End date in format YYYY-MM-DD HH:MM:SS (default: 2023-12-31 23:59:59)
- `plan_id` (optional): Filter by specific subscription plan

#### churn_analysis
Analyzes subscription churn patterns over time, grouped by month and plan.

**Usage:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/churn_analysis.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59"
```

Parameters:
- `start_date` (optional): Start date in format YYYY-MM-DD HH:MM:SS (default: 2023-01-01 00:00:00)
- `end_date` (optional): End date in format YYYY-MM-DD HH:MM:SS (default: 2023-12-31 23:59:59)

#### renewal_rates
Tracks subscription renewal rates over time by comparing eligible renewals to actual renewals.

**Usage:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/renewal_rates.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&plan_id=plan_monthly"
```

Parameters:
- `start_date` (optional): Start date in format YYYY-MM-DD HH:MM:SS (default: 2023-01-01 00:00:00)
- `end_date` (optional): End date in format YYYY-MM-DD HH:MM:SS (default: 2023-12-31 23:59:59)
- `plan_id` (optional): Filter by specific subscription plan
