# Build a Real-Time Classroom Engagement Analytics API with Tinybird

Tracking student engagement in classroom activities is crucial for educators to understand interaction patterns and improve learning outcomes. This tutorial walks you through building a real-time analytics API to capture and analyze various engagement events, such as video views, quiz completions, and discussion participation. Using Tinybird, a data analytics backend for software developers, you'll learn to handle this data effectively to provide insights into student behavior. Tinybird facilitates the creation of real-time analytics APIs without the hassle of managing underlying infrastructure. It leverages data sources and [pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV), enabling you to ingest, transform, and serve large volumes of data efficiently. This tutorial will guide you through setting up data sources for storing engagement events, transforming this data to extract meaningful metrics, and publishing APIs to access these insights in real-time. Let's dive into how you can leverage Tinybird's capabilities to build a classroom engagement analytics API. 

## Understanding the data

Imagine your data looks like this:

```json
{
  "event_id": "evt_d67ac1672e7f8dc9",
  "student_id": "stu_935",
  "class_id": "cls_35",
  "event_type": "assignment_started",
  "timestamp": "2025-05-06 06:53:47",
  "duration_seconds": 745,
  "content_id": "content_435",
  "metadata": "{\"difficulty\":\"easy\",\"score\":35,\"correct\":1}"
}
```

This data represents various engagement events in classroom activities, capturing detailed information about how students interact with learning content. To store this data in Tinybird, you first need to create a data source. Here's how you define the schema for the `engagement_events` data source:

```json
DESCRIPTION >
    Raw engagement events from classroom activities

SCHEMA >
    `event_id` String `json:$.event_id`,
    `student_id` String `json:$.student_id`,
    `class_id` String `json:$.class_id`,
    `event_type` String `json:$.event_type`,
    `timestamp` DateTime `json:$.timestamp`,
    `duration_seconds` Int32 `json:$.duration_seconds`,
    `content_id` String `json:$.content_id`,
    `metadata` String `json:$.metadata`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(timestamp)"
ENGINE_SORTING_KEY "timestamp, class_id, student_id, event_type"
```

The schema design choices, such as the sorting key, are made to optimize query performance, particularly for time-series data. For data ingestion, Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request. This API is designed for low latency, real-time data ingestion:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=engagement_events&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "event_id": "e12345",
       "student_id": "ST001",
       "class_id": "CL001",
       "event_type": "video_view",
       "timestamp": "2023-05-15 14:30:00",
       "duration_seconds": 300,
       "content_id": "VID123",
       "metadata": "{\"completion_percentage\": 85, \"device\": \"laptop\"}"
     }'
```

Other ingestion methods include:
- **Kafka connector**: Benefits from Kafka's distributed system for event streaming data. - **[Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) and S3 connector**: Suitable for batch or file-based data ingestion. Here's an example using the Tinybird CLI to ingest data from a file:

```bash
tb datasource append engagement_events.datasource engagement_events.ndjson
```


## Transforming data and publishing APIs

Tinybird's pipes feature allows for powerful data transformations and the creation of API endpoints. This involves batch transformations, real-time transformations ([Materialized views](https://www.tinybird.co/docs/forward/work-with-data/optimize/materialized-views?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV)), and endpoint creation for serving data. 

#### Materialized Views

If your project benefits from pre-aggregated data for faster query performance, you would create materialized views within your pipes. Here's an example of a materialized view setup:

```sql
-- This is a hypothetical example to illustrate how you might set up a materialized view in Tinybird
CREATE MATERIALIZED VIEW engagement_summary AS
SELECT 
    class_id,
    event_type,
    count() as event_count
FROM engagement_events
GROUP BY class_id, event_type
```


#

### API Endpoints

Let's focus on the `student_engagement` endpoint. This pipe aggregates engagement metrics for a specific student over time:

```sql
DESCRIPTION >
    API endpoint to track engagement metrics for a specific student over time

NODE student_engagement_node
SQL >
    SELECT 
        student_id,
        event_type,
        count() as event_count,
        sum(duration_seconds) as total_duration_seconds,
        min(timestamp) as first_event,
        max(timestamp) as last_event
    FROM engagement_events
    WHERE student_id = {{String(student_id, "ST001")}}
    AND class_id = {{String(class_id, "CL001")}}
    AND timestamp >= {{DateTime(start_date, "2023-01-01 00:00:00")}}
    AND timestamp <= {{DateTime(end_date, "2023-12-31 23:59:59")}}
    GROUP BY student_id, event_type
    ORDER BY event_type

TYPE endpoint
```

This query aggregates events by type for a given student, allowing educators to analyze learning patterns. Query parameters make the API flexible, enabling users to filter by student ID, class ID, and date range. Example API call:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/student_engagement.json?token=%24TB_ADMIN_TOKEN&student_id=ST001&class_id=CL001&start_date=2023-01-01+00%3A00%3A00&end_date=2023-12-31+23%3A59%3A59&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV"
```


## Deploying to production

To deploy your project to Tinybird Cloud, use the `tb --cloud deploy` command. This command deploys your [data sources](https://www.tinybird.co/docs/forward/get-data-in/data-sources?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV), pipes, and any other resources to Tinybird Cloud, making your APIs production-ready and scalable. Tinybird manages resources as code, facilitating integration with CI/CD pipelines and ensuring your data infrastructure is version-controlled and deployable with the click of a button. Secure your APIs with token-based authentication:

```bash
curl -X GET "https://api.tinybird.co/v0/pipes/your_pipe.json?token=YOUR_TOKEN&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV"
```


## Conclusion

In this tutorial, you've learned how to build a real-time analytics API with Tinybird to track and analyze student engagement in classroom activities. By ingesting event data, transforming this data to extract meaningful metrics, and publishing APIs, you can provide educators with insights into student interaction patterns. The technical benefits of using Tinybird include efficient data ingestion, powerful real-time transformations, and the ability to deploy scalable APIs quickly. [Sign up for Tinybird](https://cloud.tinybird.co/signup?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) to build and deploy your first real-time data APIs in a few minutes. Tinybird is free to start, with no time limit and no credit card required.