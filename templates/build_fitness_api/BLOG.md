# Build a Real-Time Fitness Wearable Data Analysis API with Tinybird

In the realm of health and fitness technology, the ability to analyze wearable device data in real-time can offer users immediate insights into their physical activities, heart rate patterns, and overall health metrics. Crafting an API to process this data efficiently requires a robust backend capable of handling high-velocity data ingestion and complex analytical queries. This tutorial guides you through building an API using Tinybird, which ingests raw fitness metrics like steps, heart rate, and calories burned, and provides [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints) for retrieving daily summaries, recent activity, and heart rate analysis. Tinybird is a data analytics backend for software developers. You use Tinybird to build real-time analytics APIs without needing to set up or manage the underlying infrastructure. It leverages data sources and pipes to ingest, transform, and serve large volumes of data through high-performance APIs. In this tutorial, we'll use Tinybird to implement a solution that allows for real-time analysis of fitness wearable data, providing valuable insights into individual user activities and health trends. ## Understanding the data

Imagine your data looks like this:

```json
{"user_id": "user_23", "device_id": "device_3", "timestamp": "2025-04-27 15:52:24", "steps": 522, "heart_rate": 82, "calories_burned": 172.2, "distance_meters": 552.2, "sleep_minutes": 122, "active_minutes": 2}
{"user_id": "user_51", "device_id": "device_11", "timestamp": "2025-04-28 03:52:24", "steps": 1150, "heart_rate": 110, "calories_burned": 135, "distance_meters": 1115, "sleep_minutes": 110, "active_minutes": 110}
```

This data represents metrics collected from fitness wearables, such as steps walked, heart rate, calories burned, and distance covered. To store this data, we create a Tinybird data source with a schema designed to optimize query performance. ```json
DESCRIPTION >
    Raw fitness wearable data containing metrics like steps, heart rate, and calories burned

SCHEMA >
    `user_id` String `json:$.user_id`,
    `device_id` String `json:$.device_id`,
    `timestamp` DateTime `json:$.timestamp`,
    `steps` Int32 `json:$.steps`,
    `heart_rate` Int16 `json:$.heart_rate`,
    `calories_burned` Float32 `json:$.calories_burned`,
    `distance_meters` Float32 `json:$.distance_meters`,
    `sleep_minutes` Int16 `json:$.sleep_minutes`,
    `active_minutes` Int16 `json:$.active_minutes`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(timestamp)"
ENGINE_SORTING_KEY "user_id, timestamp"
```

This schema includes types and keys that ensure efficient data storage and querying. For instance, sorting by `user_id` and `timestamp` improves the performance of time-series queries. Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=fitness_data" \
    -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
    -d '{
      "user_id": "user123",
      "device_id": "device456",
      "timestamp": "2023-03-15 14:30:00",
      "steps": 8542,
      "heart_rate": 72,
      "calories_burned": 325.5,
      "distance_meters": 6250.0,
      "sleep_minutes": 0,
      "active_minutes": 45
    }'
```

This ingestion method is particularly suited for real-time data with low latency. Other ingestion options include a Kafka connector for event/streaming data, which allows for reliable, scalable ingestion, and the [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api) and S3 connector for batch/file data. ## Transforming data and publishing APIs

Tinybird's [pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes) enable batch and real-time data transformations and the creation of API endpoints. Let's explore how to use pipes to build our fitness data analysis API. ### Daily User Summary

The `user_daily_summary` pipe summarizes fitness metrics by user and day:

```sql
DESCRIPTION >
    Summarizes fitness metrics by user and day

NODE user_daily_metrics
SQL >
    SELECT
        user_id,
        toDate(timestamp) as date,
        sum(steps) as total_steps,
        avg(heart_rate) as avg_heart_rate,
        sum(calories_burned) as total_calories,
        sum(distance_meters) as total_distance,
        sum(sleep_minutes) as total_sleep,
        sum(active_minutes) as total_active
    FROM fitness_data
    WHERE 1=1
    AND user_id = '{{String(user_id)}}'
    AND date >= '{{Date(start_date, "2023-01-01")}}'
    AND date <= '{{Date(end_date, "2023-12-31")}}'
    GROUP BY user_id, date
    ORDER BY user_id, date DESC

TYPE endpoint
```

This pipe creates an endpoint that aggregates daily fitness data for a user, allowing for flexible date range queries. The SQL logic demonstrates how to efficiently summarize time-series data. ### Recent Activity

The `recent_activity` pipe retrieves the most recent fitness data entries for a specific user:

```sql
DESCRIPTION >
    Retrieves the most recent fitness data for a specific user

NODE recent_user_activity
SQL >
    SELECT
        user_id,
        device_id,
        timestamp,
        steps,
        heart_rate,
        calories_burned,
        distance_meters,
        sleep_minutes,
        active_minutes
    FROM fitness_data
    WHERE 1=1
    AND user_id = '{{String(user_id)}}'
    ORDER BY timestamp DESC
    LIMIT {{Int32(limit, 100)}}

TYPE endpoint
```

This endpoint enables querying of the latest activities by user, showcasing the real-time capabilities of Tinybird APIs. ### Heart Rate Analysis

The `heart_rate_analysis` pipe provides heart rate statistics for users over a specified period:

```sql
DESCRIPTION >
    Provides heart rate statistics for users

NODE heart_rate_stats
SQL >
    SELECT
        user_id,
        toDate(timestamp) as date,
        min(heart_rate) as min_heart_rate,
        max(heart_rate) as max_heart_rate,
        avg(heart_rate) as avg_heart_rate,
        count() as readings_count
    FROM fitness_data
    WHERE heart_rate > 0
    AND user_id = '{{String(user_id)}}'
    AND date >= '{{Date(start_date, "2023-01-01")}}'
    AND date <= '{{Date(end_date, "2023-12-31")}}'
    GROUP BY user_id, date
    ORDER BY date DESC

TYPE endpoint
```

This analysis is critical for monitoring cardiovascular health and exercise intensity over time. ## Deploying to production

Deploy your Tinybird project to the cloud with the following command:

```bash
tb --cloud deploy
```

This command makes your data APIs production-ready and scalable. Tinybird manages resources as code, facilitating integration with CI/CD pipelines and ensuring that your APIs are secure and performant. Here's an example of how to call one of the deployed endpoints:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_daily_summary.json?token=$TB_ADMIN_TOKEN&user_id=user123&start_date=2023-01-01&end_date=2023-12-31"
```

Token-based authentication secures your endpoints, ensuring data privacy and integrity. ## Conclusion

In this tutorial, we've built a real-time API for analyzing fitness wearable data using Tinybird. We've covered data ingestion, transformation, and the creation of API endpoints tailored for real-time fitness data analysis, including daily summaries, recent activity, and heart rate analysis. The benefits of using Tinybird for this use case include efficient data management, real-time analytics, and scalable, secure API endpoints. [Sign up for Tinybird](https://cloud.tinybird.co/signup) to build and deploy your first real-time data APIs in a few minutes. Start for free, with no time limit and no credit card required, and leverage the power of real-time data analytics for your projects.