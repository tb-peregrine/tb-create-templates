# Build a Predictive Maintenance API for Industrial Equipment with Tinybird

Predictive maintenance is critical for managing industrial equipment, reducing downtime, and preventing costly repairs. By leveraging sensor data, organizations can monitor equipment health in real-time, identify potential issues before they escalate, and schedule maintenance more effectively. In this tutorial, you'll learn how to build a predictive maintenance API using Tinybird. Tinybird is a data analytics backend for software developers. You use Tinybird to build real-time analytics APIs without needing to set up or manage the underlying infrastructure. Tinybird offers a local-first development workflows, git-based deployments, resource definitions as code, and features for AI-native developers. You'll develop a solution that ingests sensor data from industrial equipment, such as temperature, vibration, and pressure readings, and provides [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints) to analyze equipment health, detect anomalies, and observe performance trends over time. By utilizing Tinybird's data sources and pipes, this project streamlines the process from data ingestion to API deployment, enabling real-time analytics at scale. ## Understanding the data

Imagine your data looks like this:

```json
{"equipment_id": "EQ-337", "timestamp": "2025-04-15 07:53:10", "temperature": 89.14961131735463, "vibration": 1.4109789000849657, "pressure": 107.59955579126243, "noise_level": 64.49944473907804, "status": "WARNING", "maintenance_due": 1}
{"equipment_id": "EQ-924", "timestamp": "2025-04-28 08:53:10", "temperature": 94.5371692323911, "vibration": 1.7034463297583737, "pressure": 113.7567648370184, "noise_level": 72.19595604627298, "status": "NORMAL", "maintenance_due": 0}
... ```

This data represents the sensor readings from industrial equipment, capturing metrics like temperature, vibration, and pressure at specific timestamps. Each record includes an `equipment_id`, indicating which piece of equipment the data pertains to, and a `status` field that may signal when maintenance is due. To store this data in Tinybird, create a data source with the following schema:

```json
DESCRIPTION >
    Raw data from industrial equipment sensors including temperature, vibration, pressure, and other metrics

SCHEMA >
    `equipment_id` String `json:$.equipment_id`,
    `timestamp` DateTime `json:$.timestamp`,
    `temperature` Float32 `json:$.temperature`,
    `vibration` Float32 `json:$.vibration`,
    `pressure` Float32 `json:$.pressure`,
    `noise_level` Float32 `json:$.noise_level`,
    `status` String `json:$.status`,
    `maintenance_due` UInt8 `json:$.maintenance_due`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(timestamp)"
ENGINE_SORTING_KEY "equipment_id, timestamp"
```

This schema outlines the types and names of each column and specifies the engine as `MergeTree`, ideal for time-series data. The sorting key improves query performance by organizing data by `equipment_id` and `timestamp`. For ingesting this data, Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request, providing low-latency, real-time data ingestion. Here's how you might send a single event:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=equipment_logs" \
  -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
  -d '{
    "equipment_id": "EQ-1001",
    "timestamp": "2023-06-15 14:30:00",
    "temperature": 85.3,
    "vibration": 0.45,
    "pressure": 102.7,
    "noise_level": 72.5,
    "status": "normal",
    "maintenance_due": 0
  }'
```

Additionally, Tinybird supports Kafka for streaming data and offers a [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api) and S3 connectors for batch ingestion, catering to various data integration needs. ## Transforming data and publishing APIs

Tinybird transforms raw data into actionable endpoints through [pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes), which can perform batch and real-time transformations. These transformations prepare the data for API endpoints, which can serve real-time analytics based on queries. ### Equipment Health Endpoint

The `equipment_health` endpoint aggregates sensor data to provide a health overview for each equipment. It calculates average readings and the ratio of abnormal readings, indicating potential issues. ```sql
DESCRIPTION >
    Endpoint that provides equipment health metrics and maintenance predictions

NODE equipment_health_node
SQL >
    SELECT 
        equipment_id,
        avg(temperature) as avg_temperature,
        avg(vibration) as avg_vibration,
        avg(pressure) as avg_pressure,
        avg(noise_level) as avg_noise_level,
        countIf(status != 'normal') / count() as abnormal_readings_ratio,
        max(maintenance_due) as maintenance_recommended
    FROM equipment_logs
    WHERE 
        equipment_id = {{String(equipment_id, '')}}
        AND timestamp BETWEEN {{DateTime(start_date, '2023-01-01 00:00:00')}} AND {{DateTime(end_date, '2023-12-31 23:59:59')}}
    GROUP BY equipment_id
    ORDER BY abnormal_readings_ratio DESC

TYPE endpoint
```

This SQL query demonstrates how to parameterize inputs like `equipment_id`, `start_date`, and `end_date`, making the API flexible for various queries. The calculation of `abnormal_readings_ratio` helps identify equipment that may require attention. Example API call:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/equipment_health.json?token=$TB_ADMIN_TOKEN&equipment_id=EQ-1001&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59"
```


### Anomalies and Trends Endpoints

Similarly, the `equipment_anomalies` and `equipment_trends` endpoints detect anomalies and analyze performance trends over time. These pipes use aggregate functions and statistical calculations to process the data, providing insights into equipment behavior and potential issues. ## Deploying to production

To deploy your project to Tinybird Cloud, use the command:

```bash
tb --cloud deploy
```

This command deploys your [data sources](https://www.tinybird.co/docs/forward/get-data-in/data-sources) and pipes, creating scalable, production-ready API endpoints. Tinybird manages these resources as code, facilitating integration with CI/CD pipelines and offering a robust solution for real-time analytics applications. Secure your APIs with token-based authentication, ensuring only authorized requests can access your data. Example curl command:

```bash
curl -X GET "https://api.yourdomain.com/v0/pipes/equipment_health.json?token=$YOUR_TOKEN&equipment_id=EQ-1001&..."
```


## Conclusion

Throughout this tutorial, you've learned how to build a predictive maintenance API using Tinybird, from ingesting sensor data to deploying real-time analytics endpoints. By leveraging Tinybird's capabilities, you can efficiently process large volumes of time-series data, transform it into meaningful insights, and expose it through scalable API endpoints. [Sign up for Tinybird](https://cloud.tinybird.co/signup) to build and deploy your first real-time data APIs in a few minutes. Whether you're monitoring industrial equipment or analyzing any other time-series data, Tinybird provides the tools and infrastructure to support your real-time analytics needs.