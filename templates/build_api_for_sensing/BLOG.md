# Build a Real-Time IoT Sensor Data Analytics API with Tinybird

In the realm of Internet of Things (IoT), efficiently managing and analyzing sensor data in real-time is crucial for applications ranging from environmental monitoring to smart homes. This tutorial will guide you through creating an API that ingests, processes, and analyzes data from various IoT sensors. By leveraging Tinybird, a data analytics backend for software developers, you'll learn how to monitor sensor readings, detect anomalies, and generate statistics over specified time periods without worrying about the underlying infrastructure. Tinybird facilitates building real-time analytics APIs by providing data sources and [pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV), which we'll utilize to create our solution. 

## Understanding the data

Imagine your data looks like this:

```json
{"device_id": "device_51", "sensor_type": "humidity", "reading": 300519135100, "reading_unit": "%", "battery_level": 300519135100, "location": "bedroom", "timestamp": "2025-05-12 09:13:07"}
{"device_id": "device_38", "sensor_type": "light", "reading": 278437973800, "reading_unit": "lux", "battery_level": 278437973800, "location": "bathroom", "timestamp": "2025-05-12 01:46:40"}
... ```

This data represents readings from various IoT sensors, including device identifier, sensor type (e.g., temperature, humidity), reading values with units, battery levels, and location information. To store this data in Tinybird, we start by creating a data source with a schema tailored to our needs. Here's how you define the `sensor_data` data source:

```json
DESCRIPTION >
    Raw IoT sensor data ingested from devices

SCHEMA >
    `device_id` String `json:$.device_id`,
    `sensor_type` String `json:$.sensor_type`,
    `reading` Float64 `json:$.reading`,
    `reading_unit` String `json:$.reading_unit`,
    `battery_level` Float32 `json:$.battery_level`,
    `location` String `json:$.location`,
    `timestamp` DateTime `json:$.timestamp`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(timestamp)"
ENGINE_SORTING_KEY "device_id, sensor_type, timestamp"
```

The schema is designed to optimize query performance, with sorting keys on `device_id`, `sensor_type`, and `timestamp` to facilitate fast data retrieval. For data ingestion, Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request. This method is ideal for real-time data streaming, ensuring low latency. Here is an example of how to ingest sensor data using the Events API:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=sensor_data&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
           "device_id": "device_123",
           "sensor_type": "temperature",
           "reading": 25.5,
           "reading_unit": "celsius",
           "battery_level": 0.87,
           "location": "building_a",
           "timestamp": "2023-07-12 14:30:00"
         }'
```

Additionally, Tinybird provides other ingestion methods such as the Kafka connector for streaming data and the [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) or S3 connector for batch or file data. Here is how you can ingest data using the Tinybird CLI:

```bash
tb datasource append sensor_data.datasource 'path/to/your/data.ndjson'
```


## Transforming data and publishing APIs

Tinybird's pipes enable data transformation and API publication. Here, we'll focus on creating API [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) for three main functionalities: retrieving the latest sensor readings, detecting anomalies, and generating aggregated sensor statistics. 

### Latest Readings Endpoint

The `latest_readings` pipe provides the most recent readings from IoT sensors. It supports optional filtering by device ID, sensor type, or location. Here's the full SQL query for this endpoint:

```sql
SELECT 
    device_id,
    sensor_type,
    reading,
    reading_unit,
    battery_level,
    location,
    timestamp
FROM sensor_data
WHERE 1=1
{% if defined(device_id) %}
    AND device_id = {{String(device_id, '')}}
{% end %}
{% if defined(sensor_type) %}
    AND sensor_type = {{String(sensor_type, '')}}
{% end %}
{% if defined(location) %}
    AND location = {{String(location, '')}}
{% end %}
{% if defined(hours_back) %}
    AND timestamp > now() - interval {{Int(hours_back, 24)}} hour
{% else %}
    AND timestamp > now() - interval 24 hour
{% end %}
ORDER BY timestamp DESC
LIMIT {{Int(limit, 100)}}
```

This SQL logic demonstrates how to apply dynamic filtering based on query parameters, making the API flexible for various use cases. 

### Anomaly Detection Endpoint

The `anomaly_detection` pipe identifies abnormal sensor readings. It calculates the deviation from historical averages using standard deviation as a threshold. Here's the SQL for anomaly detection:

```sql
WITH stats AS (
    SELECT 
        device_id,
        sensor_type,
        avg(reading) as avg_reading,
        stddevSamp(reading) as stddev_reading
    FROM sensor_data
    WHERE timestamp > now() - interval {{Int(baseline_days, 30)}} day
    GROUP BY device_id, sensor_type
)

