# Build a Real-Time Traffic Analysis API for Smart Cities Using Tinybird

In the era of smart cities, the ability to analyze traffic in real-time is crucial for managing congestion, detecting incidents, and planning infrastructure. Traditional data processing solutions often struggle to handle the velocity and volume of data generated by modern urban environments. This tutorial explores how to leverage Tinybird to solve these challenges by building a real-time traffic analysis API. Tinybird is a data analytics backend for software developers. You use Tinybird to build real-time analytics APIs without needing to set up or manage the underlying infrastructure. Tinybird offers a local-first development workflows, git-based deployments, resource definitions as code, and features for AI-native developers. Through this tutorial, you'll learn how to create data sources to store traffic events data, transform this data using [pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV), and publish APIs that deliver valuable traffic insights. This approach enables city officials to make informed decisions based on the latest traffic conditions, incident reports, and historical traffic patterns. 

## Understanding the data

Imagine your data looks like this:

```json
{"event_id": "evt_5631", "device_id": "dev_231", "timestamp": "2025-05-12 09:08:54", "location_lat": 3872859.131, "location_lon": 3872699.431, "location_name": "North Bridge", "vehicle_count": 41, "average_speed_kph": 51, "congestion_level": 2, "weather_condition": "Cloudy", "event_type": "Rush Hour"}
```

This data represents traffic events collected from various sensors across the city, including vehicle counts, speed data, congestion levels, and weather conditions. To store this data in Tinybird, you need to create a data source with a schema that reflects the structure of your traffic events data. Here's how you define a data source for traffic events in Tinybird:

```json
DESCRIPTION >
    Raw traffic events data collected from various sensors across the city

SCHEMA >
    `event_id` String `json:$.event_id`,
    `device_id` String `json:$.device_id`,
    `timestamp` DateTime `json:$.timestamp`,
    `location_lat` Float64 `json:$.location_lat`,
    `location_lon` Float64 `json:$.location_lon`,
    `location_name` String `json:$.location_name`,
    `vehicle_count` Int32 `json:$.vehicle_count`,
    `average_speed_kph` Float32 `json:$.average_speed_kph`,
    `congestion_level` Int8 `json:$.congestion_level`,
    `weather_condition` String `json:$.weather_condition`,
    `event_type` String `json:$.event_type`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(timestamp)"
ENGINE_SORTING_KEY "timestamp, location_name, device_id"
```

When designing this schema, it's important to select appropriate column types for efficient storage and query performance. The sorting key is chosen to optimize query performance for the most common queries, such as retrieving recent events for a specific location. To ingest data into this data source, Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) can be utilized:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=traffic_events&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "event_id": "ev_12345",
       "device_id": "sensor_789",
       "timestamp": "2023-09-15 08:30:00",
       "location_lat": 40.7128,
       "location_lon": -74.0060,
       "location_name": "Main Street & 5th Avenue",
       "vehicle_count": 45,
       "average_speed_kph": 18.5,
       "congestion_level": 8,
       "weather_condition": "Rainy",
       "event_type": "Regular"
     }'
```

The Events API allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request. This API is designed for low latency and real-time data ingestion. For event/streaming data, the Kafka connector is an excellent option for integrating with existing Kafka pipelines. For batch or file data, the [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) and S3 connector provide flexible options for bulk data ingestion. 

## Transforming data and publishing APIs

Tinybird facilitates data transformation through pipes, which can perform batch transformations, create real-time [Materialized views](https://www.tinybird.co/docs/forward/work-with-data/optimize/materialized-views?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV), and publish API endpoints. Let’s dive into how these capabilities are applied in our traffic analysis project. 

### Traffic Incident Detection

To detect traffic incidents, we create an endpoint that filters events based on congestion levels, speed, and optionally, location. Here's the complete SQL logic for our traffic incident detection pipe:

```sql
SELECT
    e.timestamp,
    e.location_name,
    e.device_id,
    e.vehicle_count,
    e.average_speed_kph,
    e.congestion_level,
    e.weather_condition,
    e.event_type
FROM traffic_events e
WHERE 
    e.timestamp >= now() - interval {{Int32(time_window_minutes, 60)}} minute
    AND e.congestion_level >= {{Int8(min_congestion_level, 7)}}
    AND e.average_speed_kph <= {{Float32(max_speed_kph, 20.0)}}
{% if defined(location_filter) %}
    AND e.location_name = {{String(location_filter, '')}}
{% end %}
ORDER BY e.timestamp DESC, e.congestion_level DESC
```

This query demonstrates the use of parameters (`time_window_minutes`, `min_congestion_level`, `max_speed_kph`, and `location_filter`) to make the API flexible and capable of handling different query scenarios. 

### Publishing APIs

Once the pipes are defined, Tinybird automatically generates API [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) that can be called with HTTP requests. Here’s how you can call the `traffic_incident_detection` endpoint:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/traffic_incident_detection.json?token=%24TB_ADMIN_TOKEN&time_window_minutes=30&min_congestion_level=8&max_speed_kph=15.0&location_filter=Downtown+Bridge&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV"
```

This example shows how to customize the API call to detect incidents in the last 30 minutes with specific conditions at the "Downtown Bridge" location. 

## Deploying to production

To deploy your project to Tinybird Cloud, use the `tb --cloud deploy` command. This command deploys your [data sources](https://www.tinybird.co/docs/forward/get-data-in/data-sources?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) and pipes, creating scalable, production-ready API endpoints. Tinybird manages these resources as code, enabling seamless integration with CI/CD pipelines for automated deployments. Securing your APIs is straightforward with token-based authentication. Here's how to call a deployed endpoint:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/current_traffic_conditions.json?token=%24TB_ADMIN_TOKEN&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV"
```


## Conclusion

Throughout this tutorial, you've learned how to ingest traffic events data into Tinybird, transform this data to analyze traffic patterns and incidents, and publish APIs for real-time traffic analysis. Tinybird's capabilities enable you to handle large volumes of data efficiently, making it an ideal platform for building real-time analytics APIs for smart city applications. [Sign up for Tinybird](https://cloud.tinybird.co/signup?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) to build and deploy your first real-time data APIs in a few minutes. Whether you're managing traffic in a smart city or tackling another data-intensive challenge, Tinybird provides the tools you need to deliver insights at scale, in real-time.