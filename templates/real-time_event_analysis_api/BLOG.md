# Build a Real-Time Event Attendance Analytics API with Tinybird

Tracking and analyzing event attendance in real-time can be a complex task, involving the ingestion of streaming data and the need for immediate insights. Whether it's for managing venue capacities, optimizing event schedules, or enhancing attendee experiences, access to real-time data is crucial. In this tutorial, you'll learn how to leverage Tinybird, a data analytics backend for software developers, to build a real-time analytics API focused on event attendance. Using Tinybird, you'll be able to create data sources, transform data with SQL, and publish API [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) without worrying about the underlying infrastructure. This solution employs Tinybird's data sources and pipes to ingest, process, and expose event attendance data through flexible, scalable APIs. 

## Understanding the data

Imagine your data looks like this:

```json
{
  "event_id": "evt_179",
  "user_id": "usr_179",
  "attendance_status": "no-show",
  "check_in_time": "2025-05-12 03:21:13",
  "event_type": "concert",
  "venue": "Studio 5",
  "timestamp": "2025-05-11 03:21:13"
}
```

This data represents records of individuals' attendance at various events, noting their status (e.g., "no-show" or "checked_in"), the time of check-in, the event type, and the venue. To store this data in Tinybird, you'll create a data source with a schema that reflects these fields. Your `.datasource` file might look something like this:

```json
DESCRIPTION >
    Records of attendance at different events, including user information and timestamps

SCHEMA >
    `event_id` String `json:$.event_id`,
    `user_id` String `json:$.user_id`,
    `attendance_status` String `json:$.attendance_status`,
    `check_in_time` DateTime `json:$.check_in_time`,
    `event_type` String `json:$.event_type`,
    `venue` String `json:$.venue`,
    `timestamp` DateTime `json:$.timestamp`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(timestamp)"
ENGINE_SORTING_KEY "event_id, user_id, timestamp"
```

In the schema, each field is defined with a type, and the engine configuration specifies how data is partitioned and sorted. This design optimizes query performance by organizing data efficiently. To ingest data, Tinybird provides several options. The [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) is particularly suited for streaming JSON/NDJSON events from your application. Here's how to use it:

```bash
curl -X POST "https://api.tinybird.co/v0/events?name=event_attendance&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV" \
    -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
    -d '{
      "event_id": "event_001", 
      "user_id": "user_123", 
      "attendance_status": "checked_in", 
      "check_in_time": "2023-10-15 14:30:00", 
      "event_type": "conference", 
      "venue": "Convention Center", 
      "timestamp": "2023-10-15 14:30:00"
    }'
```

This method is ideal for low-latency, real-time data ingestion. Alternatively, Tinybird's Kafka connector facilitates event/streaming data ingestion, while the [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) and S3 connector are excellent for batch/file data. 

## Transforming data and publishing APIs

Tinybird's pipes are at the core of data transformation and API publication. They enable batch transformations, real-time transformations through [Materialized views](https://www.tinybird.co/docs/forward/work-with-data/optimize/materialized-views?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV), and the creation of API endpoints. For instance, to compare venue attendance, you might have a pipe like this:

```sql
DESCRIPTION >
    Compare attendance metrics across different venues or event types

NODE venue_attendance_comparison_node
SQL >
    SELECT 
        venue,
        count(DISTINCT event_id) AS total_events,
        count(DISTINCT user_id) AS unique_attendees,
        countIf(attendance_status = 'checked_in') AS total_check_ins,
        round(countIf(attendance_status = 'checked_in') / 
              countIf(attendance_status IN ('checked_in', 'registered', 'no_show')) * 100, 2) AS overall_check_in_rate
    FROM event_attendance
    WHERE 
        {% if defined(event_type) %}
        event_type = {{String(event_type, 'conference')}}
        {% else %}
        1=1
        {% end %}
    GROUP BY venue
    ORDER BY total_events DESC

TYPE endpoint
```

This SQL logic illustrates how to aggregate and filter data to compare venue performance dynamically. Including query parameters (`event_type` in this case) makes the API flexible for various analytical needs. Example API call:

```bash
curl -X GET "https://api.tinybird.co/v0/[pipes?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV](https://www.tinybird.co/docs/forward/work-with-data/pipes?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV)/venue_attendance_comparison.json?token=$TB_ADMIN_TOKEN&event_type=workshop"
```

By modifying the query parameters, you can tailor the request to fit different analytical scenarios. 

## Deploying to production

Deploying your project to Tinybird Cloud is straightforward with the `tb --cloud deploy` command. This command prepares your [data sources](https://www.tinybird.co/docs/forward/get-data-in/data-sources?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) and pipes for production, ensuring scalability and performance. Tinybird manages resources as code, facilitating integration with CI/CD pipelines and ensuring that your data analytics infrastructure is version-controlled and reproducible. Secure your API endpoints with token-based authentication to control access. Example deployment:

```bash
tb --cloud deploy
```

And to call your deployed endpoint:

```bash
curl -X GET "https://api.tinybird.co/v0/pipes/hourly_check_ins.json?token=%24TB_ADMIN_TOKEN&event_id=event_001&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV"
```


## Conclusion

Throughout this tutorial, you've built a real-time event attendance analytics API using Tinybird. From ingesting and storing data to transforming it and exposing it through scalable API endpoints, Tinybird enables rapid development and deployment of data-driven applications. The technical benefits of using Tinybird for this use case include streamlined data ingestion, efficient data transformation with SQL, and the ability to publish and manage APIs with ease. Whether you're managing a single event or an entire venue network, this solution provides the tools you need to access real-time insights. [Sign up for Tinybird](https://cloud.tinybird.co/signup?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) to build and deploy your first real-time data APIs in a few minutes.