# Build a Real-Time Log Anomaly Detection API with Tinybird

Today, we're diving into how to build a real-time API for monitoring system logs and detecting anomalies based on configurable thresholds. This tutorial will guide you through creating a log anomaly detection system using Tinybird, a data analytics backend designed for software developers. Tinybird empowers you to build real-time analytics APIs without the hassle of managing the underlying infrastructure. It leverages data sources and [pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes) to ingest, transform, and serve your data through APIs with minimal latency, making it ideal for implementing a log anomaly detection system. Let's start by understanding the data we will be working with and how to ingest it into Tinybird. ## Understanding the data

Imagine your data looks like this:

```json
{"timestamp": "2025-05-12 04:58:31", "server_id": "srv-10", "service": "api", "severity": "DEBUG", "message": "Configuration updated", "error_code": "", "resource_id": "res-310", "metadata": "{\"user_id\":\"10\",\"duration_ms\":859,\"status_code\":600}"}
{"timestamp": "2025-05-11 19:54:10", "server_id": "srv-21", "service": "redis", "severity": "INFO", "message": "Connection established", "error_code": "E6970", "resource_id": "res-971", "metadata": "{\"user_id\":\"71\",\"duration_ms\":490,\"status_code\":200}"}
```

This data represents system logs containing various details such as timestamps, server IDs, services, severity levels, messages, error codes, resource IDs, and metadata. To store this data, we will create Tinybird [data sources](https://www.tinybird.co/docs/forward/get-data-in/data-sources). ### Creating Tinybird datasources

For `system_logs`, your data source might look like this:

```json
DESCRIPTION >
    System logs containing messages, severity levels, timestamps, and other system information

SCHEMA >
    `timestamp` DateTime `json:$.timestamp`,
    `server_id` String `json:$.server_id`,
    `service` String `json:$.service`,
    `severity` String `json:$.severity`,
    `message` String `json:$.message`,
    `error_code` String `json:$.error_code`,
    `resource_id` String `json:$.resource_id`,
    `metadata` String `json:$.metadata`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(timestamp)"
ENGINE_SORTING_KEY "timestamp, server_id, service, severity"
```

For `log_anomaly_thresholds`, the data source would be:

```json
DESCRIPTION >
    Configurable thresholds for anomaly detection in system logs

SCHEMA >
    `service` String `json:$.service`,
    `severity` String `json:$.severity`,
    `threshold_per_minute` Float64 `json:$.threshold_per_minute`,
    `active` UInt8 `json:$.active`,
    `updated_at` DateTime `json:$.updated_at`

ENGINE "MergeTree"
ENGINE_SORTING_KEY "service, severity"
```

These schemas highlight the importance of selecting appropriate column types and sorting keys to optimize query performance. ### Data ingestion

Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request. It offers real-time ingestion with low latency. Here's how you would ingest logs into the `system_logs` data source:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=system_logs" \
  -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
  -d '{
    "timestamp": "2023-06-01 14:30:00",
    "server_id": "srv-001",
    "service": "authentication",
    "severity": "ERROR",
    "message": "Failed login attempt",
    "error_code": "AUTH-401",
    "resource_id": "user-123",
    "metadata": "{\"ip\": \"192.168.1.1\", \"browser\": \"Chrome\"}"
  }'
```

For event or streaming data, Tinybird also supports a Kafka connector for high-throughput needs. For batch or file data, the [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api) and S3 connectors are available options for ingestion. ## Transforming data and publishing APIs

Tinybird uses pipes for batch transformations, real-time transformations, and creating API endpoints. ### Batch transformations and [Materialized views](https://www.tinybird.co/docs/forward/work-with-data/optimize/materialized-views)

If you're working with materialized views to optimize your data pipeline, here's how you might set them up:

```sql
-- Example materialized view code
```

These materialized views can significantly enhance the performance of your data pipeline by pre-aggregating data. ### Creating endpoint pipes

Let's look at how to create [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints) for accessing your data. For example, to retrieve recent logs:

```sql
DESCRIPTION >
    Retrieves recent system logs with filtering options for time range, severity, and service

NODE recent_logs_node
SQL >
    %
    SELECT
        timestamp,
        server_id,
        service,
        severity,
        message,
        error_code,
        resource_id,
        metadata
    FROM system_logs
    WHERE 1=1
    {% if defined(start_time) %}
        AND timestamp >= {{DateTime(start_time, '2023-01-01 00:00:00')}}
    {% else %}
        AND timestamp >= now() - interval 1 hour
    {% end %}
    {% if defined(end_time) %}
        AND timestamp <= {{DateTime(end_time, '2023-12-31 23:59:59')}}
    {% else %}
        AND timestamp <= now()
    {% end %}
    {% if defined(severity) %}
        AND severity = {{String(severity, 'ERROR')}}
    {% end %}
    {% if defined(service) %}
        AND service = {{String(service, '')}}
    {% end %}
    ORDER BY timestamp DESC
    LIMIT {{Int32(limit, 100)}}

TYPE endpoint
```

This pipe allows you to fetch recent logs with customizable filters for the time range, severity, and service. ### Example API calls

Here's how you would call the `recent_logs` endpoint:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/recent_logs.json?token=$TB_ADMIN_TOKEN&start_time=2023-06-01%2000:00:00&end_time=2023-06-02%2000:00:00&severity=ERROR&service=authentication&limit=50"
```


## Deploying to production

To deploy your project to Tinybird Cloud, use the following command:

```bash
tb --cloud deploy
```

This command makes your API endpoints production-ready and scalable. Tinybird manages resources as code, facilitating integration with CI/CD pipelines. It also supports token-based authentication to secure your APIs. Example curl command to call your deployed endpoint:

```bash
curl -X GET "https://api.tinybird.co/v0/pipes/your_pipe_name.json?token=your_token"
```


## Conclusion

In this tutorial, we've walked through building a real-time log anomaly detection API using Tinybird. We covered how to ingest data, transform it, and publish APIs for accessing the log data and detecting anomalies. Tinybird simplifies these processes, enabling software developers to focus on building applications rather than managing infrastructure. [Sign up for Tinybird](https://cloud.tinybird.co/signup) to build and deploy your first real-time data APIs in a few minutes.