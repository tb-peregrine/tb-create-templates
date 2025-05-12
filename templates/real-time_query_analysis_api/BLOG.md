# Build a Real-time Database Query Performance Analytics API with Tinybird

In the realm of software development, monitoring and analyzing database query performance is crucial for maintaining application efficiency and speed. Slow or inefficient queries can drastically affect user experience and increase resource consumption, leading to higher costs. This tutorial will guide you through creating a real-time API that ingests database query logs and provides [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints) to analyze query trends, performance by query type, and identify slow queries for optimization. We'll use Tinybird, a data analytics backend for software developers, to implement this solution. Tinybird allows you to build real-time analytics APIs without the need to set up or manage the underlying infrastructure. It leverages data sources and pipes to ingest, transform, and expose your data through high-performance APIs. ## Understanding the data

Imagine your data looks like this:

```json
{"query_id": "qid_7802", "database": "staging", "query_text": "SELECT * FROM table2 WHERE column2 = 2", "query_type": "SELECT", "user": "user2", "start_time": "2025-05-12 17:01:52", "end_time": "2025-05-12 17:03:32", "duration_ms": 2902, "rows_read": 737802, "bytes_read": 377737802, "memory_usage": 377737802, "status": "success", "error_message": "", "client_ip": "192.168.87.87"}
```

This data represents logs from database queries, including identifiers, database names, the query itself, performance metrics like duration and resources used, and the outcome of the query. To store this data in Tinybird, we create a data source with a schema that mirrors these fields. Here's how you can define such a data source in a `.datasource` file:

```json
DESCRIPTION >
    Stores database query logs for performance analysis

SCHEMA >
    `query_id` String `json:$.query_id`,
    `database` String `json:$.database`,
    `query_text` String `json:$.query_text`,
    `query_type` String `json:$.query_type`,
    `user` String `json:$.user`,
    `start_time` DateTime `json:$.start_time`,
    `end_time` DateTime `json:$.end_time`, 
    `duration_ms` Float64 `json:$.duration_ms`,
    `rows_read` UInt64 `json:$.rows_read`,
    `bytes_read` UInt64 `json:$.bytes_read`,
    `memory_usage` UInt64 `json:$.memory_usage`,
    `status` String `json:$.status`,
    `error_message` String `json:$.error_message`,
    `client_ip` String `json:$.client_ip`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(start_time)"
ENGINE_SORTING_KEY "start_time, database, query_type, user"
```

This schema is designed for optimal query performance, with a sorting key that aligns with how we'll query the data. For data ingestion, Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request. This is ideal for real-time data like query logs. Here's how you would use it:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=query_logs" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{"query_id": "b3f1c8a5-7d84-4f93-9c64-8f7b36c5e1d2", ... }'
```

In addition to the Events API, Tinybird also offers a Kafka connector for streaming data and the [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api) and S3 connector for batch or file-based data ingestion. ## Transforming data and publishing APIs

Tinybird's [pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes) enable batch and real-time data transformations, and the creation of API endpoints. Let's explore how to use pipes to analyze our query logs. ### Analyzing trends in query performance over time

The `query_trends` pipe aggregates query logs by hour, calculating metrics such as the average query duration and error count. This helps identify periods of high load or frequent errors. ```sql
DESCRIPTION >
    Analyzes trends in query performance over time

NODE query_trends_node
SQL >
    SELECT 
        toStartOfHour(start_time) as hour,
        count() as query_count,
        avg(duration_ms) as avg_duration_ms,
        ... GROUP BY hour
    ORDER BY hour DESC

TYPE endpoint
```

This SQL aggregates queries by the hour they were started, providing insights into the number of queries, their average duration, and other metrics over time. To call this API, you would use:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/query_trends.json?token=$TB_ADMIN_TOKEN&start_time=2023-06-01%2000:00:00&end_time=2023-06-30%2023:59:59&database=production&query_type=SELECT"
```

By changing the parameters, you can filter the data for specific databases or query types. ### Grouping query performance by type

The `query_performance_by_type` pipe groups performance metrics by query type, such as SELECT, UPDATE, or INSERT. This can help identify which query types are most resource-intensive. ```sql
DESCRIPTION >
    Analyzes query performance metrics grouped by query type

NODE query_performance_by_type_node
SQL >
    SELECT 
        query_type,
        count() as query_count,
        avg(duration_ms) as avg_duration_ms,
        ... GROUP BY query_type
    ORDER BY avg_duration_ms DESC

TYPE endpoint
```


### Identifying slow queries

The `slow_queries` pipe filters queries that exceed a specified duration threshold, useful for identifying and optimizing slow queries. ```sql
DESCRIPTION >
    Identifies and analyzes slow queries that exceed a specified duration threshold

NODE slow_queries_node
SQL >
    SELECT 
        query_id,
        database,
        query_type,
        ... ORDER BY duration_ms DESC
    LIMIT {{Int32(limit, 100)}}

TYPE endpoint
```


## Deploying to production

To deploy these [data sources](https://www.tinybird.co/docs/forward/get-data-in/data-sources) and pipes to the Tinybird cloud, use the Tinybird CLI with the command `tb --cloud deploy`. This command creates scalable, production-ready API endpoints. Tinybird manages these resources as code, facilitating integration with CI/CD pipelines and ensuring your data infrastructure is version-controlled and deployable with ease. Secure your APIs using token-based authentication to keep your data protected. Example API call:

```bash
curl -X GET "https://api.tinybird.co/v0/pipes/slow_queries.json?token=$TB_ADMIN_TOKEN&duration_threshold_ms=2000"
```


## Conclusion

In this tutorial, you've learned how to ingest, transform, and expose database query logs as real-time analytics APIs using Tinybird. By leveraging data sources and pipes, you can efficiently analyze query performance trends, identify resource-intensive query types, and spotlight slow queries for optimization. Tinybird's scalable infrastructure and developer-centric tools enable rapid development and deployment of data-driven APIs. [Sign up for Tinybird](https://cloud.tinybird.co/signup) to build and deploy your first real-time data APIs in a few minutes.