# Build a Real-Time EV Charging Station Analytics API with Tinybird

Electric vehicle (EV) charging stations are becoming ubiquitous, and understanding their usage, performance, and user behavior is critical for operators to optimize their services. This tutorial will guide you through building a real-time analytics API for EV charging stations using Tinybird. Tinybird is a data analytics backend for software developers. You use Tinybird to build real-time analytics APIs without needing to set up or manage the underlying infrastructure. Tinybird offers a local-first development workflows, git-based deployments, resource definitions as code, and features for AI-native developers. By the end of this tutorial, you'll be able to ingest charging session data, transform it, and publish APIs to analyze charging station usage, user behavior, and station performance. 

## Understanding the data

Imagine your data looks like this:

```json
{
  "session_id": "sess_3421",
  "station_id": "station_22",
  "user_id": "user_422",
  "start_time": "2025-05-03 12:49:34",
  "end_time": "2025-05-11 12:49:34",
  "energy_consumed": 285463452,
  "amount_paid": 285463502,
  "charging_type": "Standard AC",
  "location": "San Diego",
  "timestamp": "2025-05-01 17:49:34"
}
```

This data represents individual EV charging sessions, capturing details such as session IDs, station IDs, user IDs, start and end times, energy consumed, amounts paid, charging types, locations, and timestamps. To store this data in Tinybird, we first create a data source with a schema designed to match our data's structure. Here's how the `.datasource` file for our `charging_sessions` data source might look:

```json
DESCRIPTION >
    Raw data for EV charging sessions

SCHEMA >
    `session_id` String `json:$.session_id`,
    `station_id` String `json:$.station_id`,
    `user_id` String `json:$.user_id`,
    `start_time` DateTime `json:$.start_time`,
    `end_time` DateTime `json:$.end_time`,
    `energy_consumed` Float64 `json:$.energy_consumed`,
    `amount_paid` Float64 `json:$.amount_paid`,
    `charging_type` String `json:$.charging_type`,
    `location` String `json:$.location`,
    `timestamp` DateTime `json:$.timestamp`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(timestamp)"
ENGINE_SORTING_KEY "station_id, start_time, session_id"
```

The schema design choices, such as column types and sorting keys, directly impact query performance. Sorting keys, for instance, are chosen to optimize the retrieval of sessions by station and time, a common query pattern for our use case. For data ingestion, Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request. This real-time nature of the Events API ensures low latency between data generation and availability in your analytics. Here is how you might use the `curl` command to ingest a charging session event:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=charging_sessions&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
           "session_id": "session123",
           "station_id": "station456",
           "user_id": "user789",
           "start_time": "2024-01-26 10:00:00",
           "end_time": "2024-01-26 11:00:00",
           "energy_consumed": 15.5,
           "amount_paid": 10.00,
           "charging_type": "AC",
           "location": "Main Street",
           "timestamp": "2024-01-26 10:00:00"
         }'
```

Besides the Events API, Tinybird also supports Kafka connectors for streaming data and the [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) and S3 connectors for batch or file-based data. 

## Transforming data and publishing APIs

Tinybird's pipes enable batch transformations, real-time transformations through [Materialized views](https://www.tinybird.co/docs/forward/work-with-data/optimize/materialized-views?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV), and the creation of API endpoints. Let's dive into how we can transform and expose our EV charging session data via API endpoints. 

### User Usage API

The `user_usage` endpoint provides statistics about individual users' EV charging sessions. Here's the complete pipe code for this endpoint:

```sql
DESCRIPTION >
    Get usage statistics for individual EV charging users

NODE user_usage_node
SQL >
    SELECT
        user_id,
        count() AS total_sessions,
        sum(energy_consumed) AS total_energy_consumed,
        sum(amount_paid) AS total_amount_spent,
        avg(energy_consumed) AS avg_energy_per_session,
        avg(amount_paid) AS avg_amount_per_session,
        min(start_time) AS first_session,
        max(start_time) AS latest_session,
        count(DISTINCT station_id) AS unique_stations_used
    FROM charging_sessions
    WHERE 1=1
    AND start_time >= {{DateTime(start_date, '2023-01-01 00:00:00')}}
    AND start_time <= {{DateTime(end_date, '2023-12-31 23:59:59')}}
    AND user_id = {{String(user_id, '')}}
    GROUP BY user_id
    ORDER BY total_sessions DESC
    LIMIT {{Int32(limit, 100)}}

TYPE endpoint
```

The SQL logic aggregates charging session data per user, providing insights into total sessions, energy consumed, amount spent, and station diversity. Query parameters like `user_id`, `start_date`, and `end_date` make the API flexible, allowing for tailored queries. Here's how you might call this API with different parameter values:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/[pipes?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV](https://www.tinybird.co/docs/forward/work-with-data/pipes?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV)/user_usage.json?token=$TB_ADMIN_TOKEN&user_id=user789&start_date=2024-01-01 00:00:00&end_date=2024-01-31 23:59:59&limit=10"
```

Similarly, you would create and explain the `get_sessions` and `station_analytics` [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV), detailing their SQL queries, parameters, and example API calls. 

## Deploying to production

Deploying your project to the Tinybird Cloud is straightforward with the `tb --cloud deploy` command. This command creates production-ready, scalable API endpoints. Tinybird manages resources as code, facilitating integration with CI/CD pipelines and ensuring that your data analytics backend is as agile as your application codebase. To secure your APIs, Tinybird uses token-based authentication. Here's an example `curl` command showing how to call one of the deployed endpoints:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/station_analytics.json?token=%24TB_ADMIN_TOKEN&location=Main&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV Street&start_date=2024-01-01 00:00:00&end_date=2024-01-31 23:59:59&limit=10"
```


## Conclusion

Throughout this tutorial, we've built a real-time analytics API for EV charging stations, capable of ingesting session data, transforming it, and publishing insights on usage, performance, and user behavior. By leveraging Tinybird, we've seen how developers can implement complex data analytics solutions without the overhead of managing infrastructure, focusing instead on delivering value through data. [Sign up for Tinybird](https://cloud.tinybird.co/signup?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) to build and deploy your first real-time data APIs in a few minutes. Get started for free, with no time limit and no credit card required, and unlock the potential of real-time analytics for your projects.