# Build a Real-Time Cloud Resource Monitoring API with Tinybird

In this tutorial, you'll learn how to create a real-time API for monitoring cloud resource metrics and detecting anomalies. As cloud infrastructure becomes increasingly dynamic and complex, having instant access to your cloud resources' performance metrics is crucial. By the end of this tutorial, you'll have an API that collects metrics data from various cloud resources, provides [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) for querying this data, and includes anomaly detection to identify unusual resource behavior. Tinybird is a data analytics backend for software developers. You use Tinybird to build real-time analytics APIs without needing to set up or manage the underlying infrastructure. Tinybird offers a local-first development workflows, git-based deployments, resource definitions as code, and features for AI-native developers. With Tinybird's data sources and pipes, you can efficiently store, transform, and query large volumes of data in real-time, making it an ideal platform for implementing a cloud resource monitoring solution. 

## Understanding the data

Imagine your data looks like this:

```json
{"timestamp": "2025-05-12 12:46:16", "resource_id": "r-5706", "resource_type": "rds", "resource_name": "app-6", "metric_name": "memory_usage", "metric_value": 132383570600, "region": "us-west-2", "account_id": "acc-706", "environment": "development"}
{"timestamp": "2025-05-11 21:34:53", "resource_id": "r-789", "resource_type": "dynamodb", "resource_name": "cache-89", "metric_name": "network_out", "metric_value": 210892078900, "region": "sa-east-1", "account_id": "acc-789", "environment": "staging"}
... ```

This dataset represents metrics data collected from various cloud resources, including CPU, memory, disk, and network utilization. Each record contains a timestamp, a unique resource identifier, the type of resource (e.g., EC2 instance, RDS), the resource name, the metric name, the metric value, the AWS region, the account ID, and the environment (e.g., production, staging). To store this data in Tinybird, we create a data source with a schema that reflects the structure of our dataset:

```json
DESCRIPTION >
    Raw metrics data for cloud resource utilization monitoring

SCHEMA >
    `timestamp` DateTime `json:$.timestamp`,
    `resource_id` String `json:$.resource_id`,
    `resource_type` String `json:$.resource_type`,
    `resource_name` String `json:$.resource_name`,
    `metric_name` String `json:$.metric_name`,
    `metric_value` Float64 `json:$.metric_value`,
    `region` String `json:$.region`,
    `account_id` String `json:$.account_id`,
    `environment` String `json:$.environment`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(timestamp)"
ENGINE_SORTING_KEY "timestamp, resource_id, metric_name"
```

The schema design choices, such as the ENGINE_SORTING_KEY, are made to optimize query performance, especially for time-series data. To ingest data into this data source, Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request. This API is designed for low-latency, real-time data ingestion:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=cloud_resource_metrics&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV" \
  -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
  -d '{
    "timestamp": "2023-11-15 12:30:45",
    "resource_id": "i-0abc123def456",
    "resource_type": "ec2-instance",
    "resource_name": "web-server-01",
    "metric_name": "cpu_utilization",
    "metric_value": 78.5,
    "region": "us-east-1",
    "account_id": "123456789012",
    "environment": "production"
  }'
```

In addition to the Events API, Tinybird provides other methods for data ingestion:
- For event or streaming data, the Kafka connector can be used for efficient, scalable ingestion. - For batch or file-based data, the [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) and S3 connector offer straightforward options for bulk data upload. 

## Transforming data and publishing APIs

Tinybird's pipes are used for transforming data and publishing APIs. Pipes allow for batch transformations (copies), real-time transformations ([Materialized views](https://www.tinybird.co/docs/forward/work-with-data/optimize/materialized-views?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV)), and creating API endpoints. 

### Anomaly Detection Endpoint

For example, to detect anomalies in resource metrics, we use the following SQL query in a Tinybird pipe:

```sql
DESCRIPTION >
    API endpoint to detect anomalies in resource metrics based on standard deviation

NODE get_resource_anomalies_node
SQL >
    WITH 
    resource_stats AS (
        SELECT
            resource_id,
            resource_type,
            resource_name,
            metric_name,
            avg(metric_value) as avg_value,
            stddevSamp(metric_value) as std_dev
        FROM cloud_resource_metrics
        WHERE 1=1
        ... )
    ... TYPE endpoint
```

This query calculates the average and standard deviation of metric values for each resource and identifies records where the metric value deviates significantly from the average, indicating a potential anomaly. 

### Querying Resource Metrics

To create an endpoint for querying resource metrics with flexible filtering options, the following pipe is defined:

```sql
DESCRIPTION >
    API endpoint to get resource metrics with various filtering options

NODE get_resource_metrics_node
SQL >
    SELECT
        timestamp,
        resource_id,
        resource_type,
        resource_name,
        metric_name,
        metric_value,
        region,
        account_id,
        environment
    FROM cloud_resource_metrics
    ... TYPE endpoint
```


#

## Resource Summary Statistics

To summarize statistics (avg, min, max) for resource metrics over a specified time period:

```sql
DESCRIPTION >
    API endpoint to get summary statistics for resources over a time period

NODE get_resource_summary_node
SQL >
    SELECT
        resource_id,
        resource_type,
        resource_name,
        metric_name,
        avg(metric_value) as avg_value,
        min(metric_value) as min_value,
        max(metric_value) as max_value,
        ... FROM cloud_resource_metrics
    ... TYPE endpoint
```


## Deploying to production

Deploying your project to production in Tinybird involves using the `tb --cloud deploy` command. This command deploys your data sources and [pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) to Tinybird Cloud, creating scalable, production-ready API endpoints. Tinybird manages resources as code, which facilitates integration with CI/CD pipelines and ensures that your data infrastructure is version controlled and easily deployable. For securing your APIs, Tinybird uses token-based authentication. Here's how you can call a deployed endpoint:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_resource_metrics.json?token=%24TB_ADMIN_TOKEN&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV"
```


## Conclusion

In this tutorial, you've learned how to build a real-time API for monitoring cloud resource metrics, including how to ingest data, transform it, and expose it through scalable API endpoints using Tinybird. This solution enables you to monitor your cloud resources efficiently, detect anomalies, and make data-driven decisions in real-time. [Sign up for Tinybird](https://cloud.tinybird.co/signup?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) to build and deploy your first real-time data APIs in a few minutes. Tinybird is free to start, with no time limit and no credit card required, allowing you to experience the power of real-time data processing and analytics firsthand.