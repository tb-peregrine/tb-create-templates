# Build a Real-Time Email Campaign Performance Tracking API with Tinybird

When managing email campaigns, tracking performance in real-time can significantly impact your ability to adjust and optimize on the fly. Whether you're looking at sends, opens, clicks, or bounces, having immediate access to this data allows for quick decision-making and strategy adjustments. This tutorial will guide you through building a real-time API to track email campaign performance using Tinybird. Tinybird is a data analytics backend for software developers. You use Tinybird to build real-time analytics APIs without needing to set up or manage the underlying infrastructure. Tinybird offers a local-first development workflow, git-based deployments, resource definitions as code, and features for AI-native developers. By leveraging Tinybird's data sources and pipes, you can ingest, transform, and serve large volumes of data via API [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) with minimal latency. 

## Understanding the data

Imagine your data looks like this:

```json
[
  {"event_id": "ev_45738", "timestamp": "2025-05-08 13:13:29", "event_type": "bounced", "campaign_id": "camp_8", "email_id": "email_738", "recipient_id": "user_38", "recipient_email": "user38@example.com", "link_url": "https://example.com/landing", "metadata": "{\"source\":\"promotion\"}", "user_agent": "Mozilla/5.0 (Windows)"},
  {"event_id": "ev_68578", "timestamp": "2025-05-08 00:12:49", "event_type": "bounced", "campaign_id": "camp_8", "email_id": "email_578", "recipient_id": "user_78", "recipient_email": "user78@example.com", "link_url": "https://example.com/landing", "metadata": "{\"source\":\"announcement\"}", "user_agent": "Mozilla/5.0 (Windows)"}
]
```

This data represents email campaign events, including sends, opens, clicks, bounces, and unsubscribes for each email sent as part of a campaign. To store this data, you'll create a Tinybird datasource:

```json
DESCRIPTION >
    Raw email campaign events data including sends, opens, clicks, bounces, and unsubscribes

SCHEMA >
    `event_id` String `json:$.event_id`,
    `timestamp` DateTime `json:$.timestamp`,
    `event_type` String `json:$.event_type`,
    `campaign_id` String `json:$.campaign_id`,
    `email_id` String `json:$.email_id`,
    `recipient_id` String `json:$.recipient_id`,
    `recipient_email` String `json:$.recipient_email`,
    `link_url` String `json:$.link_url`,
    `metadata` String `json:$.metadata`,
    `user_agent` String `json:$.user_agent`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(timestamp)"
ENGINE_SORTING_KEY "campaign_id, event_type, timestamp"
```

When designing the schema, the selection of column types and sorting keys is critical for optimizing query performance. For instance, using `ENGINE_SORTING_KEY` on `campaign_id`, `event_type`, and `timestamp` improves the efficiency of queries filtered by these fields. For data ingestion, Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request. This real-time nature of the Events API ensures low latency:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=email_events&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV" \
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

Additionally, for event/streaming data, you could also use the Kafka connector for benefits like fault tolerance and scalability. For batch or file data, the [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) and S3 connector are efficient methods for ingestion. 

## Transforming data and publishing APIs

Tinybird [pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) enable the transformation of raw data into valuable information and the creation of API endpoints for accessing this data in real-time. 

### campaign_stats Pipe

This pipe aggregates performance metrics for email campaigns:

```sql
DESCRIPTION >
    Get email campaign performance metrics including sends, opens, clicks, bounces, and unsubscribes

NODE campaign_stats_node
SQL >
    %
    SELECT
        campaign_id,
        sum(if(event_type = 'send', 1, 0)) AS sends,
        sum(if(event_type = 'open', 1, 0)) AS opens,
        sum(if(event_type = 'click', 1, 0)) AS clicks,
        sum(if(event_type = 'bounce', 1, 0)) AS bounces,
        sum(if(event_type = 'unsubscribe', 1, 0)) AS unsubscribes,
        round(opens / sends * 100, 2) AS open_rate,
        round(clicks / opens * 100, 2) AS click_to_open_rate,
        round(bounces / sends * 100, 2) AS bounce_rate,
        min(timestamp) AS campaign_start,
        max(timestamp) AS last_activity
    FROM email_events
    WHERE 1=1
    {% if defined(campaign_id) %}
        AND campaign_id = {{String(campaign_id, '')}}
    {% end %}
    {% if defined(start_date) %}
        AND timestamp >= {{DateTime(start_date, '2023-01-01 00:00:00')}}
    {% end %}
    {% if defined(end_date) %}
        AND timestamp <= {{DateTime(end_date, '2023-12-31 23:59:59')}}
    {% end %}
    GROUP BY campaign_id
    ORDER BY campaign_start DESC

TYPE endpoint
```

This SQL query aggregates sends, opens, clicks, bounces, and unsubscribes per campaign. It also calculates key performance indicators like open rate and click-to-open rate. The query parameters make the API flexible, allowing you to filter data by campaign ID, start date, and end date. 

### Example API Call

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/campaign_stats.json?token=%24TB_ADMIN_TOKEN&campaign_id=camp_spring2023&start_date=2023-05-01+00%3A00%3A00&end_date=2023-05-31+23%3A59%3A59&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV"
```

The recipient_activity and campaign_timeline pipes follow a similar structure, providing detailed recipient activity logs and campaign performance metrics over time, respectively. 

## Deploying to production

Deploy your project to Tinybird Cloud with `tb --cloud deploy`. This command creates production-ready, scalable API endpoints. Tinybird's approach to resource management as code integrates seamlessly with CI/CD pipelines, ensuring your data pipelines are versioned and deployable with the same rigor as your application code. For securing the APIs, Tinybird employs token-based authentication, ensuring that only authorized users can access your data endpoints. Example curl command to call the deployed endpoint:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/campaign_stats.json?token=%24TB_ADMIN_TOKEN&campaign_id=camp_spring2023&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV"
```


## Conclusion

Throughout this tutorial, you've built a real-time API for tracking email campaign performance, leveraging Tinybird's [data sources](https://www.tinybird.co/docs/forward/get-data-in/data-sources?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) and pipes. This solution enables immediate insights into campaign metrics like sends, opens, clicks, bounces, and unsubscribes, empowering you to make data-driven decisions swiftly. The technical benefits of using Tinybird for this use case include the ability to process and query large volumes of data in real-time, the simplicity of deploying and managing API endpoints, and the security offered by token-based authentication. [Sign up for Tinybird](https://cloud.tinybird.co/signup?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) to build and deploy your first real-time data APIs in a few minutes. Tinybird is free to start, with no time limit and no credit card required.