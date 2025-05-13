# Build a Real-Time Geolocation Analytics API with Tinybird

Geolocation data is pivotal for applications that track user movements, analyze spatial patterns, or deliver location-based services. Whether it's for tracking delivery vehicles in real-time, analyzing foot traffic in a retail store, or providing personalized content based on user location, the ability to process and analyze geolocation data efficiently is crucial. In this tutorial, you'll learn how to build a real-time API for processing and analyzing geolocation data using Tinybird. Tinybird is a data analytics backend for software developers. You use Tinybird to build real-time analytics APIs without needing to set up or manage the underlying infrastructure. Tinybird offers a local-first development workflows, git-based deployments, resource definitions as code, and features for AI-native developers. By leveraging Tinybird's data sources and [pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV), you can easily ingest, transform, and serve geolocation data through high-performance APIs. This tutorial will guide you through creating data sources to store geolocation events, transforming this data to extract meaningful insights, and finally, deploying scalable APIs for tracking user locations, retrieving user location history, analyzing location data over time, and finding nearby users based on coordinates. Let's dive into the world of real-time geolocation analytics with Tinybird. 

## Understanding the data

Imagine your data looks like this:

```json
{"user_id": "user_396", "latitude": 2023638.396, "longitude": 2023548.396, "accuracy": 11, "event_type": "departed", "device_id": "device_396", "timestamp": "2025-04-13 09:32:45"}
{"user_id": "user_169", "latitude": 1828226.169, "longitude": 1828136.169, "accuracy": 64, "event_type": "exited_region", "device_id": "device_169", "timestamp": "2025-04-13 19:46:15"}
```

This data represents location events captured from users, including their IDs, coordinates (latitude and longitude), the accuracy of the location data, the type of event (e.g., check-in, departure), the device ID, and the timestamp of the event. To store this data in Tinybird, you create a data source with the following schema:

```json
DESCRIPTION >
    Stores location events with user IDs, coordinates, and timestamps

SCHEMA >
    `user_id` String `json:$.user_id`,
    `latitude` Float64 `json:$.latitude`,
    `longitude` Float64 `json:$.longitude`,
    `accuracy` Float32 `json:$.accuracy`,
    `event_type` String `json:$.event_type`,
    `device_id` String `json:$.device_id`,
    `timestamp` DateTime `json:$.timestamp`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(timestamp)"
ENGINE_SORTING_KEY "timestamp, user_id, event_type"
```

This schema is designed to optimize query performance by sorting data by `timestamp`, `user_id`, and `event_type`. The `MergeTree` engine, combined with appropriate partitioning and sorting keys, ensures efficient data storage and retrieval. To ingest data into this data source, Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request. The real-time nature of the Events API and its low latency make it ideal for geolocation data:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=location_events&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "user_id": "user_123",
       "latitude": 40.7128,
       "longitude": -74.0060,
       "accuracy": 15.5,
       "event_type": "check_in",
       "device_id": "device_abc",
       "timestamp": "2023-10-15 14:30:00"
     }'
```

For event/streaming data, the Kafka connector provides a robust option for integrating with existing Kafka streams. For batch or file-based data, the [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) and S3 connector offer flexible ingestion methods. 

## Transforming data and publishing APIs

Tinybird transforms data through pipes, allowing for batch transformations, real-time transformations ([Materialized views](https://www.tinybird.co/docs/forward/work-with-data/optimize/materialized-views?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV)), and the creation of API endpoints. 

### User Location History

The `user_location_history` endpoint retrieves a user's location history within a specified time range:

```sql
DESCRIPTION >
    Retrieve location history for a specific user within a time range

NODE user_location_history_node
SQL >
    SELECT 
        user_id,
        latitude,
        longitude,
        accuracy,
        event_type,
        device_id,
        timestamp
    FROM location_events
    WHERE 
        user_id = {{String(user_id, '')}}
        AND timestamp >= {{DateTime(start_time, '2023-01-01 00:00:00')}}
        AND timestamp <= {{DateTime(end_time, '2023-12-31 23:59:59')}}
    ORDER BY timestamp DESC
    LIMIT {{Int32(limit, 1000)}}

TYPE endpoint
```

This pipe filters location events by `user_id` and a date/time range, orders the results by `timestamp`, and limits the output. The use of query parameters (`user_id`, `start_time`, `end_time`, `limit`) makes the API flexible, allowing for tailored queries. 

### Location Analytics

The `location_analytics` endpoint aggregates location event data over different time periods:

```sql
DESCRIPTION >
    Get analytics on location events by aggregating data over different time periods

