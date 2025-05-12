# Build a Real-Time Public Transportation Usage Analytics API with Tinybird

In the realm of urban planning and public transportation, having access to real-time data can significantly improve decision-making processes. For instance, understanding how passengers use different transportation modes, identifying the most popular routes, and analyzing hourly usage trends are crucial for optimizing routes, schedules, and vehicle allocations. This tutorial will guide you through creating a real-time API for analyzing public transportation usage patterns using Tinybird. Tinybird is a data analytics backend for software developers. You use Tinybird to build real-time analytics APIs without needing to set up or manage the underlying infrastructure. Tinybird offers a local-first development workflows, git-based deployments, resource definitions as code, and features for AI-native developers. By leveraging Tinybird's data sources and [pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes), you can ingest, transform, and serve large-scale data in real-time, making it an ideal solution for creating efficient and scalable transportation analytics APIs. ## Understanding the data

Imagine your data looks like this:

```json
{
  "event_id": "evt_384459",
  "timestamp": "2025-05-12 16:12:02",
  "vehicle_id": "veh_459",
  "vehicle_type": "ferry",
  "route_id": "route_59",
  "route_name": "Line 9",
  "passenger_count": 64,
  "stop_id": "stop_59",
  "location_lat": 40.459,
  "location_lng": -73.459
}
```

This JSON represents an event in public transportation usage, capturing details like vehicle type, route information, passenger count, and the event's geographical location. To store and analyze this data, you need to create a Tinybird datasource. Here's how you define a datasource for this data in Tinybird:

```json
DESCRIPTION >
    Data about public transportation usage events

SCHEMA >
    `event_id` String `json:$.event_id`,
    `timestamp` DateTime `json:$.timestamp`,
    `vehicle_id` String `json:$.vehicle_id`,
    `vehicle_type` String `json:$.vehicle_type`,
    `route_id` String `json:$.route_id`,
    `route_name` String `json:$.route_name`,
    `passenger_count` Int32 `json:$.passenger_count`,
    `stop_id` String `json:$.stop_id`,
    `location_lat` Float64 `json:$.location_lat`,
    `location_lng` Float64 `json:$.location_lng`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(timestamp)"
ENGINE_SORTING_KEY "timestamp, vehicle_type, route_id"
```

In the schema design, we chose types that best represent the nature of each field, ensuring efficient storage and query performance. Sorting keys are structured to optimize the query performance for common queries, like filtering by timestamp, vehicle type, and route id. For data ingestion, Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request. This feature is vital for real-time analytics, offering low latency and immediate data availability. Here's how to ingest an event:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=transportation_events" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "event_id": "evt_12345",
       "timestamp": "2023-06-15 08:30:00",
       "vehicle_id": "bus_789",
       "vehicle_type": "bus",
       "route_id": "route_42",
       "route_name": "Downtown Express",
       "passenger_count": 25,
       "stop_id": "stop_123",
       "location_lat": 40.7128,
       "location_lng": -74.0060
     }'
```

Other ingestion methods include using the Kafka connector for event or streaming data, which provides benefits like fault tolerance and scalability, and the [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api) or S3 connector for batch or file data, allowing for the ingestion of large datasets. ## Transforming data and publishing APIs

Tinybird transforms data and publishes APIs through *pipes*. Pipes allow for batch transformations (copies), real-time transformations ([Materialized views](https://www.tinybird.co/docs/forward/work-with-data/optimize/materialized-views)), and the creation of API endpoints. For example, to create an endpoint that returns the most popular routes based on total passenger count within a specified date range, your pipe might look like this:

```sql
DESCRIPTION >
    Get most popular routes by passenger count

NODE popular_routes_node
SQL >
    SELECT 
        route_id,
        route_name,
        vehicle_type,
        sum(passenger_count) as total_passengers,
        count() as trip_count
    FROM transportation_events
    WHERE 
        timestamp BETWEEN {{DateTime(start_date, '2023-01-01 00:00:00')}} AND {{DateTime(end_date, '2023-12-31 23:59:59')}}
        {% if defined(vehicle_type) %}
        AND vehicle_type = {{String(vehicle_type, 'bus')}}
        {% end %}
    GROUP BY route_id, route_name, vehicle_type
    ORDER BY total_passengers DESC
    LIMIT {{Int32(limit, 10)}}

TYPE endpoint
```

This SQL logic aggregates passenger counts and trip counts per route, filtered by an optional vehicle type and within a date range. The query parameters make the API flexible and capable of serving diverse client needs. To call this API, you might use:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/popular_routes.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&vehicle_type=bus&limit=10"
```


## Deploying to production

To deploy your project to Tinybird Cloud, use the following command:

```bash
tb --cloud deploy
```

This command creates production-ready, scalable API [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints). Tinybird's approach to managing resources as code simplifies integration with CI/CD pipelines, ensuring your data analytics backend is always up-to-date with your latest codebase. To secure your APIs, Tinybird uses token-based authentication. An example call to your deployed endpoint might look like:

```bash
curl -X GET "https://api.tinybird.co/v0/pipes/your_endpoint_name.json?token=your_token&param=value"
```


## Conclusion

Throughout this tutorial, we've built a real-time API for analyzing public transportation usage, leveraging Tinybird's [data sources](https://www.tinybird.co/docs/forward/get-data-in/data-sources) and pipes for efficient data ingestion, transformation, and API publication. This solution enables transportation authorities to make data-driven decisions to optimize their services. The technical benefits of using Tinybird for this use case include real-time data processing, scalability, and the ability to deploy and manage your analytics backend as code. [Sign up for Tinybird](https://cloud.tinybird.co/signup) to build and deploy your first real-time data APIs in a few minutes. With Tinybird, you can start for free, with no time limit and no credit card required, bringing your data analytics capabilities to the next level.