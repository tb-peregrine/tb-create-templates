# Build a Real-Time Delivery Fleet Tracking API with Tinybird

Tracking the real-time movements and status of a delivery fleet is a critical function for logistics and transportation companies. This tutorial walks you through creating a real-time API using Tinybird that allows for tracking vehicle locations, historical movements, and fleet summaries efficiently. Tinybird is a data analytics backend for software developers. You use Tinybird to build real-time analytics APIs without needing to set up or manage the underlying infrastructure. It offers a local-first development workflow, git-based deployments, resource definitions as code, and features for AI-native developers. By leveraging Tinybird's SQL engine and API endpoint capabilities, you can process and analyze fleet data on the fly, providing insights into your fleet's current and past locations and statuses. This guide will show you how to ingest data about delivery vehicle movements, transform this data, and publish it through API [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) using Tinybird's data sources and pipes. Whether you're managing a fleet of delivery trucks, drones, or any other types of vehicles, this tutorial will help you get up and running with a scalable and efficient tracking solution. 

## Understanding the data

Imagine your data looks like this:

```json
{"event_time": "2025-05-12 15:42:38", "vehicle_id": "VEH-65", "latitude": 37.656458965, "longitude": -87.656458965, "speed": 60, "status": "driving"}
{"event_time": "2025-05-11 22:22:02", "vehicle_id": "VEH-1", "latitude": 36.688582201, "longitude": -86.688582201, "speed": 66, "status": "driving"}
... ```

This sample data represents the real-time movements of a delivery fleet, capturing each vehicle's location, speed, and status at various timestamps. To store this data, you create Tinybird [data sources](https://www.tinybird.co/docs/forward/get-data-in/data-sources?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV). Here's how you define the `fleet_movements` datasource:

```json
DESCRIPTION >
    Tracks the real-time movements of the delivery fleet. SCHEMA >
    `event_time` DateTime `json:$.event_time`,
    `vehicle_id` String `json:$.vehicle_id`,
    `latitude` Float64 `json:$.latitude`,
    `longitude` Float64 `json:$.longitude`,
    `speed` Float32 `json:$.speed`,
    `status` String `json:$.status`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(event_time)"
ENGINE_SORTING_KEY "event_time, vehicle_id"
```

This schema captures the essential details about each vehicle movement, with an emphasis on optimizing query performance through sorting keys. To ingest this data into Tinybird, you can use the [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV), which allows streaming JSON/NDJSON events with a simple HTTP request. Here's an example of ingesting data:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=fleet_movements&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{"event_time":"2024-01-01 12:00:00","vehicle_id":"vehicle_123","latitude":37.7749,"longitude":-122.4194,"speed":60.5,"status":"en route"}'
```

This method is ideal for real-time data ingestion, ensuring low latency. For event or streaming data, consider using the Kafka connector for efficient data ingestion. For batch or file data, the [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) and S3 connector are valuable tools for ingesting data in bulk. 

## Transforming data and publishing APIs

Tinybird [pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) perform batch and real-time transformations and create API endpoints. Here's how to use pipes to transform the `fleet_movements` data and publish useful APIs for tracking the delivery fleet. 

### Current Location Endpoint

The `current_location` pipe returns the most recent location of a specific vehicle:

```sql
DESCRIPTION >
    Returns the current location of a specific vehicle. NODE current_location_node
SQL >
    SELECT
        vehicle_id,
        latitude,
        longitude,
        event_time,
        status
    FROM fleet_movements
    WHERE vehicle_id = {{String(vehicle_id, 'vehicle_123')}}
    ORDER BY event_time DESC
    LIMIT 1

TYPE endpoint
```

This query retrieves the latest location and status for a given vehicle, using `ORDER BY` to ensure the most recent event is selected. 

### Vehicle History Endpoint

The `vehicle_history` pipe provides historical movements for a vehicle within a specified time range:

```sql
DESCRIPTION >
    Returns the historical movements of a specific vehicle within a time range. NODE vehicle_history_node
SQL >
    SELECT
        event_time,
        latitude,
        longitude,
        speed,
        status
    FROM fleet_movements
    WHERE
        vehicle_id = {{String(vehicle_id, 'vehicle_123')}}
        AND event_time BETWEEN {{DateTime(start_time, '2024-01-01 00:00:00')}} AND {{DateTime(end_time, '2024-01-01 23:59:59')}}
    ORDER BY event_time

TYPE endpoint
```

This query filters events by vehicle ID and time range, providing a detailed movement history. 

### Fleet Summary Endpoint

The `fleet_summary` pipe aggregates data to offer a snapshot of the entire fleet's status:

```sql
DESCRIPTION >
    Provides a summary of the entire fleet's current status. NODE fleet_summary_node
SQL >
    SELECT
        vehicle_id,
        argMax(latitude, event_time) AS current_latitude,
        argMax(longitude, event_time) AS current_longitude,
        max(event_time) AS last_event_time,
        argMax(status, event_time) AS current_status
    FROM fleet_movements
    GROUP BY vehicle_id

TYPE endpoint
```

This SQL uses aggregation functions to compute the last known location and status for each vehicle in the fleet. 

## Deploying to production

Deploy your project to Tinybird Cloud with the `tb --cloud deploy` command. This command makes your API endpoints production-ready and scalable. Tinybird manages resources as code, facilitating integration with CI/CD pipelines and ensuring secure, token-based authentication for your APIs. Example API call:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/current_location.json?token=%24TB_ADMIN_TOKEN&vehicle_id=vehicle_123&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV"
```


## Conclusion

In this tutorial, you've learned how to create a real-time delivery fleet tracking API using Tinybird. You've seen how to ingest and transform fleet movement data, and how to publish and deploy scalable API endpoints for tracking vehicle locations, histories, and fleet summaries. Tinybird simplifies building and scaling real-time analytics APIs, letting you focus on delivering value without worrying about the underlying infrastructure. [Sign up for Tinybird](https://cloud.tinybird.co/signup?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) to build and deploy your first real-time data APIs in a few minutes. Start for free, with no time limit and no credit card required, and get your delivery fleet tracking solution up and running today.