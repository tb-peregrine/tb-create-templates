# Build a Real-Time Retail Foot Traffic Analytics API with Tinybird

Tracking and analyzing foot traffic in retail stores is crucial for understanding customer behavior, optimizing store layouts, and improving overall business operations. In this tutorial, we'll guide you through building a real-time analytics API that allows you to monitor retail store foot traffic data, including visit patterns, traffic by time of day, and individual visitor details. We'll leverage Tinybird, a data analytics backend for software developers, to implement this solution efficiently. Tinybird enables the creation of real-time analytics APIs without the hassle of managing infrastructure, offering a local-first development workflow, git-based deployments, resource definitions as code, and features aimed at AI-native developers. This API will leverage Tinybird's data sources and pipes to ingest, transform, and serve your foot traffic data through HTTP [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV). By following this tutorial, you'll learn how to ingest data in real-time, perform transformations to derive meaningful insights, and publish these insights through scalable, secure APIs. 

## Understanding the data

Imagine your data looks like this:

```json
{"visit_id": "visit_5968", "store_id": "store_4", "timestamp": "2025-05-12 13:18:07", "visitor_id": "visitor_968", "entry_point": "back door", "exit_point": "back door", "dwell_time_seconds": 2028, "tags": []}
{"visit_id": "visit_3549", "store_id": "store_5", "timestamp": "2025-05-12 14:05:06", "visitor_id": "visitor_549", "entry_point": "patio entrance", "exit_point": "patio entrance", "dwell_time_seconds": 2809, "tags": ["purchasing"]}
... ```

This data represents visits to retail stores, capturing details like visit IDs, store IDs, timestamps, visitor IDs, entry/exit points, dwell times, and tags associated with each visit. To store this data in Tinybird, we create a data source with the following schema:

```json
DESCRIPTION >
    Raw data of customer visits to retail stores

SCHEMA >
    `visit_id` String `json:$.visit_id`,
    `store_id` String `json:$.store_id`,
    `timestamp` DateTime `json:$.timestamp`,
    `visitor_id` String `json:$.visitor_id`,
    `entry_point` String `json:$.entry_point`,
    `exit_point` String `json:$.exit_point`,
    `dwell_time_seconds` Int32 `json:$.dwell_time_seconds`,
    `tags` Array(String) `json:$.tags[:]`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(timestamp)"
ENGINE_SORTING_KEY "store_id, timestamp"
```

This schema is designed to efficiently query the data by store and timestamp, crucial for analyzing traffic patterns. For data ingestion, Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request. It's designed for real-time data ingestion with low latency, making it ideal for foot traffic data. Here's how you can send a single event to the `store_visits` data source:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=store_visits&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{"visit_id":"v12345","store_id":"store001","timestamp":"2023-06-15 14:30:00","visitor_id":"cust789","entry_point":"main entrance","exit_point":"side door","dwell_time_seconds":1200,"tags":["loyalty member","weekday shopper"]}'
```

Additionally, Tinybird provides a Kafka connector for streaming data and a [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) and S3 connector for batch or file data ingestion. 

## Transforming data and publishing APIs

Tinybird's pipes allow you to transform data and publish APIs. Pipes can perform batch transformations, create real-time [Materialized views](https://www.tinybird.co/docs/forward/work-with-data/optimize/materialized-views?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV), and serve as API endpoints. 

#

## Creating API Endpoints

Let's look at the pipe for the `visitor_details` endpoint:

```sql
DESCRIPTION >
    Get details for a specific visitor or latest visitors

NODE visitor_details_node
SQL >
    SELECT 
        visitor_id,
        count() as total_visits,
        min(timestamp) as first_visit,
        max(timestamp) as last_visit,
        avg(dwell_time_seconds) as avg_dwell_time,
        groupArray(store_id) as visited_stores,
        groupArray(entry_point) as entry_points,
        groupArray(tags) as visit_tags
    FROM store_visits
    WHERE 1=1
    {% if defined(visitor_id) %}
        AND visitor_id = {{String(visitor_id, '')}}
    {% end %}
    {% if defined(start_date) %}
        AND timestamp >= {{DateTime(start_date, '2023-01-01 00:00:00')}}
    {% end %}
    {% if defined(end_date) %}
        AND timestamp <= {{DateTime(end_date, '2023-12-31 23:59:59')}}
    {% end %}
    GROUP BY visitor_id
    {% if not defined(visitor_id) %}
    ORDER BY last_visit DESC
    LIMIT {{Int32(limit, 100)}}
    {% end %}

TYPE endpoint
```

This pipe computes the total visits, first and last visit timestamps, average dwell time, and aggregates the stores visited, entry points, and tags for each visitor or a specific visitor. It demonstrates how to use SQL logic to process and aggregate data, templating logic for dynamic query parameters, and how to publish the results as an API endpoint. Here's how to call this endpoint:

```bash
# Get data for a specific visitor
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/[pipes?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV](https://www.tinybird.co/docs/forward/work-with-data/pipes?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV)/visitor_details.json?token=$TB_ADMIN_TOKEN&visitor_id=cust789"
```

Similarly, you can create and query the `hourly_traffic_patterns` and `visits_by_store` endpoints following the same principles. 

## Deploying to production

To deploy these resources to the Tinybird Cloud, use the Tinybird CLI:

```bash
tb --cloud deploy
```

This command deploys your [data sources](https://www.tinybird.co/docs/forward/get-data-in/data-sources?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV), pipes, and endpoints to production, ensuring they are scalable and secure. Tinybird manages resources as code, facilitating integration with CI/CD pipelines. For securing the APIs, Tinybird relies on token-based authentication. Here's how you can call a deployed endpoint:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/visitor_details.json?token=%24TB_ADMIN_TOKEN&visitor_id=cust789&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV"
```


## Conclusion

In this tutorial, you've learned how to ingest, transform, and expose retail store foot traffic data as real-time analytics APIs using Tinybird. By leveraging data sources for ingestion, pipes for transformation and API creation, and deploying to production for scalability and security, you can implement comprehensive analytics solutions quickly and efficiently. [Sign up for Tinybird](https://cloud.tinybird.co/signup?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) to build and deploy your first real-time data APIs in a few minutes.