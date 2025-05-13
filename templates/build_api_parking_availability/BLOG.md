# Build a Real-Time Parking Space Tracker Using Tinybird

Parking space availability is a common urban challenge, affecting drivers in cities worldwide. Finding a quick and efficient way to monitor which parking lots have free spaces can save time and reduce traffic congestion. This tutorial will guide you through building an API that tracks and queries parking space availability in real-time across multiple lots using Tinybird. Tinybird is a data analytics backend for software developers. You use Tinybird to build real-time analytics APIs without needing to set up or manage the underlying infrastructure. Tinybird offers a local-first development workflow, git-based deployments, resource definitions as code, and features for AI-native developers. By leveraging Tinybird's data sources and [pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV), we'll create a system capable of handling real-time data ingestion, transformation, and API endpoint publication, enabling users to access up-to-the-minute parking space information. 

## Understanding the data

Imagine your data looks like this:

```json
{"parking_lot_id": "lot_9", "location": "Sports Arena", "total_spaces": 328, "available_spaces": 78, "occupied_spaces": 78, "timestamp": "2025-05-12 07:00:59"}
{"parking_lot_id": "lot_6", "location": "University", "total_spaces": 425, "available_spaces": 25, "occupied_spaces": 225, "timestamp": "2025-05-11 23:19:22"}
```

This sample data represents parking availability information, including lot identification, location, total number of spaces, and real-time metrics on space availability. To store this data, we create a Tinybird data source with the following schema:

```json
DESCRIPTION >
    Data source for parking space availability information

SCHEMA >
    `parking_lot_id` String `json:$.parking_lot_id`,
    `location` String `json:$.location`,
    `total_spaces` Int32 `json:$.total_spaces`,
    `available_spaces` Int32 `json:$.available_spaces`,
    `occupied_spaces` Int32 `json:$.occupied_spaces`,
    `timestamp` DateTime `json:$.timestamp`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(timestamp)"
ENGINE_SORTING_KEY "parking_lot_id, timestamp"
```

This schema highlights the importance of choosing appropriate column types and sorting keys. Sorting by `parking_lot_id` and `timestamp` improves query performance, especially for time-range queries and filtering by specific lots. 

### Data ingestion

Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request. This feature's real-time nature and low latency are ideal for tracking parking space availability as it changes. Here's how you can ingest data into the `parking_spaces` data source:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=parking_spaces&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{"parking_lot_id":"A123","location":"Downtown","total_spaces":200,"available_spaces":45,"occupied_spaces":155,"timestamp":"2023-09-15 08:30:00"}'
```

Other relevant ingestion methods include:

- **For event/streaming data:** The Kafka connector is beneficial for seamlessly integrating with existing Kafka pipelines. - **For batch/file data:** The [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) and S3 connector facilitate bulk ingestion from files or cloud storage. 

## Transforming data and publishing APIs

Tinybird pipes are used for batch transformations (copies), real-time transformations ([Materialized views](https://www.tinybird.co/docs/forward/work-with-data/optimize/materialized-views?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV)), and creating API endpoints. Let's dive into how we can transform our parking data and publish it as API endpoints. 

### Current availability endpoint

The `current_availability` pipe fetches the latest parking space availability across all lots or filtered by specific criteria. ```sql
DESCRIPTION >
    Endpoint to get current availability of parking spaces

NODE current_availability_node
SQL >
    SELECT 
        parking_lot_id,
        location,
        total_spaces,
        available_spaces,
        occupied_spaces,
        timestamp
    FROM parking_spaces
    WHERE 
        {% if defined(parking_lot_id) %}
        parking_lot_id = {{String(parking_lot_id, '')}}
        {% else %}
        1=1
        {% end %}
        {% if defined(location) %}
        AND location = {{String(location, '')}}
        {% end %}
    ORDER BY timestamp DESC
    LIMIT {{Int32(limit, 100)}}

TYPE endpoint
```

This SQL logic filters records based on `parking_lot_id` and `location`, if specified. It uses template parameters to make the API flexible and capable of serving different user requests. Here's how you can call this endpoint:

```bash
# Get availability for all parking lots
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/current_availability.json?token=%24TB_ADMIN_TOKEN&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV"
```


#

## Parking lot stats and availability by time

Similarly, the `parking_lot_stats` and `availability_by_time` [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) provide summary statistics and analyze availability patterns over time. They leverage grouping and aggregation functions to deliver insightful data about parking trends. 

## Deploying to production

Deploy your project to Tinybird Cloud using the `tb --cloud deploy` command. This step creates production-ready, scalable API endpoints, ensuring your parking space tracker can handle real-time data and user requests efficiently. Tinybird manages resources as code, facilitating integration with CI/CD pipelines and token-based authentication to secure your APIs. Example curl command to call a deployed endpoint:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/current_availability.json?token=%24DEPLOYED_ENDPOINT_TOKEN&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV"
```


## Conclusion

Throughout this tutorial, we've built a real-time API for tracking parking space availability using Tinybird. We covered data ingestion, transforming data with pipes, and publishing scalable API endpoints. Tinybird's capabilities enable developers to implement real-time data analytics solutions efficiently. [Sign up for Tinybird](https://cloud.tinybird.co/signup?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) to build and deploy your first real-time data APIs in a few minutes. Tinybird is free to start, with no time limit and no credit card required.