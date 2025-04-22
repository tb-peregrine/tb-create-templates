# Funnel Optimization API

This project provides a powerful API for tracking and analyzing user conversion funnels, helping you identify bottlenecks and optimize your customer journey.

## Tinybird

### Overview

This Tinybird project offers a complete solution for funnel analysis. It allows you to track how users move through your conversion funnel, identify where users drop off, analyze conversion rates, and understand the time users spend between steps. The API is designed to be flexible, allowing you to customize event steps, time windows, and filter by various dimensions.

### Data Sources

#### user_events

This data source stores user events for funnel analysis. It captures all user interactions that will be used to build and analyze conversion funnels.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=user_events" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
           "event_id": "e123456789",
           "user_id": "user_123",
           "event_name": "page_view",
           "event_timestamp": "2023-03-15 14:30:00",
           "session_id": "session_456",
           "device": "mobile",
           "browser": "chrome",
           "country": "US",
           "referrer": "google.com",
           "properties": "{\"page\":\"homepage\"}"
         }'
```

### Endpoints

#### funnel_analysis

Analyzes user conversion funnel with customizable event steps, time window, and filters.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/funnel_analysis.json?token=$TB_ADMIN_TOKEN&step1=page_view&step2=add_to_cart&step3=checkout&step4=purchase&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&country=US&device=mobile"
```

#### conversion_rates

Calculates conversion rates between funnel steps with customizable time window.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/conversion_rates.json?token=$TB_ADMIN_TOKEN&step1=page_view&step2=add_to_cart&step3=checkout&step4=purchase&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&time_between_steps=30"
```

#### time_to_convert

Analyzes time spent between funnel steps to identify bottlenecks.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/time_to_convert.json?token=$TB_ADMIN_TOKEN&step1=page_view&step2=add_to_cart&step3=checkout&step4=purchase&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59"
```

#### daily_conversion_trends

Tracks funnel conversion rates over time for trend analysis.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/daily_conversion_trends.json?token=$TB_ADMIN_TOKEN&step1=page_view&step2=add_to_cart&step3=checkout&step4=purchase&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59"
```

#### drop_off_analysis

Analyzes where users drop off from the funnel by segment.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/drop_off_analysis.json?token=$TB_ADMIN_TOKEN&step1=page_view&step2=add_to_cart&step3=checkout&step4=purchase&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&segment_by=device"
```

Note: DateTime parameters must be formatted as YYYY-MM-DD HH:MM:SS, or else will fail.
