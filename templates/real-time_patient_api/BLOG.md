# Build a Real-Time Patient Monitoring API with Tinybird

In the domain of healthcare, timely access to patient data can be a matter of life and death. Healthcare providers often rely on continuous monitoring of vital signs to make informed decisions about patient care. This tutorial will guide you through building a real-time API for monitoring and analyzing patient vital signs, such as heart rate, blood pressure, temperature, and oxygen levels. Leveraging Tinybird, you'll learn how to ingest, transform, and serve this critical data through fast, scalable APIs. Tinybird is a data analytics backend for software developers. You use Tinybird to build real-time analytics APIs without needing to set up or manage the underlying infrastructure. Tinybird offers a local-first development workflow, git-based deployments, resource definitions as code, and features for AI-native developers. By utilizing Tinybird's data sources and [pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV), you can efficiently process and analyze streaming data, enabling real-time monitoring and analysis of patient vitals. Let's dive into how to structure your data, create and transform data sources, and publish APIs that will help healthcare providers monitor patient status, identify critical cases, and analyze historical trends in real-time. 

## Understanding the data

Imagine your data looks like this:

```json
{"patient_id": "P9781", "device_id": "DEV781", "timestamp": "2025-05-12 11:46:29", "heart_rate": 81, "systolic_bp": 131, "diastolic_bp": 81, "temperature": 38.1, "oxygen_level": 91, "department": "Cardiology", "is_critical": 1}
{"patient_id": "P1865", "device_id": "DEV965", "timestamp": "2025-05-12 14:28:25", "heart_rate": 85, "systolic_bp": 135, "diastolic_bp": 85, "temperature": 38.5, "oxygen_level": 95, "department": "ICU", "is_critical": 1}
... ```

This NDJSON represents vital signs measurements from patient monitoring devices. Each record includes a patient identifier, device information, a timestamp, and measurements like heart rate, blood pressure, and temperature. To store this data in Tinybird, you create a data source. Here's how the `patient_vitals.datasource` file might look:

```json
DESCRIPTION >
    Real-time patient vital signs measurements including heart rate, blood pressure, temperature, and oxygen levels

SCHEMA >
    `patient_id` String `json:$.patient_id`,
    `device_id` String `json:$.device_id`,
    `timestamp` DateTime `json:$.timestamp`,
    `heart_rate` Float32 `json:$.heart_rate`,
    `systolic_bp` Float32 `json:$.systolic_bp`,
    `diastolic_bp` Float32 `json:$.diastolic_bp`,
    `temperature` Float32 `json:$.temperature`,
    `oxygen_level` Float32 `json:$.oxygen_level`,
    `department` String `json:$.department`,
    `is_critical` UInt8 `json:$.is_critical`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(timestamp)"
ENGINE_SORTING_KEY "patient_id, timestamp"
```

This schema design and column type selection are optimized for query performance, especially with the sorting key set to `patient_id, timestamp`, enabling efficient time-series queries. Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request. This real-time nature and low latency are crucial for patient monitoring systems. Here's how you might ingest sample data:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=patient_vitals&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV" \
  -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
  -d '{
    "patient_id": "P123456",
    "device_id": "DEV0012",
    "timestamp": "2023-11-15 14:30:00",
    "heart_rate": 78.5,
    "systolic_bp": 120.0,
    "diastolic_bp": 80.0,
    "temperature": 37.2,
    "oxygen_level": 98.0,
    "department": "Cardiology",
    "is_critical": 0
  }'
```

For event/streaming data, the Kafka connector is beneficial for integrating with existing Kafka streams. For batch/file data, the [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) and S3 connectors provide additional ingestion methods. You can use the Tinybird CLI for these operations, offering command-line flexibility for managing data workflows. 

## Transforming data and publishing APIs

Transformations in Tinybird are handled through pipes which can perform batch transformations, real-time transformations via [Materialized views](https://www.tinybird.co/docs/forward/work-with-data/optimize/materialized-views?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV), and create API endpoints. Let's start with the `patient_vitals_history.pipe`:

```sql
DESCRIPTION >
    Returns historical vital signs for a patient over a specified time range

NODE patient_vitals_history_node
SQL >
    %
    SELECT 
        patient_id,
        timestamp,
        heart_rate,
        systolic_bp,
        diastolic_bp,
        temperature,
        oxygen_level,
        is_critical
    FROM patient_vitals
    WHERE 
        patient_id = {{String(patient_id, '')}}
        {% if defined(start_time) %}
        AND timestamp >= {{DateTime(start_time)}}
        {% else %}
        AND timestamp >= now() - interval 24 hour
        {% end %}
        {% if defined(end_time) %}
        AND timestamp <= {{DateTime(end_time)}}
        {% else %}
        AND timestamp <= now()
        {% end %}
    ORDER BY timestamp DESC

TYPE endpoint
```

This pipe enables healthcare providers to analyze trends in a patient's condition over time. The SQL logic filters vital signs by patient_id and an optional time range. The query parameters make the API flexible, allowing for custom time ranges. Here's an example API call for retrieving a patient's historical vital signs:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/patient_vitals_history.json?patient_id=P123456&start_time=2023-11-14+14%3A00%3A00&token=%24TB_ADMIN_TOKEN&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV"
```

Further, the `critical_patients.pipe` and `patient_current_status.pipe` [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) follow similar patterns, tailored to their specific use cases. These endpoints facilitate quick access to critical patient information and real-time status updates. 

## Deploying to production

Deploying your project to Tinybird Cloud is straightforward with the `tb --cloud deploy` command. This command scales your API endpoints for production, ensuring they're ready for real-time data demands. Tinybird manages resources as code, integrating seamlessly with CI/CD pipelines for automated deployments. This approach supports best practices in software development and operations. Securing your APIs is critical, especially with sensitive healthcare data. Tinybird uses token-based authentication to secure access to your endpoints. Here's how you might call a deployed endpoint:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/patient_current_status.json?patient_id=P123456&token=%24TB_PRODUCTION_TOKEN&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV"
```


## Conclusion

Throughout this tutorial, you've built a real-time patient monitoring API capable of ingesting, processing, and serving vital signs data. Using Tinybird, you've created a scalable solution that enables healthcare providers to monitor patient status in real-time, identify critical cases, and analyze historical trends. The technical benefits of using Tinybird for this use case include efficient data ingestion, real-time processing, and the ability to publish scalable APIs rapidly. This infrastructure supports the critical needs of modern healthcare systems, ensuring timely access to patient data. [Sign up for Tinybird](https://cloud.tinybird.co/signup?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) to build and deploy your first real-time data APIs in a few minutes. Tinybird is free to start, with no time limit and no credit card required.