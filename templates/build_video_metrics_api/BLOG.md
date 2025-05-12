# Build a Real-Time Video Streaming Analytics API with Tinybird

In today's world, video streaming platforms are in constant need of optimizing their user experience. To achieve this, it's crucial to analyze video streaming metrics such as video quality, CDN (Content Delivery Network) performance, and user engagement patterns in real-time. This tutorial will guide you through building a real-time API to glean these insights using Tinybird. Tinybird is a data analytics backend for software developers. You use Tinybird to build real-time analytics APIs without needing to set up or manage the underlying infrastructure. Tinybird offers a local-first development workflows, git-based deployments, resource definitions as code, and features for AI-native developers. By leveraging Tinybird's data sources and pipes, you can efficiently process and analyze streaming events from a video platform to provide actionable data through API [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints). Let's dive into how to set up your data, transform it, and ultimately deploy a production-ready API for video streaming analytics. ## Understanding the data

Imagine your data looks like this:

```json
{
  "event_id": "evt_B06878A3D9A1",
  "timestamp": "2025-05-12 00:34:03",
  "user_id": "user_4098",
  "video_id": "vid_4098",
  "event_type": "complete",
  "duration": 299,
  "buffer_count": 8,
  "quality_level": "1080p",
  "device_type": "smart_tv",
  "country": "AU",
  "session_id": "sess_1BACB730",
  "position": 2098,
  "error_type": "player_error",
  "cdn": "Cloudflare"
}
```

This data represents a single event from a video streaming platform, capturing metrics like video playbacks, buffering events, and user interactions. To store this data in Tinybird, you create a data source with a schema tailored to this structure. ```json
DESCRIPTION >
    Raw events from video streaming platform including video views, quality metrics, and user interactions

SCHEMA >
    `event_id` String `json:$.event_id`,
    `timestamp` DateTime `json:$.timestamp`,
    `user_id` String `json:$.user_id`,
    `video_id` String `json:$.video_id`,
    `event_type` String `json:$.event_type`,
    `duration` Float64 `json:$.duration`,
    `buffer_count` UInt16 `json:$.buffer_count`,
    `quality_level` String `json:$.quality_level`,
    `device_type` String `json:$.device_type`,
    `country` String `json:$.country`,
    `session_id` String `json:$.session_id`,
    `position` Float64 `json:$.position`,
    `error_type` String `json:$.error_type`,
    `cdn` String `json:$.cdn`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(timestamp)"
ENGINE_SORTING_KEY "timestamp, video_id, user_id, event_type"
```

The choice of `MergeTree` as the engine and the sorting keys is designed to optimize the performance of queries that filter by timestamp, video ID, or user ID. Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request. This means you can ingest data in real-time with low latency, which is perfect for tracking streaming metrics as they happen. ```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=video_streaming_events" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{ "event_id": "ev_12345", "timestamp": "2023-05-15 14:30:00", ...}'
```

For event or streaming data, you might also consider using the Kafka connector for more robust data ingestion, especially if you're already using Kafka. For batch or file data, the [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api) and S3 connector provide additional flexibility and efficiency. ## Transforming data and publishing APIs

With your data ingested, the next step is to transform this data and publish it through API endpoints. Tinybird facilitates this with [pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes), which can be used for batch transformations, real-time transformations, and creating API endpoints. ### Video Performance by CDN

Let's start by creating an endpoint to compare video streaming performance across different CDNs. ```sql
DESCRIPTION >
    API endpoint to compare video streaming performance across different CDNs

SQL >
    SELECT 
        cdn,
        quality_level,
        count() AS view_count,
        round(avg(duration), 2) AS avg_duration,
        ... FROM video_streaming_events
    ... TYPE endpoint
```

This SQL query aggregates data by CDN and quality level, providing metrics like view count and average duration. The use of query parameters (`{{}}`) makes the API flexible, allowing users to filter data by date range, CDN, or quality level. Example API call:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/video_performance_by_cdn.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&cdn=cloudfront"
```


### Video Quality Metrics and User Streaming Activity

Similarly, you can set up pipes for `video_quality_metrics` and `user_streaming_activity` endpoints, following the same pattern of SQL queries and leveraging Tinybird's ability to create dynamic, real-time APIs. ## Deploying to production

Once your endpoints are set up and tested, deploying your project to Tinybird Cloud is straightforward with the `tb --cloud deploy` command. This command deploys all your [data sources](https://www.tinybird.co/docs/forward/get-data-in/data-sources) and pipes to the cloud, making them scalable and ready for production use. Tinybird treats your resources as code, which means you can easily integrate this deployment process into your CI/CD pipelines, ensuring that your data analytics infrastructure is as agile as your application codebase. Secure your endpoints using token-based authentication to ensure that only authorized users can access your APIs. ```bash
curl -X GET "https://api.tinybird.co/v0/pipes/your_pipe_name.json?token=$TB_USER_TOKEN"
```


## Conclusion

Throughout this tutorial, you've learned how to ingest streaming data into Tinybird, transform it using pipes, and publish real-time analytics APIs to monitor video streaming performance. These APIs can provide valuable insights into CDN performance, video quality issues, and user engagement patterns, all in real-time. By leveraging Tinybird for your data analytics backend, you can focus on building and optimizing your application without worrying about the underlying infrastructure for data processing and API management. [Sign up for Tinybird](https://cloud.tinybird.co/signup) to build and deploy your first real-time data APIs in a few minutes.