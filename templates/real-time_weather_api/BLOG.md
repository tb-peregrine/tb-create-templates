# Build a Real-time Weather API with Tinybird

Weather data plays a crucial role in a myriad of applications, from forecasting and agricultural planning to logistics and travel. Handling this data in real-time, however, poses a significant technical challenge. This tutorial will guide you through creating a real-time API for processing and analyzing weather measurement data from various stations around the world using Tinybird. Tinybird is a data analytics backend for software developers. You use Tinybird to build real-time analytics APIs without needing to set up or manage the underlying infrastructure. Tinybird offers a local-first development workflows, git-based deployments, resource definitions as code, and features for AI-native developers. It simplifies the process of ingesting, transforming, and querying large volumes of data in real time, making it an ideal solution for our weather data API. In this tutorial, we'll specifically focus on how to ingest weather data, create data sources and [pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) for transforming this data, and publish APIs that provide access to current weather conditions, historical weather statistics, and weather anomalies detection. 

## Understanding the data

Imagine your data looks like this:

```json
{"station_id": "STATION_138", "location": "Tokyo", "latitude": 2845974126, "longitude": 2845974216, "temperature": 2845974156, "humidity": 77, "pressure": 1018, "wind_speed": 38, "wind_direction": 258, "precipitation": 38, "timestamp": "2025-05-12 05:11:54", "country": "China", "region": "Northeast"}
```

This data represents measurements from various weather stations, including temperature, humidity, wind speed, and more. Each record is associated with a specific station and timestamp, allowing us to track weather conditions over time. To store this data in Tinybird, we create a data source with a schema that mirrors the structure of our JSON data. Here's how a `.datasource` file might look:

```json
DESCRIPTION >
    Raw weather measurements from various stations

SCHEMA >
    `station_id` String `json:$.station_id`,
    `location` String `json:$.location`,
    `latitude` Float64 `json:$.latitude`,
    `longitude` Float64 `json:$.longitude`,
    `temperature` Float64 `json:$.temperature`,
    `humidity` Float64 `json:$.humidity`,
    `pressure` Float64 `json:$.pressure`,
    `wind_speed` Float64 `json:$.wind_speed`,
    `wind_direction` Float64 `json:$.wind_direction`,
    `precipitation` Float64 `json:$.precipitation`,
    `timestamp` DateTime `json:$.timestamp`,
    `country` String `json:$.country`,
    `region` String `json:$.region`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(timestamp)"
ENGINE_SORTING_KEY "timestamp, station_id, region, country"
```

This schema defines each column's type and maps it to the corresponding JSON path in the ingested data. The `ENGINE` settings optimize query performance by partitioning and sorting the data based on timestamp, station_id, region, and country. To ingest data, Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request. This feature enables low-latency data ingestion in real time. Here’s how you might send a weather measurement to Tinybird:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=weather_measurements&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV" \
  -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
  -d '{...}'
```

For streaming data like weather measurements, the Kafka connector is also a valuable tool, providing a robust solution for handling high-volume data streams. For batch or file-based data, the [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) and S3 connectors offer efficient ways to ingest data into Tinybird. 

## Transforming data and publishing APIs

With our data ingested into Tinybird, the next step is to transform this data and publish APIs. Tinybird's pipes serve three main purposes: batch transformations, real-time transformations ([Materialized views](https://www.tinybird.co/docs/forward/work-with-data/optimize/materialized-views?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV)), and creating API endpoints. 

### Materialized Views

While our weather data API doesn't require materialized views for its basic functionality, they're essential for optimizing performance in more complex scenarios. Materialized views pre-compute and store query results, significantly speeding up data retrieval for frequently executed queries. 

### API [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV)

Let's now define our API endpoints using pipes. For example, to create an endpoint that provides current weather data, we define the following pipe:

```sql
DESCRIPTION >
    Get current weather data by location or region

NODE get_current_weather
SQL >
    SELECT
        station_id,
        location,
        latitude,
        longitude,
        temperature,
        humidity,
        pressure,
        wind_speed,
        wind_direction,
        precipitation,
        timestamp
    FROM weather_measurements
    WHERE 1=1
    AND location = {{String(location, '')}}
    ORDER BY timestamp DESC
    LIMIT {{Int32(limit, 100)}}

TYPE endpoint
```

This pipe fetches the most recent weather data based on location, with query parameters allowing for flexible filtering. The SQL logic is straightforward, selecting relevant fields from our `weather_measurements` data source and applying filters as needed. Here's how you might call this API:

```bash
curl -X GET "https://api.tinybird.co/v0/pipes/current_weather.json?token=%24TB_ADMIN_TOKEN&location=London&limit=10&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV"
```

The API call returns the latest 10 weather records for London, demonstrating the API's flexibility and real-time capabilities. 

## Deploying to production

Deploying your project to the Tinybird Cloud is as simple as running `tb --cloud deploy` from your terminal. This command deploys your [data sources](https://www.tinybird.co/docs/forward/get-data-in/data-sources?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV), pipes, and all associated resources, creating production-ready, scalable API endpoints. Tinybird manages resources as code, allowing you to integrate seamlessly with CI/CD pipelines for automated deployments. Additionally, token-based authentication secures your APIs, ensuring only authorized users can access them. Here's an example of how to call your deployed endpoint:

```bash
curl -X GET "https://api.tinybird.co/v0/pipes/current_weather.json?token=%24PRODUCTION_TOKEN&location=New&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV York"
```


## Conclusion

Throughout this tutorial, you've learned how to ingest weather measurement data into Tinybird, transform this data through pipes, and publish real-time APIs for accessing weather information. Tinybird's capabilities enable developers to build and deploy scalable, real-time data APIs efficiently. [Sign up for Tinybird](https://cloud.tinybird.co/signup?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) to build and deploy your first real-time data APIs in a few minutes. Tinybird is free to start, with no time limit and no credit card required, offering an excellent opportunity to explore its powerful features for your data engineering projects.