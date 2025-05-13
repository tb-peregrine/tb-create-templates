# Build a Real-Time API for Healthcare Monitoring with Tinybird

Healthcare technology has made leaps and bounds in enabling real-time monitoring and data analysis, significantly improving patient care and outcomes. A critical part of this advancement is the ability to instantaneously access and analyze patient vital signs data. This tutorial will walk you through creating a real-time API for a healthcare monitoring system using Tinybird. With this API, medical professionals can monitor patient vitals like heart rate, blood pressure, oxygen saturation, and body temperature in real-time. Tinybird is a data analytics backend for software developers. You use Tinybird to build real-time analytics APIs without needing to set up or manage the underlying infrastructure. Tinybird offers a local-first development workflow, git-based deployments, resource definitions as code, and features for AI-native developers. By leveraging Tinybird's data sources and [pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV), you can ingest, transform, and serve large volumes of data through APIs with minimal latency, making it ideal for applications requiring real-time data access. 

## Understanding the data

Imagine your data looks like this, based on the provided fixture files:

```json
{"patient_id": "P42545", "timestamp": "2025-04-17 15:55:15", "heart_rate": 85, "blood_pressure_systolic": 135, "blood_pressure_diastolic": 85, "oxygen_saturation": 95, "temperature": 355962291.5}
```

This data represents a single record of patient vital signs captured at a specific timestamp. The goal is to store this data efficiently for real-time querying. To start, create a Tinybird datasource with the following schema to store these measurements:

```json
DESCRIPTION >
    Datasource for patient vital signs

SCHEMA >
    `patient_id` String `json:$.patient_id`,
    `timestamp` DateTime `json:$.timestamp`,
    `heart_rate` Float32 `json:$.heart_rate`,
    `blood_pressure_systolic` UInt16 `json:$.blood_pressure_systolic`,
    `blood_pressure_diastolic` UInt16 `json:$.blood_pressure_diastolic`,
    `oxygen_saturation` Float32 `json:$.oxygen_saturation`,
    `temperature` Float32 `json:$.temperature`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(timestamp)"
ENGINE_SORTING_KEY "patient_id, timestamp"
```

This schema and engine configuration is designed for efficient storage and querying. The sorting key, combining `patient_id` and `timestamp`, optimizes query performance for time-based patient data lookups. For data ingestion, Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request. Here's how to ingest a single event:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=patient_vitals&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV" \
  -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
  -d '{
    "patient_id": "patient_123",
    "timestamp": "2024-01-01 00:15:00",
    "heart_rate": 72.5,
    "blood_pressure_systolic": 120,
    "blood_pressure_diastolic": 80,
    "oxygen_saturation": 98.2,
    "temperature": 36.7
  }'
```

In addition to the Events API, you can use the Kafka connector for streaming data or the [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) and S3 connector for batch/file data. These methods ensure flexible and robust data ingestion paths according to your application needs. 

## Transforming data and publishing APIs

Tinybird's pipes feature enables batch and real-time data transformations, as well as the publication of API [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) directly from SQL queries. This functionality is crucial for creating scalable, real-time APIs from large datasets. 

### Creating API Endpoints

For our healthcare monitoring system, we'll create two endpoints: `patient_vitals_range` and `latest_vitals`. 

#### patient_vitals_range.pipe

This endpoint returns vital signs for a specific patient within a time range:

```sql
DESCRIPTION >
    API endpoint to get vital signs for a given patient within a specified time range. NODE patient_vitals_range_node
SQL >
    %
    SELECT
        patient_id,
        timestamp,
        heart_rate,
        blood_pressure_systolic,
        blood_pressure_diastolic,
        oxygen_saturation,
        temperature
    FROM patient_vitals
    WHERE patient_id = {{String(patient_id, 'patient_123')}}
    AND timestamp BETWEEN {{DateTime(start_time, '2024-01-01 00:00:00')}} AND {{DateTime(end_time, '2024-01-01 01:00:00')}}
    ORDER BY timestamp

TYPE endpoint
```

This SQL query retrieves all vital sign records for a given patient ID within a specified time range, ordered by the timestamp. 

#### latest_vitals.pipe

This endpoint fetches the most recent vital signs for a specific patient:

```sql
DESCRIPTION >
    API endpoint to get the latest vital signs for a given patient. NODE latest_vitals_node
SQL >
    %
    SELECT
        patient_id,
        timestamp,
        heart_rate,
        blood_pressure_systolic,
        blood_pressure_diastolic,
        oxygen_saturation,
        temperature
    FROM patient_vitals
    WHERE patient_id = {{String(patient_id, 'patient_123')}}
    ORDER BY timestamp DESC
    LIMIT 1

TYPE endpoint
```

Here, the SQL query sorts the patient's vital signs records in descending order by timestamp, returning the most recent record. 

## Deploying to production

Deploying your project to Tinybird Cloud is straightforward with the command:

```bash
tb --cloud deploy
```

This command deploys your [data sources](https://www.tinybird.co/docs/forward/get-data-in/data-sources?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) and pipes, creating scalable, production-ready API endpoints. Tinybird manages your resources as code, enabling integration with CI/CD pipelines and ensuring that your deployment process is smooth and efficient. To secure your APIs, Tinybird employs token-based authentication. Here's how you might call one of your deployed endpoints:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/latest_vitals.json?patient_id=patient_123&token=%24TB_ADMIN_TOKEN&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV"
```


## Conclusion

Throughout this tutorial, we've demonstrated how to build a real-time API for healthcare monitoring using Tinybird, from ingesting patient vital signs data to transforming it and publishing scalable API endpoints. Tinybird simplifies the process of managing large volumes of data in real-time, making it an ideal choice for developers building data-intensive applications. [Sign up for Tinybird](https://cloud.tinybird.co/signup?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) to build and deploy your first real-time data APIs in a few minutes. Start for free, with no time limit and no credit card required, and explore how Tinybird can power your next project.