# Build a Real-Time Social Media Sentiment Analysis API with Tinybird

Social media sentiment analysis is a critical tool for understanding public perception and engagement online. By analyzing the sentiment of posts across various platforms, developers can create applications that track trends, monitor brand perception, and gather valuable feedback directly from user-generated content. In this tutorial, we'll walk you through creating a real-time social media sentiment analysis API using Tinybird. Tinybird is a data analytics backend for software developers. You use Tinybird to build real-time analytics APIs without needing to set up or manage the underlying infrastructure. Tinybird offers a local-first development workflow, git-based deployments, resource definitions as code, and features for AI-native developers. This project leverages Tinybird's data sources and [pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) to ingest, transform, and serve social media sentiment data through efficient and scalable APIs. 

## Understanding the data

Imagine your data looks like this:

```json
{"post_id": "post_75602", "platform": "Instagram", "content": "New product launch is going great", "user_id": "user_5602", "timestamp": "2025-04-24 05:29:12", "likes": 602, "shares": 2, "sentiment_score": -0.96, "tags": ["politics", "politics"]}
{"post_id": "post_93877", "platform": "Instagram", "content": "Having technical difficulties today", "user_id": "user_3877", "timestamp": "2025-04-30 05:17:57", "likes": 877, "shares": 77, "sentiment_score": 0.54, "tags": ["science"]}
```

This data represents social media posts from various platforms, including metadata like `post_id`, `platform`, `user_id`, `timestamp`, `likes`, `shares`, and a `sentiment_score` indicating the post's overall sentiment. Tags associated with each post are also included. To store this data, we create a Tinybird data source:

```json
DESCRIPTION >
    Collection of social media posts with their metadata and content

SCHEMA >
    `post_id` String `json:$.post_id`,
    `platform` String `json:$.platform`,
    `content` String `json:$.content`,
    `user_id` String `json:$.user_id`,
    `timestamp` DateTime `json:$.timestamp`,
    `likes` Int32 `json:$.likes`,
    `shares` Int32 `json:$.shares`,
    `sentiment_score` Float32 `json:$.sentiment_score`,
    `tags` Array(String) `json:$.tags[:]`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(timestamp)"
ENGINE_SORTING_KEY "platform, timestamp, user_id"
```

The schema design specifies the data structure and types, ensuring efficient storage and retrieval. The sorting key improves query performance, especially for time-range searches and filtering by platform or user. For ingestion, Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request, providing low latency and real-time data updates:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=social_media_posts&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "post_id": "p12345",
       "platform": "twitter",
       "content": "I really love this new product! Amazing features.",
       "user_id": "user123",
       "timestamp": "2023-06-15 14:30:00",
       "likes": 42,
       "shares": 12,
       "sentiment_score": 0.85,
       "tags": ["product", "review", "positive"]
     }'
```

Other ingestion methods include a Kafka connector for event streaming and a [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) or S3 connector for batch/file data. 

## Transforming data and publishing APIs

Tinybird processes data through pipes, which can perform batch transformations, create [Materialized views](https://www.tinybird.co/docs/forward/work-with-data/optimize/materialized-views?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) for optimized query performance, and publish data through API endpoints. 

### top_posts.pipe

```sql
DESCRIPTION >
    Returns top posts based on engagement and sentiment with customizable filters

NODE top_posts_node
SQL >
    SELECT 
        post_id,
        platform,
        content,
        user_id,
        timestamp,
        likes,
        shares,
        sentiment_score,
        tags
    FROM social_media_posts
    WHERE 1=1
    AND timestamp >= {{DateTime(start_date, '2023-01-01 00:00:00')}}
    AND timestamp <= {{DateTime(end_date, '2023-12-31 23:59:59')}}
    AND platform = {{String(platform_filter, 'all')}}
    AND sentiment_score >= {{Float32(sentiment_min, -1.0)}}
    AND sentiment_score <= {{Float32(sentiment_max, 1.0)}}
    ORDER BY (likes + shares) DESC
    LIMIT {{Int32(limit, 10)}}

TYPE endpoint
```

This pipe creates an API endpoint that returns the top posts based on engagement or sentiment. The SQL logic is straightforward, filtering posts by date, platform, and sentiment score, then sorting by engagement or sentiment. The query parameters make the API flexible, allowing for dynamic filtering based on user input. Example API call:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/top_posts.json?token=%24TB_ADMIN_TOKEN&platform_filter=twitter&start_date=2023-01-01+00%3A00%3A00&end_date=2023-12-31+23%3A59%3A59&sort_by=engagement&limit=5&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV"
```


## Deploying to production

Deploying your Tinybird project to production is as simple as running `tb --cloud deploy`. This command deploys your data sources and pipes to the Tinybird Cloud, creating scalable, production-ready API [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV). Tinybird manages resources as code, making it easy to integrate with CI/CD pipelines. API security is handled through token-based authentication. To call your deployed endpoints:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/top_posts.json?token=%24PRODUCTION_TOKEN&platform_filter=twitter&start_date=2023-01-01&end_date=2023-12-31&sort_by=engagement&limit=5&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV"
```


## Conclusion

Throughout this tutorial, we've built a real-time social media sentiment analysis API using Tinybird. We've covered ingesting data with the Events API, transforming data through pipes, and deploying scalable API endpoints. Tinybird's infrastructure simplifies the development and deployment of real-time analytics applications, allowing developers to focus on building features rather than managing backend complexities. [Sign up for Tinybird](https://cloud.tinybird.co/signup?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) to build and deploy your first real-time data APIs in a few minutes.