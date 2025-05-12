
# Customer Churn Analysis API

This project provides an API to analyze customer churn patterns and risk factors to help businesses identify at-risk customers and prevent churn.

## Tinybird

### Overview

The Customer Churn Analysis API allows businesses to monitor customer engagement metrics, calculate churn risk scores, and analyze churn trends across different customer segments. This helps identify at-risk customers early and implement targeted retention strategies.

### Data Sources

#### customer_data

Stores customer profile data and interactions with the platform, including subscription details, login activity, support tickets, and churn status.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=customer_data" \
  -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
  -d '{
    "customer_id": "cust_123456",
    "join_date": "2023-01-15 10:30:00",
    "last_login_date": "2023-06-10 14:25:00",
    "subscription_plan": "premium",
    "subscription_amount": 49.99,
    "billing_cycle": "monthly",
    "payment_status": "active",
    "total_spend": 299.94,
    "number_of_logins": 45,
    "customer_service_tickets": 2,
    "ticket_satisfaction_score": 4.5,
    "churn": 0,
    "churn_date": null,
    "region": "us-west",
    "platform": "web",
    "timestamp": "2023-06-10 14:25:00"
  }'
```

### Endpoints

#### churn_risk_score

Calculates a churn risk score for individual customers based on various signals like login recency, payment issues, and support ticket satisfaction. Can be used to identify specific at-risk customers for targeted interventions.

```bash
# Get risk score for a specific customer
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/churn_risk_score.json?token=$TB_ADMIN_TOKEN&customer_id=cust_123456"

# Get risk scores for all customers
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/churn_risk_score.json?token=$TB_ADMIN_TOKEN"
```

#### churn_trend_analysis

Shows churn trends over time with customizable time granularity (day, week, month, quarter). Helps identify periods with abnormal churn rates and correlate with events or changes.

```bash
# Get monthly churn trends for all customers
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/churn_trend_analysis.json?token=$TB_ADMIN_TOKEN&time_granularity=month"

# Get weekly churn trends with date range and segment filter
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/churn_trend_analysis.json?token=$TB_ADMIN_TOKEN&time_granularity=week&start_date=2023-01-01%2000:00:00&end_date=2023-06-30%2023:59:59&segment_filter=subscription_plan&segment_value=premium"
```

#### churn_analysis_by_segment

Provides churn statistics aggregated by different segments like subscription plan, region, billing cycle, or platform. Useful for identifying which customer segments have the highest churn rates.

```bash
# Get churn analysis by subscription plan
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/churn_analysis_by_segment.json?token=$TB_ADMIN_TOKEN&segment_by=subscription_plan"

# Get churn analysis by region with date range
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/churn_analysis_by_segment.json?token=$TB_ADMIN_TOKEN&segment_by=region&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59"
```
