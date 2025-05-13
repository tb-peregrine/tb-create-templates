# Build a Support Ticket Analysis API with Tinybird

Customer support is a critical aspect of any business, with the efficient management of support tickets being paramount to ensuring customer satisfaction and operational efficiency. Analyzing trends, tracking resolution times, and understanding category distributions of support tickets can significantly enhance the support process. In this tutorial, you'll learn how to leverage Tinybird, a data analytics backend for software developers, to ingest, analyze, and expose support ticket data via API [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV). Tinybird facilitates building real-time analytics APIs by abstracting the complexity of underlying infrastructure. It uses data sources and pipes to ingest and transform data into actionable endpoints. This tutorial will guide you through setting up a Tinybird project to analyze customer support ticket trends and metrics, including resolution times, ticket volumes over time, and common ticket categories. 

## Understanding the data

Imagine your data looks like this:

```json
{"ticket_id": "TICKET-785873", "customer_id": "CUST-65873", "category": "Product", "subject": "Feature request", "description": "Customer reported: Getting an error message", "priority": "Medium", "status": "Closed", "created_at": "2025-04-29 15:51:31", "resolved_at": "2025-04-29 15:51:31", "assigned_to": "Sarah Williams", "resolution_time_mins": 463}
{"ticket_id": "TICKET-511406", "customer_id": "CUST-61406", "category": "Technical", "subject": "Setup help", "description": "Customer reported: Product is not working as expected", "priority": "High", "status": "In Progress", "created_at": "2025-04-25 18:18:31", "resolved_at": "2025-05-11 06:48:31", "assigned_to": "Jane Smith", "resolution_time_mins": 1036}
```

This data represents individual support tickets with details such as their ID, customer ID, category, priority, status, creation and resolution times, who they were assigned to, and the resolution time in minutes. To analyze this data with Tinybird, you first need to create a data source. Here's how you define the `support_tickets` data source in Tinybird:

```json
DESCRIPTION >
    Support tickets data for trend analysis

SCHEMA >
    `ticket_id` String `json:$.ticket_id`,
    `customer_id` String `json:$.customer_id`,
    `category` String `json:$.category`,
    `subject` String `json:$.subject`,
    `description` String `json:$.description`,
    `priority` String `json:$.priority`,
    `status` String `json:$.status`,
    `created_at` DateTime `json:$.created_at`,
    `resolved_at` DateTime `json:$.resolved_at`,
    `assigned_to` String `json:$.assigned_to`,
    `resolution_time_mins` Int32 `json:$.resolution_time_mins`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(created_at)"
ENGINE_SORTING_KEY "created_at, category, priority, status"
```

The choice of column types and sorting keys significantly impacts query performance. Sorting by `created_at`, `category`, `priority`, and `status` optimizes for common queries performed on this data. For data ingestion, Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request. This API is designed for low latency, real-time data ingestion. Here’s how to ingest a support ticket event:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=support_tickets&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "ticket_id": "TKT-12345",
       "customer_id": "CUST-789",
       ... }'
```

Other ingestion methods include using the Kafka connector for event/streaming data, which offers reliable, scalable ingestion, or the [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) and S3 connector for batch/file data, providing flexibility in how you upload and manage your data. 

## Transforming data and publishing APIs

Tinybird turns data transformation into a straightforward process with pipes, which can perform batch transformations, real-time transformations ([Materialized views](https://www.tinybird.co/docs/forward/work-with-data/optimize/materialized-views?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV)), and create API endpoints. 

### Materialized Views

If your project benefits from pre-aggregating data, you can define materialized views within Tinybird to optimize your data pipeline. Unfortunately, our current setup does not include a materialized view, but it's an approach worth considering for performance optimization in data-intensive scenarios. 

### API Endpoints

For the support ticket analysis, we have several endpoints. Let’s start with the `resolution_time_analysis` endpoint:

```sql
DESCRIPTION >
    Analyze resolution time for support tickets by category and priority

NODE resolution_time_node
SQL >
    SELECT
        category,
        priority,
        round(avg(resolution_time_mins), 2) AS avg_resolution_time,
        min(resolution_time_mins) AS min_resolution_time,
        max(resolution_time_mins) AS max_resolution_time,
        count() AS ticket_count
    FROM support_tickets
    WHERE status = 'resolved'
    AND created_at >= now() - interval 30 day
    AND created_at <= now()
    GROUP BY category, priority
    ORDER BY avg_resolution_time DESC

TYPE endpoint
```

This SQL query calculates the average, minimum, and maximum resolution times for resolved tickets, grouping the results by category and priority. It highlights the flexibility of Tinybird’s SQL engine to perform complex aggregations and filtering. To call this API, use:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/[pipes?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV](https://www.tinybird.co/docs/forward/work-with-data/pipes?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV)/resolution_time_analysis.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&category=billing"
```

You can replace the parameters with different values to filter the data accordingly. 

## Deploying to production

To deploy your Tinybird project, use the CLI command `tb --cloud deploy`. This command deploys all your [data sources](https://www.tinybird.co/docs/forward/get-data-in/data-sources?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) and pipes to the Tinybird Cloud, making your API endpoints production-ready and scalable. Tinybird manages resources as code, enabling integration with CI/CD pipelines for automated deployments. The use of token-based authentication ensures secure access to your APIs. Here’s an example curl command to call a deployed endpoint:

```bash
curl -X GET "https://api.tinybird.co/v0/pipes/resolution_time_analysis.json?token=%24TB_PRODUCTION_TOKEN&start_date=2023-01-01+00%3A00%3A00&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV"
```


## Conclusion

In this tutorial, you've learned how to build a support ticket analysis API using Tinybird, from ingesting data with the Events API to transforming it with pipes and deploying production-ready endpoints. Tinybird simplifies the process of working with real-time data at scale, enabling developers to focus on creating value from their data rather than managing infrastructure. [Sign up for Tinybird](https://cloud.tinybird.co/signup?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) to build and deploy your first real-time data APIs in a few minutes. Get started for free, with no time limit and no credit card required, and explore the power of real-time analytics.