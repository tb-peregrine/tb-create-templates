
# Marketing Analytics API

## Tinybird

### Overview
This project provides a real-time analytics API for multi-channel marketing campaigns. The API allows you to track and analyze marketing events across different channels and campaigns, providing insights into campaign performance and user engagement.

### Data sources

#### marketing_events
This datasource stores marketing events from various channels and campaigns. Each event includes information about the event time, channel, campaign, user ID, and event type.

**Ingestion example:**
```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=marketing_events" \
    -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
    -d '{
        "event_time": "2023-10-15 14:30:00",
        "channel": "email",
        "campaign": "fall_promotion",
        "user_id": "user_123",
        "event_type": "click"
    }'
```

### Endpoints

#### events_by_channel
This endpoint retrieves the number of marketing events grouped by channel, allowing you to compare performance across different marketing channels.

**Usage example:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/events_by_channel.json?token=$TB_ADMIN_TOKEN"
```

#### events_by_campaign
This endpoint retrieves the number of marketing events grouped by campaign, allowing you to measure the effectiveness of different marketing campaigns.

**Usage example:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/events_by_campaign.json?token=$TB_ADMIN_TOKEN"
```

#### total_events
This endpoint retrieves the total number of marketing events, providing a high-level overview of marketing activity.

**Usage example:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/total_events.json?token=$TB_ADMIN_TOKEN"
```
