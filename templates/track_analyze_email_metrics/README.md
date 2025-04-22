
# Email Campaign Analytics API

## Tinybird

### Overview
This Tinybird project provides a powerful API for tracking and analyzing email campaign performance metrics. It enables real-time monitoring of email engagement, geographical analysis, device usage, and recipient behavior to help optimize your email marketing campaigns.

### Data Sources

#### email_recipients
Stores information about email recipients including their contact details, status, and segment information.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=email_recipients" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{"recipient_id":"rec_123456","email":"user@example.com","first_name":"John","last_name":"Doe","created_at":"2023-05-15 10:30:00","updated_at":"2023-05-15 10:30:00","status":"active","segment_id":"seg_123","metadata":"{\"source\":\"website\"}"}'
```

#### email_campaigns
Stores information about email campaigns including campaign details, sender information, and template references.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=email_campaigns" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{"campaign_id":"camp_123456","campaign_name":"Summer Sale","campaign_description":"20% off summer products","created_at":"2023-06-01 09:00:00","updated_at":"2023-06-01 09:00:00","status":"active","sender_email":"marketing@example.com","sender_name":"Marketing Team","subject":"Summer Sale - 20% Off Everything!","template_id":"tmpl_456"}'
```

#### email_events
Tracks all email events such as sends, opens, clicks, bounces, and provides detailed information about each interaction.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=email_events" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{"event_id":"evt_123456","campaign_id":"camp_123456","recipient_id":"rec_123456","email":"user@example.com","event_type":"open","event_timestamp":"2023-06-02 15:45:20","ip_address":"192.168.1.1","user_agent":"Mozilla/5.0","link_url":"","device_type":"mobile","country":"US","city":"New York"}'
```

### Endpoints

#### event_timeline
Shows the timeline of email events for analyzing engagement patterns over time. You can filter by campaign ID, date range, and event type.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/event_timeline.json?token=$TB_ADMIN_TOKEN&campaign_id=camp_123456&start_date=2023-06-01%2000:00:00&end_date=2023-06-30%2023:59:59&event_type=open"
```

#### campaign_comparison
Compares performance metrics across multiple campaigns, including open rates, click-through rates, and bounce rates.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/campaign_comparison.json?token=$TB_ADMIN_TOKEN"
```

#### geographical_analysis
Provides geographical analysis of email opens and clicks, helping identify where your audience is most engaged.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/geographical_analysis.json?token=$TB_ADMIN_TOKEN&campaign_id=camp_123456&start_date=2023-06-01%2000:00:00&end_date=2023-06-30%2023:59:59&event_type=click"
```

#### device_analysis
Analyzes email interactions by device type to understand how your audience accesses your content.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/device_analysis.json?token=$TB_ADMIN_TOKEN&campaign_id=camp_123456&start_date=2023-06-01%2000:00:00&end_date=2023-06-30%2023:59:59"
```

#### recipient_engagement
Analyzes engagement metrics per recipient to identify your most engaged users.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/recipient_engagement.json?token=$TB_ADMIN_TOKEN&campaign_id=camp_123456&recipient_id=rec_123456&email=user@example.com"
```

#### link_performance
Analyzes click performance of different links in email campaigns to understand what content resonates best.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/link_performance.json?token=$TB_ADMIN_TOKEN&campaign_id=camp_123456&start_date=2023-06-01%2000:00:00&end_date=2023-06-30%2023:59:59"
```

#### campaign_overview
Provides a high-level overview of campaign performance metrics with detailed statistics on engagement.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/campaign_overview.json?token=$TB_ADMIN_TOKEN&campaign_id=camp_123456&start_date=2023-06-01%2000:00:00&end_date=2023-06-30%2023:59:59"
```
