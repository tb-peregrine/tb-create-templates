# Funnel and Session Analysis API

## Tinybird

### Overview
This project implements a robust user journey and funnel analysis system using Tinybird. It captures and analyzes event data to track user sessions, measure conversion rates, and visualize user progression through defined funnels. The API provides comprehensive insights into user behavior, engagement patterns, and conversion optimization opportunities.

### Data sources

#### funnel_steps
Defines the steps in each funnel for analysis.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=funnel_steps" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "funnel_id": "checkout_flow",
       "funnel_name": "Checkout Process",
       "step_number": 1,
       "step_name": "Add to Cart",
       "event_name": "add_to_cart",
       "is_required": 1
     }'
```

#### events
Stores user events for session tracking and funnel analysis.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=events" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "event_id": "evt_12345",
       "user_id": "user_789",
       "session_id": "sess_456",
       "event_type": "click",
       "event_name": "add_to_cart",
       "timestamp": "2023-05-15 14:23:45",
       "page_url": "https://example.com/product/123",
       "referrer": "https://example.com/category",
       "device": "mobile",
       "browser": "Chrome",
       "os": "iOS",
       "country": "US",
       "city": "New York",
       "properties": "{\"product_id\":\"123\",\"price\":29.99}"
     }'
```

### Endpoints

#### device_stats
Provides statistics about device, browser, and OS usage with session counts.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/device_stats.json?token=$TB_ADMIN_TOKEN&dimension=browser&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&limit=10"
```

#### funnel_analysis
Analyzes user progression through defined funnels with conversion rates between steps.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/funnel_analysis.json?token=$TB_ADMIN_TOKEN&funnel_id=checkout_flow&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59"
```

#### conversion_rates
Calculates conversion rates between specified start and end events.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/conversion_rates.json?token=$TB_ADMIN_TOKEN&start_event=page_view&end_event=purchase&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59"
```

#### user_journey
Tracks the sequence of events within user sessions to analyze user journey patterns.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_journey.json?token=$TB_ADMIN_TOKEN&user_id=user_789&session_id=sess_456&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59"
```

#### event_timeline
Provides a timeline of events by hour, day, or week for trend analysis.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/event_timeline.json?token=$TB_ADMIN_TOKEN&interval=day&event_name=add_to_cart&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59"
```

#### session_details
Retrieves details about individual user sessions.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/session_details.json?token=$TB_ADMIN_TOKEN&user_id=user_789&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&limit=10"
```

#### user_engagement
Provides metrics about user engagement such as session count and duration.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_engagement.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&limit=100"
```

#### event_metrics
Provides metrics about event frequency and distribution over time.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/event_metrics.json?token=$TB_ADMIN_TOKEN&event_name=add_to_cart&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&limit=20"
```
