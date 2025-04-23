# User Retention Analysis API

## Tinybird

### Overview
This project is designed to process and analyze user retention patterns with predictions. It provides APIs for cohort analysis, retention trends, user activity patterns, and identifying users at risk of churning, with capabilities for retention prediction accuracy evaluation.

### Data sources

#### cohort_retention_metrics
Materialized datasource for storing daily cohort retention metrics.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=cohort_retention_metrics" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "cohort_date": "2023-01-01",
       "segment": "free_tier",
       "cohort_size": 1500,
       "day_1_retained": 1200,
       "day_7_retained": 950,
       "day_14_retained": 850,
       "day_30_retained": 700,
       "day_60_retained": 550,
       "day_90_retained": 450,
       "day_1_rate": 0.8,
       "day_7_rate": 0.63,
       "day_14_rate": 0.57,
       "day_30_rate": 0.47,
       "day_60_rate": 0.37,
       "day_90_rate": 0.3
     }'
```

#### user_events
Datasource containing user events data for retention analysis.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=user_events" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "user_id": "user123",
       "event_type": "login",
       "timestamp": "2023-01-15 14:30:00",
       "session_id": "sess456",
       "platform": "ios",
       "country": "US",
       "device_type": "mobile",
       "app_version": "2.1.0"
     }'
```

#### retention_predictions
Datasource containing retention predictions for users.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=retention_predictions" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "user_id": "user123",
       "prediction_date": "2023-01-15",
       "predicted_retention_7d": 0.85,
       "predicted_retention_30d": 0.67,
       "predicted_retention_90d": 0.42,
       "prediction_model_version": "v1.2"
     }'
```

#### user_cohorts
Datasource containing user cohort information for retention analysis.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=user_cohorts" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "user_id": "user123",
       "cohort_date": "2023-01-01",
       "acquisition_source": "google_ads",
       "user_segment": "new_user",
       "initial_subscription_plan": "free_tier"
     }'
```

### Endpoints

#### retention_prediction_accuracy
Evaluates the accuracy of retention predictions against actual user retention.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/retention_prediction_accuracy.json?start_date=2023-01-01&end_date=2023-12-31&model_version=v1.2&token=$TB_ADMIN_TOKEN"
```

#### cohort_analysis
Provides comprehensive cohort analysis with retention curves.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/cohort_analysis.json?start_date=2023-01-01&end_date=2023-12-31&cohort_by=acquisition_source&segment=google_ads&token=$TB_ADMIN_TOKEN"
```

#### retention_trends
Analyzes retention trends over time to identify patterns.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/retention_trends.json?start_date=2023-01-01&end_date=2023-12-31&segment_filter=free_tier&token=$TB_ADMIN_TOKEN"
```

#### daily_cohort_retention
Calculates daily cohort retention metrics for different time periods.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/daily_cohort_retention.json?start_date=2023-01-01&end_date=2023-12-31&segment_by=platform&token=$TB_ADMIN_TOKEN"
```

#### at_risk_users
Identifies users at risk of churn based on activity patterns and retention predictions.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/at_risk_users.json?min_days_since_active=7&risk_level=High%20Risk&user_segment=free_tier&sort_by=risk&limit=100&token=$TB_ADMIN_TOKEN"
```

#### user_activity_patterns
Analyzes user activity patterns to identify engagement trends.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_activity_patterns.json?min_date=2023-01-01%2000:00:00&max_date=2023-12-31%2023:59:59&platform=ios&country=US&min_activity_threshold=5&sort_by=frequency&limit=1000&token=$TB_ADMIN_TOKEN"
```
