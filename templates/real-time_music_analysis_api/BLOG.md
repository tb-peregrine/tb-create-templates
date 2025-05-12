# Build a Music Streaming Analytics API with Tinybird

Tracking and analyzing music streaming behavior offers valuable insights into user preferences, popular tracks, and emerging genre trends. However, processing and querying large volumes of streaming data in real-time can be challenging. This is where Tinybird comes in. Tinybird is a data analytics backend for software developers. You use Tinybird to build real-time analytics APIs without needing to set up or manage the underlying infrastructure. Tinybird offers a local-first development workflows, git-based deployments, resource definitions as code, and features for AI-native developers. By leveraging Tinybird's data sources and [pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes), developers can efficiently implement real-time analytics APIs that handle streaming data at scale. This tutorial will walk you through creating a music streaming analytics API using Tinybird, focusing on tracking user listening patterns, identifying popular tracks, analyzing user activity, and monitoring genre trends over time. We'll start by setting up the data sources, then transform the data and publish the APIs, and finally, deploy to production. ## Understanding the data

Imagine your data looks like this:

```json
{"stream_id": "stream_6408", "user_id": "user_408", "track_id": "track_1408", "artist_id": "artist_408", "album_id": "album_408", "genre": "blues", "stream_start_time": "2025-04-14 01:31:02", "stream_duration_seconds": 148, "completed": 0, "device_type": "smart_speaker", "country": "IN"}
{"stream_id": "stream_1150", "user_id": "user_150", "track_id": "track_1150", "artist_id": "artist_150", "album_id": "album_150", "genre": "rock", "stream_start_time": "2025-05-01 19:31:02", "stream_duration_seconds": 250, "completed": 0, "device_type": "mobile", "country": "US"}
... ```

This data represents individual music streaming events, capturing various attributes such as the user, track, artist, album, genre, and the duration of each stream. To store this data in Tinybird, we create a datasource with the following schema:

```json
DESCRIPTION >
    Records of music streaming events capturing user listening behavior

SCHEMA >
    `stream_id` String `json:$.stream_id`,
    `user_id` String `json:$.user_id`,
    `track_id` String `json:$.track_id`,
    `artist_id` String `json:$.artist_id`,
    `album_id` String `json:$.album_id`,
    `genre` String `json:$.genre`,
    `stream_start_time` DateTime `json:$.stream_start_time`,
    `stream_duration_seconds` Int32 `json:$.stream_duration_seconds`,
    `completed` UInt8 `json:$.completed`,
    `device_type` String `json:$.device_type`,
    `country` String `json:$.country`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(stream_start_time)"
ENGINE_SORTING_KEY "stream_start_time, country, user_id"
```

The schema design choices, such as sorting keys, significantly impact query performance. Sorting by `stream_start_time`, `country`, and `user_id` optimizes queries that filter by these attributes. Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request, enabling real-time data ingestion with low latency. Here's how you can ingest the sample data:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=music_streams" \
    -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
    -d '{
    "stream_id": "s123456",
    "user_id": "u789012", 
    "track_id": "t345678",
    "artist_id": "a123456",
    "album_id": "alb789012",
    "genre": "rock",
    "stream_start_time": "2023-03-15 14:30:00",
    "stream_duration_seconds": 240,
    "completed": 1,
    "device_type": "smartphone",
    "country": "US"
}'
```

Other ingestion methods include the Kafka connector for streaming data and the [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api) for batch/file data, offering flexibility based on your data pipeline needs. ## Transforming data and publishing APIs

Tinybird transforms data through pipes, which can perform batch transformations, real-time transformations, and even publish API [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints) directly from SQL queries. ### Top Tracks API

Let's start with an API endpoint that returns the top tracks within a given time period, which can be filtered by genre and country:

```sql
DESCRIPTION >
    API endpoint that returns the top tracks by number of streams within a given time period

NODE top_tracks_node
SQL >
    SELECT 
        track_id,
        count() as stream_count,
        sum(stream_duration_seconds) as total_duration,
        avg(stream_duration_seconds) as avg_duration,
        countIf(completed = 1) as completed_streams
    FROM music_streams
    WHERE stream_start_time BETWEEN {{DateTime(start_date, '2023-01-01 00:00:00')}} AND {{DateTime(end_date, '2023-12-31 23:59:59')}}
    AND genre = {{String(genre, 'pop')}}
    AND country = {{String(country, 'US')}}
    GROUP BY track_id
    ORDER BY stream_count DESC
    LIMIT {{Int32(limit, 10)}}

TYPE endpoint
```

This SQL query demonstrates the use of query parameters (`start_date`, `end_date`, `genre`, `country`, and `limit`) to make the API flexible and cater to different user requests. Here's how to call this API with specific parameters:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/top_tracks.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&genre=rock&country=US&limit=5"
```

The other endpoints, `user_activity` and `genre_trends`, follow similar patterns, creating APIs for analyzing user activity and genre popularity trends over time. ## Deploying to production

Deploying your project to Tinybird Cloud is straightforward with the `tb --cloud deploy` command. This action creates production-ready, scalable API endpoints. Tinybird's approach to resource management as code enables seamless integration with CI/CD pipelines, ensuring your data APIs are always up-to-date and secure. For example, to call a deployed endpoint securely, you use a token-based authentication:

```bash
curl -X GET "https://api.tinybird.co/v0/pipes/top_tracks.json?token=$TB_ADMIN_TOKEN&..."
```


## Conclusion

In this tutorial, you've learned how to build a music streaming analytics API using Tinybird, from ingesting streaming data to transforming this data and publishing real-time APIs. Tinybird's capabilities enable developers to handle large volumes of data efficiently, offering scalability and flexibility in data analytics projects. [Sign up for Tinybird](https://cloud.tinybird.co/signup) to build and deploy your first real-time data APIs in a few minutes.