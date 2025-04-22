# User Retention and Cohort Analysis API

This project provides an API for tracking and analyzing user retention, churn metrics and cohort analysis.

## Tinybird

### Overview

This Tinybird project implements a comprehensive user analytics platform focused on retention, cohort analysis, and churn metrics. It provides endpoints to analyze user behavior patterns, identify retention trends, measure user engagement frequency, and calculate customer lifetime value.

### Data Sources

#### user_events

This data source stores user events data containing session information, user identification, and timestamps. It's designed to track user interactions across different platforms and countries.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=user_events" \
  -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
  -d '{
    "event_id": "e12345",
    "user_id": "u789",
    "event_type": "page_view",
    "timestamp": "2023-06-15 14:30:45",
    "session_id": "s9876",
    "platform": "mobile",
    "country": "US"
  }'
```

### Endpoints

#### cohort_retention

Calculates user retention by cohort and period, allowing you to track how many users from each acquisition cohort remain active over time.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/cohort_retention.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&platform=mobile"
```

#### user_activity_frequency

Analyzes user engagement frequency to identify power users versus casual users, categorizing users based on their session activity levels.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_activity_frequency.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&platform=web"
```

#### churn_analysis

Calculates user churn rate by comparing active users between consecutive periods, helping identify trends in user attrition.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/churn_analysis.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&platform=all"
```

#### user_cohorts

Builds user cohorts based on their first appearance date (acquisition date), providing foundational data for cohort analysis.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_cohorts.json?token=$TB_ADMIN_TOKEN"
```

#### user_lifetime_value

Calculates user lifetime value by cohort for customer retention analysis, measuring the long-term value of acquired users.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_lifetime_value.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&platform=mobile"
```
