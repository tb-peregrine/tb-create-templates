# Email Campaign Performance Tracking API

## Tinybird

### Overview
This project provides a real-time API for tracking email campaign performance. It allows you to monitor campaign metrics such as sends, opens, clicks, bounces, and unsubscribes, as well as retrieve detailed information about recipient activity.

### Data Sources

#### email_events
This datasource stores raw email campaign events data including sends, opens, clicks, bounces, and unsubscribes. Each record represents a single event that occurred for an email sent as part of a campaign.

**How to ingest data**:
```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=email_events" \
    -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
    -d '{
      "event_id": "ev_123456789",
      "timestamp": "2023-05-15 10:30:00",
      "event_type": "open",
      "campaign_id": "camp_spring2023",
      "email_id": "email_abc123",
      "recipient_id": "user_456",
      "recipient_email": "user@example.com",
      "link_url": "https://example.com/product",
      "metadata": "{\"device\":\"mobile\"}",
      "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 15_4 like Mac OS X)"
    }'
```

### Endpoints

#### campaign_stats
This endpoint provides aggregated performance metrics for email campaigns, including sends, opens, clicks, bounces, and unsubscribes. It also calculates key performance indicators such as open rate, click-to-open rate, and bounce rate.

**How to use**:
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/campaign_stats.json?token=$TB_ADMIN_TOKEN&campaign_id=camp_spring2023&start_date=2023-05-01%2000:00:00&end_date=2023-05-31%2023:59:59"
```

#### recipient_activity
This endpoint retrieves a detailed activity log for specific email recipients, showing all events (sends, opens, clicks, etc.) associated with a recipient, including timestamps and other relevant details.

**How to use**:
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/recipient_activity.json?token=$TB_ADMIN_TOKEN&recipient_id=user_456&limit=50"
```

#### campaign_timeline
This endpoint provides campaign performance metrics over time, allowing you to see how your campaign performed at different time intervals. You can group the results by hour or day.

**How to use**:
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/campaign_timeline.json?token=$TB_ADMIN_TOKEN&campaign_id=camp_spring2023&group_by=hour&start_date=2023-05-01%2000:00:00&end_date=2023-05-31%2023:59:59"
```

Note: DateTime parameters must be formatted as YYYY-MM-DD HH:MM:SS, or else they will fail.
