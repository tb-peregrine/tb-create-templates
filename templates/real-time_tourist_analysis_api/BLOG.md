# Build a Real-Time Tourist Movement Analytics API with Tinybird

Tourism is a dynamic and ever-evolving industry, requiring constant adaptation and understanding of tourist behavior to optimize services and enhance visitor experiences. Analyzing tourist movement patterns in real-time can significantly aid in this endeavor, providing immediate insights into popular locations, peak visiting times, and demographic trends. This tutorial will guide you through creating a real-time API for analyzing tourist movement data using Tinybird. Tinybird is a data analytics backend for software developers. You use Tinybird to build real-time analytics APIs without needing to set up or manage the underlying infrastructure. Tinybird offers a local-first development workflows, git-based deployments, resource definitions as code, and features for AI-native developers. By leveraging Tinybird's data sources and pipes, you can implement powerful APIs capable of handling large volumes of data with low latency, enabling real-time analysis and decision-making. In this guide, we'll cover how to ingest tourist movement data into Tinybird, perform transformations to generate meaningful insights, and ultimately publish [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints) for querying this data in real-time. Whether you're working for a tourism board, city planning department, or in the hospitality industry, this API can provide valuable insights into visitor behavior. ## Understanding the data

Imagine your data looks like this:

```json
{"tourist_id": "tourist_1538", "location_id": "loc_38", "location_name": "Sydney Opera House", "latitude": 607421466, "longitude": 607421376, "country": "Japan", "city": "Tokyo", "timestamp": "2025-04-23 23:30:49", "activity_type": "Shopping", "duration_minutes": 33, "tourist_origin": "Brazil", "age_group": "18-24"}
```

This sample represents a single tourist movement, capturing various details such as the tourist's ID, location information, type of activity, and demographic details. To store and query this data efficiently, we create a Tinybird datasource with an appropriate schema to facilitate fast data ingestion and querying. ```json
DESCRIPTION >
    Records of tourist movements including location, timestamp, and tourist information

SCHEMA >
    `tourist_id` String `json:$.tourist_id`,
    `location_id` String `json:$.location_id`,
    `location_name` String `json:$.location_name`,
    `latitude` Float64 `json:$.latitude`,
    `longitude` Float64 `json:$.longitude`,
    `country` String `json:$.country`,
    `city` String `json:$.city`,
    `timestamp` DateTime `json:$.timestamp`,
    `activity_type` String `json:$.activity_type`,
    `duration_minutes` Int32 `json:$.duration_minutes`,
    `tourist_origin` String `json:$.tourist_origin`,
    `age_group` String `json:$.age_group`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(timestamp)"
ENGINE_SORTING_KEY "timestamp, location_id, tourist_id"
```

In this schema, we've chosen data types that best represent the nature of our data, such as `String` for textual data, `Float64` for geographic coordinates, and `DateTime` for timestamps. The sorting key is particularly important for query performance, as it determines the order in which data is stored on disk. Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request. This real-time capability ensures that your data is always up-to-date, enabling immediate analysis and reaction to trends. ```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=tourist_movements" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "tourist_id": "t12345",
       "location_id": "loc789",
       "location_name": "Sagrada Familia",
       "latitude": 41.4036,
       "longitude": 2.1744,
       "country": "Spain",
       "city": "Barcelona",
       "timestamp": "2023-06-15 14:30:00",
       "activity_type": "sightseeing",
       "duration_minutes": 120,
       "tourist_origin": "Germany",
       "age_group": "25-34"
     }'
```

For event or streaming data, the Kafka connector can be particularly beneficial for integrating with existing streams. For batch or file data, the [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api) and S3 connector provide flexible options for data ingestion. ## Transforming data and publishing APIs

With the data ingested, the next step is to transform this data into insightful metrics and expose them through APIs. Tinybird facilitates this through [pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes), which can perform batch transformations, real-time transformations, and create API endpoints. ### Hourly Movement Patterns

```sql
DESCRIPTION >
    Analyzes tourist movement patterns by hour of day

NODE hourly_movement_node
SQL >
    %
    SELECT 
        toHour(timestamp) AS hour_of_day,
        count() AS movement_count,
        uniq(tourist_id) AS unique_tourists,
        uniq(location_id) AS unique_locations,
        avg(duration_minutes) AS avg_duration
    FROM tourist_movements
    WHERE timestamp BETWEEN {{DateTime(start_date, '2023-01-01 00:00:00')}} AND {{DateTime(end_date, '2023-12-31 23:59:59')}}
    AND location_id = {{String(location_id, '')}}
    AND activity_type = {{String(activity_type, '')}}
    GROUP BY hour_of_day
    ORDER BY hour_of_day ASC

TYPE endpoint
```

This pipe computes the number of movements, unique tourists, and locations visited per hour of day, providing insights into peak visiting times and average visit duration. The query parameters allow for flexible API requests, filtering by date range, location, and activity type. ### Tourist Origin Analysis

```sql
DESCRIPTION >
    Analyzes tourist movements by their country of origin

NODE tourist_origin_node
SQL >
    %
    SELECT 
        tourist_origin,
        count() AS visit_count,
        uniq(tourist_id) AS tourist_count,
        uniq(location_id) AS locations_visited,
        avg(duration_minutes) AS avg_duration,
        count() / uniq(tourist_id) AS avg_visits_per_tourist
    FROM tourist_movements
    WHERE timestamp BETWEEN {{DateTime(start_date, '2023-01-01 00:00:00')}} AND {{DateTime(end_date, '2023-12-31 23:59:59')}}
    AND country = {{String(destination_country, 'Spain')}}
    GROUP BY tourist_origin
    ORDER BY tourist_count DESC
    LIMIT {{Int32(limit, 20)}}

TYPE endpoint
```

This endpoint enables querying of tourist movements based on their origin country, providing insights into the most frequent visitors and their behavior patterns. ## Deploying to production

Deploying your Tinybird project to production is as simple as using the Tinybird CLI with the `tb --cloud deploy` command. This command deploys your [data sources](https://www.tinybird.co/docs/forward/get-data-in/data-sources), pipes, and endpoints to the Tinybird Cloud, making them scalable and ready for production use. ```bash
tb --cloud deploy
```

Tinybird manages resources as code, which means your entire data pipeline can be versioned and integrated into your CI/CD workflows. This approach ensures that changes can be rolled out reliably and consistently across environments. To secure your APIs, Tinybird uses token-based authentication, ensuring that only authorized users can access your endpoints. ```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/popular_locations.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&country=Spain&city=Barcelona&limit=5"
```


## Conclusion

By following this tutorial, you've learned how to ingest tourist movement data into Tinybird, transform it into insightful metrics, and publish real-time APIs to access these insights. Tinybird's capabilities enable you to handle large volumes of data efficiently, making it an ideal choice for building real-time analytics applications. [Sign up for Tinybird](https://cloud.tinybird.co/signup) to build and deploy your first real-time data APIs in a few minutes.