NODE location_analytics_node
SQL >
    SELECT 
        {{String(time_bucket, 'hour')}} AS time_bucket,
        CASE 
            WHEN {{String(time_bucket, 'hour')}} = 'hour' THEN toStartOfHour(timestamp)
            WHEN {{String(time_bucket, 'hour')}} = 'day' THEN toStartOfDay(timestamp)
            WHEN {{String(time_bucket, 'hour')}} = 'week' THEN toStartOfWeek(timestamp)
            WHEN {{String(time_bucket, 'hour')}} = 'month' THEN toStartOfMonth(timestamp)
            ELSE toStartOfHour(timestamp)
        END AS bucket_start,
        event_type,
        count() AS event_count,
        count(DISTINCT user_id) AS unique_users,
        avg(accuracy) AS avg_accuracy
    FROM location_events
    WHERE 
        timestamp >= {{DateTime(start_time, '2023-01-01 00:00:00')}}
        AND timestamp <= {{DateTime(end_time, '2023-12-31 23:59:59')}}
        AND event_type = {{String(event_type, '')}}
    GROUP BY 
        time_bucket,
        bucket_start,
        event_type
    ORDER BY bucket_start DESC

TYPE endpoint
```

This pipe allows for dynamic aggregation based on a specified `time_bucket` (e.g., hour, day, week, month) and filters events by type and time range. It calculates the count of events, unique users, and average accuracy of location data. 

### Nearby Users

The `nearby_users` endpoint finds users within a specified radius of given coordinates:

```sql
DESCRIPTION >
    Find users within a specified radius of a given coordinate

NODE nearby_users_node
SQL >
    SELECT 
        user_id,
        latitude,
        longitude,
        event_type,
        timestamp,
        111.111 * 
        SQRT(
            POW(latitude - {{Float64(target_lat, 0.0)}}, 2) + 
            POW(longitude * COS(PI() * latitude / 180.0) - {{Float64(target_lon, 0.0)}} * COS(PI() * {{Float64(target_lat, 0.0)}} / 180.0), 2)
        ) AS distance_km
    FROM location_events
    WHERE 
        timestamp >= {{DateTime(start_time, '2023-01-01 00:00:00')}} AND 
        timestamp <= {{DateTime(end_time, '2023-12-31 23:59:59')}}
        AND 111.111 * 
        SQRT(
            POW(latitude - {{Float64(target_lat, 0.0)}}, 2) + 
            POW(longitude * COS(PI() * latitude / 180.0) - {{Float64(target_lon, 0.0)}} * COS(PI() * {{Float64(target_lat, 0.0)}} / 180.0), 2)
        ) <= {{Float64(radius_km, 1.0)}}
    ORDER BY distance_km ASC
    LIMIT {{Int32(limit, 100)}}

TYPE endpoint
```

This pipe calculates the distance between a target location and each event's coordinates, filtering results by distance, time, and limiting the number of results. It's an efficient way to find nearby users within a given radius. 

## Deploying to production

Deploying your project to Tinybird Cloud is straightforward with the `tb --cloud deploy` command. This command creates production-ready, scalable API [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV). Tinybird manages resources as code, which complements CI/CD workflows by allowing for automated deployments and version control of your data analytics pipelines. Securing your APIs is essential, and Tinybird provides token-based authentication to ensure that only authorized requests can access your endpoints. Here's how you might call one of the deployed endpoints:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_location_history.json?token=%24TB_ADMIN_TOKEN&user_id=user_123&start_time=2023-01-01+00%3A00%3A00&end_time=2023-12-31+23%3A59%3A59&limit=500&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV"
```


## Conclusion

In this tutorial, you've built a real-time geolocation analytics API with Tinybird. You've learned how to ingest geolocation data, transform it to extract meaningful insights, and deploy scalable APIs for various geolocation analytics use cases. Tinybird simplifies the process of building and managing real-time data pipelines, allowing you to focus on creating value from your data. [Sign up for Tinybird](https://cloud.tinybird.co/signup?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) to build and deploy your first real-time data APIs in a few minutes. Tinybird is free to start, with no time limit and no credit card required, enabling you to experiment and scale your data projects efficiently.