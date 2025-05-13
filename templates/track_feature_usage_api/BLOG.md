# Build a Feature Usage Tracking API with Tinybird

Tracking and analyzing feature usage across different product versions can be a complex task, requiring the collection of event data and the generation of analytics to understand feature adoption, user engagement, and version-specific usage patterns. This tutorial will guide you through creating an API to accomplish this using Tinybird, a data analytics backend for software developers. You'll learn how to ingest event data, transform this data, and finally publish APIs to expose real-time analytics. Tinybird is designed to handle these tasks efficiently, allowing you to focus on the analytics rather than the infrastructure. 

## Understanding the data

Imagine your data looks like this:

```json
{"event_id": "evt_45733add0587f7d7", "user_id": "user_615", "feature_id": "feature_16", "product_version": "1.5.5", "event_type": "view", "timestamp": "2025-05-11 10:23:03", "session_id": "session_163faed228df", "metadata": "{\"device\":\"desktop\",\"os\":\"windows\",\"browser\":\"edge\"}"}
```

This represents an event where a user interacts with a feature of your product. The data captures various details like the user ID, feature ID, product version, event type, timestamp, session ID, and additional metadata. To store this data in Tinybird, create a data source with the following schema:

```json
DESCRIPTION >
    Events that track feature usage across product versions

SCHEMA >
    `event_id` String `json:$.event_id`,
    `user_id` String `json:$.user_id`,
    `feature_id` String `json:$.feature_id`,
    `product_version` String `json:$.product_version`,
    `event_type` String `json:$.event_type`,
    `timestamp` DateTime `json:$.timestamp`,
    `session_id` String `json:$.session_id`,
    `metadata` String `json:$.metadata`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(timestamp)"
ENGINE_SORTING_KEY "timestamp, feature_id, product_version"
```

The choice of `MergeTree` as the engine, partitioned by month (`toYYYYMM(timestamp)`) and sorted by `timestamp`, `feature_id`, and `product_version`, is designed to optimize query performance across large datasets. For data ingestion, Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request. This capability ensures low latency and real-time data availability. Here's how you can send data to your `feature_events` data source:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=feature_events&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "event_id": "evt_12345",
       "user_id": "usr_789",
       "feature_id": "feature_recommendations",
       "product_version": "2.4.1",
       "event_type": "feature_used",
       "timestamp": "2023-10-15 14:35:22",
       "session_id": "sess_456",
       "metadata": "{\"duration_seconds\":45,\"result\":\"success\"}"
     }'
```

Additionally, for events and streaming data, Tinybird's Kafka connector can be an excellent choice for integrating with existing event streams. For batch or file data, the [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) and S3 connector provide methods for bulk data ingestion. 

## Transforming data and publishing APIs

Tinybird facilitates data transformation and publishing through its pipes mechanism. Pipes can perform batch transformations, create [Materialized views](https://www.tinybird.co/docs/forward/work-with-data/optimize/materialized-views?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) for real-time transformations, and publish endpoints to expose the data as APIs. 

### User Feature Usage

To provide feature usage details for a specific user, you can create an endpoint like so:

```sql
DESCRIPTION >
    Feature usage details for a specific user

NODE user_feature_usage_node
SQL >
    %
    SELECT 
        user_id,
        feature_id,
        product_version,
        count() as usage_count,
        min(timestamp) as first_usage,
        max(timestamp) as last_usage
    FROM feature_events
    WHERE 1=1
    {% if defined(user_id) %}
        AND user_id = {{String(user_id, '')}}
    {% else %}
        AND 0=1
    {% end %}
    {% if defined(feature_id) %}
        AND feature_id = {{String(feature_id, '')}}
    {% end %}
    {% if defined(product_version) %}
        AND product_version = {{String(product_version, '')}}
    {% end %}
    GROUP BY user_id, feature_id, product_version
    ORDER BY usage_count DESC

TYPE endpoint
```

This pipe aggregates events by `user_id`, `feature_id`, and `product_version`, providing counts and the first and last usage timestamps. Parameters in the query allow for filtering by user, feature, and product version, offering a flexible API endpoint. 

### Feature Usage Summary and Timeline

Similarly, for summarizing feature usage and providing a timeline, you would define pipes that aggregate data accordingly and expose them as [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV). Here's how you call these APIs with various parameters:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/[pipes?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV](https://www.tinybird.co/docs/forward/work-with-data/pipes?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV)/user_feature_usage.json?token=$TB_ADMIN_TOKEN&user_id=usr_789&feature_id=feature_recommendations"
```

This call retrieves feature usage details for a specific user and feature. 

## Deploying to production

Deploying your project to Tinybird Cloud is straightforward with the `tb --cloud deploy` command. This command deploys all your datasources, pipes, and endpoints to the cloud, making them production-ready and scalable. Tinybird manages resources as code, making it easy to integrate with CI/CD pipelines for automated deployments. Additionally, token-based authentication secures your APIs:

```bash
curl -X GET "https://api.tinybird.co/v0/pipes/your_pipe_name.json?token=YOUR_TOKEN&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV"
```


## Conclusion

In this tutorial, you've learned how to build a feature usage tracking API using Tinybird. From ingesting event data to transforming this data and publishing real-time analytics APIs, Tinybird streamlines the process, allowing you to focus on deriving value from your data. By leveraging Tinybird's [data sources](https://www.tinybird.co/docs/forward/get-data-in/data-sources?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV), pipes, and endpoints, you can efficiently implement complex analytics backends without worrying about the underlying infrastructure. [Sign up for Tinybird](https://cloud.tinybird.co/signup?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) to build and deploy your first real-time data APIs in a few minutes.