SELECT 
    s.device_id,
    s.sensor_type,
    s.reading,
    s.reading_unit,
    s.timestamp,
    s.location,
    s.battery_level,
    stats.avg_reading,
    stats.stddev_reading,
    abs(s.reading - stats.avg_reading) / stats.stddev_reading as deviation_score
FROM sensor_data s
JOIN stats ON s.device_id = stats.device_id AND s.sensor_type = stats.sensor_type
WHERE s.timestamp > now() - interval {{Int(hours_back, 24)}} hour
AND stats.stddev_reading > 0
AND abs(s.reading - stats.avg_reading) / stats.stddev_reading > {{Float32(threshold, 3.0)}}
ORDER BY deviation_score DESC
LIMIT {{Int(limit, 100)}}
```

This query calculates the deviation score for each sensor reading and filters results based on a specified threshold, helping identify significant anomalies. 

### Sensor Stats Endpoint

The `sensor_stats` pipe aggregates statistics for sensor readings over a specified time period, providing insights into sensor performance and trends:

```sql
SELECT 
    device_id,
    sensor_type,
    min(reading) as min_reading,
    max(reading) as max_reading,
    avg(reading) as avg_reading,
    min(battery_level) as min_battery,
    max(battery_level) as max_battery,
    avg(battery_level) as avg_battery,
    count() as reading_count
FROM sensor_data
WHERE 1=1
{% if defined(device_id) %}
    AND device_id = {{String(device_id, '')}}
{% end %}
{% if defined(sensor_type) %}
    AND sensor_type = {{String(sensor_type, '')}}
{% end %}
{% if defined(location) %}
    AND location = {{String(location, '')}}
{% end %}
{% if defined(start_date) %}
    AND timestamp >= {{DateTime(start_date, '2023-01-01 00:00:00')}}
{% else %}
    AND timestamp >= now() - interval 7 day
{% end %}
{% if defined(end_date) %}
    AND timestamp <= {{DateTime(end_date, '2023-12-31 23:59:59')}}
{% else %}
    AND timestamp <= now()
{% end %}
GROUP BY device_id, sensor_type
ORDER BY device_id, sensor_type
```

This query demonstrates how to use aggregation functions to compute statistics, offering a comprehensive view of sensor data over time. 

## Deploying to production

To deploy these resources to Tinybird Cloud, use the Tinybird CLI with the following command:

```bash
tb --cloud deploy
```

This command deploys your [data sources](https://www.tinybird.co/docs/forward/get-data-in/data-sources?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) and pipes, creating production-ready, scalable API endpoints. Tinybird treats your project as code, enabling integration with CI/CD pipelines and facilitating a smooth deployment process. Additionally, Tinybird provides token-based authentication to secure your APIs. Here's an example of calling the deployed `latest_readings` endpoint:

```bash
curl -X GET "https://api.tinybird.co/v0/pipes/latest_readings.json?token=%24TB_ADMIN_TOKEN&device_id=device_123&hours_back=12&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV"
```


## Conclusion

Through this tutorial, you've learned how to ingest, transform, and analyze IoT sensor data in real-time using Tinybird. We've created a scalable solution that monitors sensor readings, detects anomalies, and generates aggregated statistics. By utilizing Tinybird's data sources and pipes, you can efficiently build and manage real-time analytics APIs, focusing on developing your application without the overhead of managing infrastructure. [Sign up for Tinybird](https://cloud.tinybird.co/signup?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) to build and deploy your first real-time data APIs in a few minutes.