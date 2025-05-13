# Build a Real-Time Social Media Interaction Analytics API with Tinybird

Social media platforms generate massive amounts of data every second. From posts and comments to likes and shares, each interaction is a valuable piece of the broader engagement puzzle. Analyzing this data in real time can provide insights into trending content, user behavior, and platform-specific engagement patterns. However, processing and analyzing these interactions at scale and in real time presents a technical challenge. Tinybird is a data analytics backend for software developers. You use Tinybird to build real-time analytics APIs without needing to set up or manage the underlying infrastructure. Tinybird offers a local-first development workflow, git-based deployments, resource definitions as code, and features for AI-native developers. By leveraging Tinybird's data sources and [pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV), developers can ingest, transform, and expose social media interactions through high-performance APIs. This tutorial will guide you through creating an API to analyze social media interactions across different platforms using Tinybird. 

## Understanding the data

Imagine your data looks like this:

```json
{"interaction_id": "int_21187", "user_id": "user_1187", "interaction_type": "share", "content_id": "content_1187", "platform": "Instagram", "timestamp": "2025-05-04 22:23:46", "text_content": "This is a sample text content for interaction #187", "engagement_count": 187, "tags": ["tag1", "tag2"]}
{"interaction_id": "int_52361", "user_id": "user_2361", "interaction_type": "comment", "content_id": "content_2361", "platform": "Facebook", "timestamp": "2025-05-11 16:23:46", "text_content": "This is a sample text content for interaction #361", "engagement_count": 361, "tags": ["tag1"]}
... ```

This data represents individual social media interactions, including the type of interaction (e.g., post, comment, like, share), the platform it occurred on, and engagement metrics such as counts and timestamps. To store this data in Tinybird, create a data source `social_interactions` with the following schema:

```json
{
  "DESCRIPTION": "Raw social media interactions including posts, comments, likes, and shares",
  "SCHEMA": [
    {"name": "interaction_id", "type": "String", "json_path": "$.interaction_id"},
    {"name": "user_id", "type": "String", "json_path": "$.user_id"},
    {"name": "interaction_type", "type": "String", "json_path": "$.interaction_type"},
    {"name": "content_id", "type": "String", "json_path": "$.content_id"},
    {"name": "platform", "type": "String", "json_path": "$.platform"},
    {"name": "timestamp", "type": "DateTime", "json_path": "$.timestamp"},
    {"name": "text_content", "type": "String", "json_path": "$.text_content"},
    {"name": "engagement_count", "type": "Int32", "json_path": "$.engagement_count"},
    {"name": "tags", "type": "Array(String)", "json_path": "$.tags[:]" }
  ],
  "ENGINE": "MergeTree",
  "ENGINE_PARTITION_KEY": "toYYYYMM(timestamp)",
  "ENGINE_SORTING_KEY": "platform, interaction_type, timestamp"
}
```

Schema design choices, such as the sorting key (`ENGINE_SORTING_KEY`), are crucial for optimizing query performance, especially for time-series data like social media interactions. 

### Data ingestion

Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request. This real-time nature and low latency make it ideal for social media analytics, where data freshness is critical. Example ingestion code:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=social_interactions&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV" \
  -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
  -d '{
    "interaction_id": "int123456",
    "user_id": "user789",
    "interaction_type": "comment",
    "content_id": "post4567",
    "platform": "instagram",
    "timestamp": "2023-05-15 14:30:00",
    "text_content": "Great post about data analytics!",
    "engagement_count": 12,
    "tags": ["data", "analytics", "social"]
  }'
```

For event or streaming data, Tinybird’s Kafka connector offers benefits like fault tolerance and scalable message processing. For batch or file data, the [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) and S3 connector facilitate efficient bulk data uploads. 

## Transforming data and publishing APIs

Tinybird's pipes allow for batch transformations (copies), real-time transformations ([Materialized views](https://www.tinybird.co/docs/forward/work-with-data/optimize/materialized-views?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV)), and creating API endpoints. 

### Trending content API

To identify trending content, we use a pipe that aggregates interaction data by content ID, filters by engagement within a specified time range, and returns content sorted by engagement count. ```sql
%
SELECT 
    content_id,
    any(text_content) AS sample_text,
    count() AS interaction_count,
    sum(engagement_count) AS total_engagement,
    max(timestamp) AS latest_interaction,
    groupArray(10)(distinct tags) AS common_tags
FROM social_interactions
WHERE 
    timestamp >= now() - interval {{Int32(hours_back, 24)}} hour
    {% if defined(platform_filter) %}
    AND platform = {{String(platform_filter, 'all')}}
    {% end %}
GROUP BY content_id
HAVING interaction_count >= {{Int32(min_interactions, 10)}}
ORDER BY total_engagement DESC
LIMIT {{Int32(limit, 50)}}

TYPE endpoint
```

This query demonstrates the flexibility of Tinybird's SQL engine, allowing for complex aggregations, conditional logic, and parameterized queries. Example API call:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/trending_content.json?token=%24TB_ADMIN_TOKEN&hours_back=48&min_interactions=15&platform_filter=twitter&limit=20&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV"
```


#

## Deploying to production

Deploy your project to Tinybird Cloud using the command:

```bash
tb --cloud deploy
```

This command creates production-ready, scalable API [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV). Tinybird manages resources as code, enabling CI/CD integration and token-based authentication for API security. Example curl command to call a deployed endpoint:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_activity_analysis.json?token=%24TB_ADMIN_TOKEN&since=2023-04-01+00%3A00%3A00&min_engagement=10&limit=50&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV"
```


## Conclusion

Throughout this tutorial, we've built a real-time analytics API for social media interactions using Tinybird. We covered data ingestion, transformation, and API publishing, showcasing Tinybird's capabilities in handling real-time, large-scale data workloads. By leveraging Tinybird, developers can focus on delivering value rather than managing infrastructure. [Sign up for Tinybird](https://cloud.tinybird.co/signup?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) to build and deploy your first real-time data APIs in a few minutes. With no time limit and no credit card required, you can start exploring the full potential of your data today.