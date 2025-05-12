# Build a Real-Time Analytics API for Multi-Channel Marketing Campaigns

In today's digital age, tracking and analyzing marketing events across different channels in real-time can be a game-changer for businesses. Whether it's email, social media, or direct marketing, understanding campaign performance and user engagement is crucial for optimizing strategies. However, the challenge lies in efficiently processing and querying large volumes of data on the fly. This tutorial will guide you through building a real-time analytics API for multi-channel marketing campaigns using Tinybird. Tinybird is a data analytics backend for software developers. You use Tinybird to build real-time analytics APIs without needing to set up or manage the underlying infrastructure. Tinybird offers a local-first development workflows, git-based deployments, resource definitions as code, and features for AI-native developers. By leveraging Tinybird's data sources and [pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes), you can ingest event data from various marketing channels, transform this data, and expose it through high-performance APIs. ## Understanding the data

Imagine your data looks like this:

```json
{"event_time": "2025-05-12 06:18:15", "channel": "search", "campaign": "holiday_special", "user_id": "user_312", "event_type": "conversion"}
{"event_time": "2025-05-12 00:09:31", "channel": "social", "campaign": "black_friday", "user_id": "user_236", "event_type": "click"}
{"event_time": "2025-05-11 17:53:24", "channel": "display", "campaign": "new_product", "user_id": "user_603", "event_type": "purchase"}
... ```

This data represents marketing events, capturing when a user interacts with a campaign through various channels. Each event records a timestamp, the channel through which the user was reached, the campaign name, the user's ID, and the type of interaction. To store this data in Tinybird, you first create a data source with the following schema:

```json
DESCRIPTION >
    Datasource to store marketing events. SCHEMA >
    `event_time` DateTime `json:$.event_time`,
    `channel` String `json:$.channel`,
    `campaign` String `json:$.campaign`,
    `user_id` String `json:$.user_id`,
    `event_type` String `json:$.event_type`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(event_time)"
ENGINE_SORTING_KEY "event_time, channel, campaign"
```

The schema is designed to optimize query performance with sorting keys, allowing for faster retrieval based on `event_time`, `channel`, and `campaign`. For data ingestion, Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request. The real-time nature of the Events API ensures low latency from the moment data is sent to when it's queryable:

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

Besides the Events API, Tinybird also supports Kafka connectors for streaming data, and the [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api) and S3 connectors for batch or file data, expanding your options for data ingestion. ## Transforming data and publishing APIs

Tinybird transforms your data through pipes, which can be used for batch transformations, real-time transformations ([Materialized views](https://www.tinybird.co/docs/forward/work-with-data/optimize/materialized-views)), and creating API endpoints. Let's focus on publishing APIs for our marketing analytics use case. ### events_by_channel

This endpoint aggregates marketing events by channel:

```sql
DESCRIPTION >
    Endpoint to retrieve the number of events by channel. NODE events_by_channel_node
SQL >
    SELECT channel, count() AS event_count
    FROM marketing_events
    GROUP BY channel

TYPE endpoint
```

This SQL query counts events for each channel, allowing you to compare performance across different marketing channels. By using the `GROUP BY` clause, you can easily aggregate data by specific attributes. ### events_by_campaign

Similarly, this endpoint aggregates events by campaign:

```sql
DESCRIPTION >
    Endpoint to retrieve the number of events by campaign. NODE events_by_campaign_node
SQL >
    SELECT campaign, count() AS event_count
    FROM marketing_events
    GROUP BY campaign

TYPE endpoint
```

This query helps you understand the effectiveness of different marketing campaigns by counting the events associated with each. ### total_events

To get a high-level overview of marketing activity, this endpoint retrieves the total number of events:

```sql
DESCRIPTION >
    Endpoint to retrieve the total number of events. NODE total_events_node
SQL >
    SELECT count() AS total_events
    FROM marketing_events

TYPE endpoint
```

These [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints) are automatically scalable and can handle large volumes of requests without additional configuration. Example API call:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/events_by_channel.json?token=$TB_ADMIN_TOKEN"
```


## Deploying to production

Deploying your project to Tinybird Cloud is straightforward with the `tb --cloud deploy` command. This process creates production-ready, scalable API endpoints. Tinybird manages resources as code, enabling seamless integration with CI/CD pipelines and ensuring your data analytics backend is always up to date. Securing your APIs is crucial, and Tinybird facilitates this with token-based authentication, ensuring that only authorized users can access your endpoints:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/total_events.json?token=$TB_ADMIN_TOKEN"
```


## Conclusion

In this tutorial, you learned how to build a real-time analytics API for multi-channel marketing campaigns using Tinybird. From understanding the data and designing schemas to transforming data and publishing scalable APIs, Tinybird streamlines the process, allowing you to focus on delivering insights rather than managing infrastructure. Building real-time analytics solutions is more accessible than ever with Tinybird. [Sign up for Tinybird](https://cloud.tinybird.co/signup) to build and deploy your first real-time data APIs in a few minutes.