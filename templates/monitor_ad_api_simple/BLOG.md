# Build a Real-Time Ad Performance Monitoring API with Tinybird

Monitoring the performance of digital advertising campaigns in real-time can significantly enhance the decision-making process for marketers, enabling them to adjust strategies on the fly for optimal performance. This tutorial will walk you through building a real-time ad performance monitoring API using Tinybird. Tinybird is a data analytics backend for software developers. You use Tinybird to build real-time analytics APIs without needing to set up or manage the underlying infrastructure. Tinybird offers a local-first development workflows, git-based deployments, resource definitions as code, and features for AI-native developers. By leveraging Tinybird's data sources and pipes, you'll learn how to ingest, transform, and expose your advertising data as API [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) for real-time monitoring and analysis. 

## Understanding the data

Imagine your data looks like this:

**Ad Impressions Sample Data:**
```json
[
  {"impression_id": "imp_53723", "ad_id": "ad_723", "campaign_id": "camp_23", "platform": "Email", "timestamp": "2025-05-12 09:14:32", "user_id": "user_3723", "country": "Germany", "device_type": "Smart TV"},
  {"impression_id": "imp_67930", "ad_id": "ad_930", "campaign_id": "camp_30", "platform": "Web", "timestamp": "2025-05-12 02:24:25", "user_id": "user_2930", "country": "USA", "device_type": "Desktop"}
]
```

**Ad Clicks Sample Data:**
```json
[
  {"click_id": "click_43877", "impression_id": "imp_43877", "ad_id": "ad_877", "campaign_id": "camp_77", "platform": "twitter", "timestamp": "2025-05-11 22:25:23", "user_id": "user_3877", "country": "BR", "device_type": "desktop"},
  {"click_id": "click_6605", "impression_id": "imp_6605", "ad_id": "ad_605", "campaign_id": "camp_5", "platform": "facebook", "timestamp": "2025-05-11 22:06:35", "user_id": "user_1605", "country": "FR", "device_type": "desktop"}
]
```

These samples represent the kind of data you might collect from an advertising platform, including impressions and clicks with metadata like IDs, platform, timestamp, and user information. To store this data in Tinybird, you'll create two [data sources](https://www.tinybird.co/docs/forward/get-data-in/data-sources?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV): `ad_impressions` and `ad_clicks`. Here's what the `.datasource` file for `ad_impressions` might look like:

```json
DESCRIPTION >
    Tracks ad impressions in real-time, including ad ID, platform, timestamp, and user information

SCHEMA >
    `impression_id` String `json:$.impression_id`,
    `ad_id` String `json:$.ad_id`,
    `campaign_id` String `json:$.campaign_id`,
    `platform` String `json:$.platform`,
    `timestamp` DateTime `json:$.timestamp`,
    `user_id` String `json:$.user_id`,
    `country` String `json:$.country`,
    `device_type` String `json:$.device_type`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(timestamp)"
ENGINE_SORTING_KEY "timestamp, ad_id, campaign_id"
```

This schema defines the structure of your data source, including types and keys for optimizing query performance. For data ingestion, Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request. This method is ideal for real-time advertising data:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=ad_impressions&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "impression_id": "imp-123456",
       "ad_id": "ad-789",
       "campaign_id": "camp-456",
       "platform": "mobile",
       "timestamp": "2023-05-01 14:30:00",
       "user_id": "user-abc123",
       "country": "US",
       "device_type": "smartphone"
     }'
```

Additionally, Tinybird supports other ingestion methods like Kafka for event/streaming data and the [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) or S3 connector for batch/file data. 

## Transforming data and publishing APIs

Tinybird's [pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) transform and publish your data as API endpoints. Pipes support batch transformations, real-time transformations, and the creation of API endpoints. For instance, the `campaign_performance_by_platform` pipe aggregates data to show campaign performance by platform:

```sql
DESCRIPTION >
    API endpoint that shows campaign performance broken down by platform

NODE campaign_performance_by_platform_node
SQL >
    SELECT 
        ai.campaign_id,
        ai.platform,
        count() AS impressions,
        countIf(ac.click_id IS NOT NULL) AS clicks,
        round(countIf(ac.click_id IS NOT NULL) / count() * 100, 2) AS ctr
    FROM ad_impressions AS ai
    LEFT JOIN ad_clicks AS ac ON ai.impression_id = ac.impression_id
    WHERE ai.timestamp BETWEEN {{DateTime(start_date, '2023-01-01 00:00:00')}} AND {{DateTime(end_date, '2023-12-31 23:59:59')}}
    {% if defined(campaign_id) %}
        AND ai.campaign_id = {{String(campaign_id, '')}}
    {% end %}
    GROUP BY ai.campaign_id, ai.platform
    ORDER BY ai.campaign_id, impressions DESC

TYPE endpoint
```

This pipe creates an endpoint that allows querying campaign performance by platform, leveraging SQL logic and query parameters for flexible analysis. 

## Deploying to production

Deploy your project to Tinybird Cloud with the `tb --cloud deploy` command. This command creates production-ready, scalable API endpoints. Tinybird manages resources as code, enabling integration with CI/CD pipelines and ensuring secure access through token-based authentication. Example API call:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/campaign_performance_by_platform.json?token=%24TB_ADMIN_TOKEN&start_date=2023-01-01+00%3A00%3A00&end_date=2023-12-31+23%3A59%3A59&campaign_id=camp-456&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV"
```


## Conclusion

In this tutorial, you've learned how to build a real-time ad performance monitoring API with Tinybird, from ingesting data to transforming it and publishing API endpoints. Tinybird simplifies the complexities of real-time data analytics, allowing developers to focus on creating value from their data. [Sign up for Tinybird](https://cloud.tinybird.co/signup?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) to build and deploy your first real-time data APIs in a few minutes.