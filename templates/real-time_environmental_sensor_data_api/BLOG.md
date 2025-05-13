# Build a Real-Time Environmental Sensor Monitoring API with Tinybird

Monitoring environmental conditions in real-time can be crucial for a wide range of applications, from ensuring the optimal storage conditions in warehouses to maintaining comfortable and healthy indoor air quality in homes and offices. In this tutorial, you'll learn how to build a real-time API for monitoring environmental sensor data using Tinybird. This API will enable you to collect readings from various sensors, including temperature, humidity, and air quality, and provide [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) for querying current conditions, analyzing trends, and monitoring sensor health. Tinybird is a data analytics backend for software developers. You use Tinybird to build real-time analytics APIs without needing to set up or manage the underlying infrastructure. Tinybird offers a local-first development workflows, git-based deployments, resource definitions as code, and features for AI-native developers. By leveraging Tinybird's data sources and pipes, you can easily ingest, transform, and serve large volumes of sensor data with minimal latency, making it ideal for real-time environmental monitoring applications. 

## Understanding the data

Imagine your data looks like this:

```json
{"sensor_id": "sensor_29", "location": "Office", "reading_type": "pressure", "reading_value": 1597364956, "unit": "hPa", "timestamp": "2025-05-12 16:42:03", "battery_level": 0.1}
{"sensor_id": "sensor_39", "location": "Office", "reading_type": "pressure", "reading_value": 645797676, "unit": "hPa", "timestamp": "2025-05-12 04:56:53", "battery_level": 0.2}
... ```

This data represents readings from environmental sensors placed in various locations. Each reading includes the sensor ID, location, type of reading (e.g., temperature, humidity), the reading value, unit, timestamp, and the sensor's battery level. To store this data in Tinybird, you first need to create a data source with an appropriate schema. Here's how you define the `sensor_readings` data source:

```json
DESCRIPTION >
    Raw sensor data readings from environmental sensors including temperature, humidity, air quality, and location

SCHEMA >
    `sensor_id` String `json:$.sensor_id`,
    `location` String `json:$.location`,
    `reading_type` String `json:$.reading_type`,
    `reading_value` Float64 `json:$.reading_value`,
    `unit` String `json:$.unit`,
    `timestamp` DateTime64(3) `json:$.timestamp`,
    `battery_level` Float32 `json:$.battery_level`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(timestamp)"
ENGINE_SORTING_KEY "sensor_id, timestamp, reading_type"
```

In this schema, the sorting key is chosen to optimize query performance for common queries filtering by `sensor_id`, `timestamp`, and `reading_type`. For data ingestion, Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request. This is particularly useful for real-time monitoring applications. Here's a sample ingestion command:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=sensor_readings&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "sensor_id": "sensor-001",
       "location": "building-a",
       "reading_type": "temperature",
       "reading_value": 22.5,
       "unit": "celsius",
       "timestamp": "2023-04-15 14:30:00.000",
       "battery_level": 85.2
     }'
```

Other ingestion methods include the Kafka connector for event/streaming data, which benefits from Kafka's reliability and scalability, and the [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) and S3 connector for batch/file data, enabling efficient bulk uploads. 

## Transforming data and publishing APIs

Tinybird's pipes are used to transform data and publish APIs. Pipes can perform batch transformations (similar to copies), real-time transformations (similar to [Materialized views](https://www.tinybird.co/docs/forward/work-with-data/optimize/materialized-views?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV)), and create API endpoints. 

### Endpoint: current_sensor_readings

Let's start with the `current_sensor_readings` endpoint, which fetches the most recent readings for each sensor and reading type:

```sql
DESCRIPTION >
    Fetches the most recent readings for each sensor and reading type

NODE current_sensor_readings_node
SQL >
    SELECT 
        sensor_id,
        location,
        reading_type,
        reading_value,
        unit,
        timestamp,
        battery_level
    FROM sensor_readings
    WHERE 
        sensor_id = '{{String(sensor_id, '')}}'
        AND location = '{{String(location, '')}}'
        AND reading_type = '{{String(reading_type, '')}}'
        AND timestamp >= now() - interval '{{Int(time_window_hours, 24)}}' hour
    ORDER BY sensor_id, reading_type, timestamp DESC
    LIMIT '{{Int(limit, 1000)}}'

TYPE endpoint
```

This SQL query demonstrates how to use query parameters to make the API flexible, allowing users to filter by `sensor_id`, `location`, `reading_type`, and a time window. Example API call:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/[pipes?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV](https://www.tinybird.co/docs/forward/work-with-data/pipes?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV)/current_sensor_readings.json?token=$TB_ADMIN_TOKEN&sensor_id=sensor-001&location=building-a&reading_type=temperature&time_window_hours=24&limit=1000"
```


## Deploying to production

Deploying your project to Tinybird Cloud is straightforward with the `tb --cloud deploy` command. This command creates production-ready, scalable API endpoints. Tinybird manages resources as code, facilitating integration with CI/CD pipelines and ensuring your data pipelines are version-controlled and easily deployable across environments. Secure your APIs with token-based authentication to control access effectively. Example command to call the deployed endpoint:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/location_overview.json?token=%24TB_ADMIN_TOKEN&location=building-a&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV"
```


## Conclusion

In this tutorial, you've learned how to build a real-time API for environmental sensor monitoring using Tinybird. By defining [data sources](https://www.tinybird.co/docs/forward/get-data-in/data-sources?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV), transforming data with pipes, and deploying scalable endpoints, you can efficiently handle large volumes of sensor data with minimal latency. Tinybird's platform simplifies the process of ingesting, transforming, and querying real-time data, enabling you to focus on building applications that leverage timely and relevant environmental data. [Sign up for Tinybird](https://cloud.tinybird.co/signup?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) to build and deploy your first real-time data APIs in a few minutes. Tinybird is free to start, with no time limit and no credit card required, allowing you to explore its features and build powerful real-time analytics without upfront investment.