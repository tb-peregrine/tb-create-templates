# User Onboarding Analytics API

This API is designed to track and analyze user onboarding metrics with completion rates, helping product teams identify bottlenecks and optimize the onboarding experience.

## Tinybird

### Overview
This Tinybird project provides a complete solution for tracking and analyzing user onboarding metrics. It enables you to monitor completion rates, identify dropout points, analyze time spent on each step, compare performance across platforms, and track individual user progress.

### Data sources

#### onboarding_events
This datasource tracks user onboarding events including step completion status, time spent, and related metadata. It serves as the foundation for all onboarding analytics.

Example ingestion:
```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=onboarding_events" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
         "event_id": "e123456",
         "user_id": "u789012",
         "step_id": "step1",
         "step_name": "Account Creation",
         "status": "completed",
         "timestamp": "2023-05-15 14:30:00",
         "time_spent_seconds": 45.5,
         "session_id": "sess123456",
         "platform": "ios",
         "app_version": "2.1.0",
         "metadata": "{\"referral_source\":\"email\",\"device_type\":\"iPhone 13\"}"
     }'
```

### Endpoints

#### dropout_analysis
Identifies steps where users commonly drop out of the onboarding process, helping you pinpoint specific areas for improvement.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/dropout_analysis.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&platform=ios"
```

#### onboarding_daily_trend
Tracks onboarding completion rates over time, allowing you to monitor the impact of changes to your onboarding flow.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/onboarding_daily_trend.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59"
```

#### onboarding_completion_rate
Calculates completion rates overall and by step, helping you understand where users are succeeding or struggling.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/onboarding_completion_rate.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59"
```

#### platform_comparison
Compares onboarding performance across different platforms (iOS, Android, web), highlighting platform-specific issues.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/platform_comparison.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59"
```

#### time_spent_by_step
Analyzes average time spent on each onboarding step, helping identify steps that may be too complex or confusing.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/time_spent_by_step.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&platform=android"
```

#### user_onboarding_progress
Provides detailed onboarding progress for individual users, useful for support and personalized intervention.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_onboarding_progress.json?token=$TB_ADMIN_TOKEN&user_id=u789012&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59"
```

Note: All DateTime parameters must be formatted as YYYY-MM-DD HH:MM:SS for successful API calls.
