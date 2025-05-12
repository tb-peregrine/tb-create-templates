# User Onboarding Analytics API

A streamlined API for tracking and analyzing user onboarding flows, providing insights into step completion rates and onboarding funnel performance.

## Tinybird

### Overview

This Tinybird project helps track and analyze user onboarding processes by:
- Storing user onboarding events and step completion data
- Providing endpoints to analyze individual user progress
- Calculating step completion rates and funnel performance
- Identifying bottlenecks in the onboarding process

### Data sources

#### onboarding_steps

Reference table for all onboarding steps with their sequence and details.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=onboarding_steps" \
    -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
    -d '{"step_id":"welcome","step_name":"Welcome Step","step_description":"Introduction to the platform","step_order":1,"is_required":1}'
```

#### user_onboarding_events

Stores user onboarding events with step completion data.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=user_onboarding_events" \
    -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
    -d '{"user_id":"u123","step_id":"welcome","step_name":"Welcome Step","completed":1,"timestamp":"2023-09-01 14:30:00"}'
```

### Endpoints

#### user_completion_status

Returns the completion status for a specific user across all onboarding steps.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_completion_status.json?user_id=u123&token=$TB_ADMIN_TOKEN"
```

#### step_completion_rate

Calculates the completion rate for each onboarding step across all users within a specified date range.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/step_completion_rate.json?start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&token=$TB_ADMIN_TOKEN"
```

#### overall_onboarding_funnel

Shows the overall onboarding funnel with completion rates at each step, providing insights into where users drop off.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/overall_onboarding_funnel.json?start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&token=$TB_ADMIN_TOKEN"
```

Note: For all endpoints with DateTime parameters, ensure they are formatted as YYYY-MM-DD HH:MM:SS.
