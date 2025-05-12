# Build a Real-Time User Search Behavior Analysis API with Tinybird

Analyzing user search behavior in real-time can provide valuable insights into trends, user activity, and overall search performance. Such analysis requires handling and querying large volumes of data swiftly to deliver actionable results promptly. In this tutorial, we'll demonstrate how to build a real-time API to analyze user search behavior using Tinybird. Tinybird is a data analytics backend for software developers. You use Tinybird to build real-time analytics APIs without needing to set up or manage the underlying infrastructure. Tinybird offers a local-first development workflow, git-based deployments, resource definitions as code, and features for AI-native developers. By leveraging Tinybird's data sources and [pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes), we can ingest, transform, and serve user search data through efficient, scalable APIs. Now, let's dive into how we can implement this solution step by step. ## Understanding the data

Imagine your data looks like this:

```json
{"user_id": "user_531", "session_id": "sess_1531", "timestamp": "2025-05-12 15:07:18", "query": "how to order", "results_count": 31, "clicked_result": 1, "device_type": "desktop", "country": "Canada"}
{"user_id": "user_972", "session_id": "sess_2972", "timestamp": "2025-05-11 19:33:17", "query": "discount code", "results_count": 72, "clicked_result": 0, "device_type": "tablet", "country": "UK"}
... ```

This data represents user search events, capturing details like the search query, the number of results returned, whether a result was clicked, and metadata about the user and their device. To store this data in Tinybird, we create a data source with an appropriate schema:

```json
DESCRIPTION >
    Records of user search events including search queries, timestamps, and user identifiers

SCHEMA >
    `user_id` String `json:$.user_id`,
    `session_id` String `json:$.session_id`,
    `timestamp` DateTime `json:$.timestamp`,
    `query` String `json:$.query`,
    `results_count` Int32 `json:$.results_count`,
    `clicked_result` UInt8 `json:$.clicked_result`,
    `device_type` String `json:$.device_type`,
    `country` String `json:$.country`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(timestamp)"
ENGINE_SORTING_KEY "timestamp, user_id, session_id"
```

The choice of `MergeTree` as the engine, partitioned by month (`toYYYYMM(timestamp)`) and sorted by `timestamp`, `user_id`, and `session_id`, ensures efficient storage and querying, particularly for time-series data. ### Ingesting Data

Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request, ideal for real-time data ingestion:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=search_events" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{"user_id":"user123", "session_id":"session456", "timestamp":"2024-01-26 10:00:00", "query":"example query", "results_count":10, "clicked_result":1, "device_type":"mobile", "country":"US"}'
```

For event or streaming data, the Kafka connector can provide robust, scalable ingestion. For batch or file-based data, the [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api) and S3 connector are effective methods. For instance, using the Tinybird CLI to upload data:

```bash
tb datasource append search_events.datasource search_events.ndjson
```


## Transforming data and publishing APIs


### pipes in Tinybird

Tinybird pipes are used to transform and query data in real-time, creating scalable and efficient APIs from these transformations. #### Endpoint: search_metrics

The `search_metrics` endpoint aggregates key search metrics over a specified time period, optionally grouped by dimensions like country or device type:

```sql
DESCRIPTION >
    Returns key search metrics grouped by time period and optional dimensions

NODE search_metrics_node
SQL >
    ... GROUP BY 
        time_bucket
        {% if defined(group_by) and String(group_by, '') == 'country' %}
            , country
        {% elif defined(group_by) and String(group_by, '') == 'device_type' %}
            , device_type
        {% end %}
    ORDER BY 
        time_bucket
        {% if defined(group_by) and String(group_by, '') == 'country' %}
            , country
        {% elif defined(group_by) and String(group_by, '') == 'device_type' %}
            , device_type
        {% end %}

TYPE endpoint
```

This pipe's SQL logic dynamically adjusts based on query parameters, offering flexibility in the API:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/search_metrics.json?token=$TB_ADMIN_TOKEN&time_bucket=day&start_date=2024-01-01 00:00:00&end_date=2024-01-31 23:59:59"
```


#### More Endpoints

Similar approaches are used for the `search_trends` and `user_search_activity` [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints), where SQL queries aggregate and filter data based on API parameters, providing real-time insights into search trends and individual user or session activities. ## Deploying to production

Deploy your project to Tinybird Cloud using the Tinybird CLI:

```bash
tb --cloud deploy
```

This command creates production-ready, scalable API endpoints. Tinybird manages resources as code, allowing for easy integration with CI/CD pipelines. Secure your APIs with token-based authentication. Example API call:

```bash
curl -X GET "https://api.tinybird.co/v0/pipes/search_metrics.json?token=<your_production_token>&time_bucket=day&..."
```


## Conclusion

In this tutorial, we've built a real-time API for analyzing user search behavior using Tinybird. By ingesting search event data, transforming it through pipes, and publishing scalable endpoints, we've enabled real-time insights into search trends and performance. Tinybird's infrastructure allows for efficient querying and scaling, making it ideal for real-time analytics applications. [Sign up for Tinybird](https://cloud.tinybird.co/signup) to build and deploy your first real-time data APIs in a few minutes.