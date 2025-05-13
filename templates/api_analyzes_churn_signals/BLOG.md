# Build a Customer Churn Analysis API with Tinybird

Understanding customer churn, the rate at which customers stop doing business with a company, is crucial for maintaining a healthy business. Identifying at-risk customers early on allows businesses to implement targeted retention strategies effectively. In this tutorial, we'll walk you through building an API that analyzes customer churn patterns and risk factors using Tinybird. Tinybird is a data analytics backend for software developers. You use Tinybird to build real-time analytics APIs without needing to set up or manage the underlying infrastructure. It offers a local-first development workflow, git-based deployments, resource definitions as code, and features for AI-native developers. By leveraging Tinybird's data sources and [pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV), we'll enable you to monitor customer engagement metrics, calculate churn risk scores, and analyze churn trends across different customer segments. 

## Understanding the data

Imagine your data looks like this:

```json
{"customer_id": "cust_9195", "join_date": "2024-04-22 17:21:36", "last_login_date": "2025-04-17 17:21:36", "subscription_plan": "Enterprise", "subscription_amount": 104.99, "billing_cycle": "Quarterly", "payment_status": "Canceled", "total_spend": 9195, "number_of_logins": 195, "customer_service_tickets": 5, "ticket_satisfaction_score": 1, "churn": 1, "churn_date": "2025-03-18 17:21:36", "region": "Europe", "platform": "Desktop", "timestamp": "2025-02-16 17:21:36"}
```

This data represents a customer's interaction with a platform, including their subscription details, login activity, support tickets, and churn status. To store this data in Tinybird, you create [data sources](https://www.tinybird.co/docs/forward/get-data-in/data-sources?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV). Let's start by defining a data source for our customer data:

```json
DESCRIPTION >
    Stores customer profile data and interactions with the platform

SCHEMA >
    `customer_id` String `json:$.customer_id`,
    `join_date` DateTime `json:$.join_date`,
    `last_login_date` DateTime `json:$.last_login_date`,
    `subscription_plan` String `json:$.subscription_plan`,
    `subscription_amount` Float32 `json:$.subscription_amount`,
    `billing_cycle` String `json:$.billing_cycle`,
    `payment_status` String `json:$.payment_status`,
    `total_spend` Float32 `json:$.total_spend`,
    `number_of_logins` UInt32 `json:$.number_of_logins`,
    `customer_service_tickets` UInt16 `json:$.customer_service_tickets`,
    `ticket_satisfaction_score` Float32 `json:$.ticket_satisfaction_score`,
    `churn` UInt8 `json:$.churn`,
    `churn_date` DateTime `json:$.churn_date`,
    `region` String `json:$.region`,
    `platform` String `json:$.platform`,
    `timestamp` DateTime `json:$.timestamp`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(timestamp)"
ENGINE_SORTING_KEY "customer_id, timestamp"
```

The schema design and column types are chosen to optimize query performance, with sorting keys that improve data retrieval speed. 

### Data Ingestion

Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request. This real-time nature and low latency make it ideal for our use case. ```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=customer_data&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV" \
  -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
  -d '{
    "customer_id": "cust_123456",
    ... "timestamp": "2023-06-10 14:25:00"
  }'
```

For streaming or event data, the Kafka connector is beneficial for integrating with existing Kafka pipelines. For batch or file data, the [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) and S3 connector offer efficient bulk ingestion methods. 

## Transforming data and publishing APIs

Tinybird's pipes allow for batch transformations, real-time transformations through [Materialized views](https://www.tinybird.co/docs/forward/work-with-data/optimize/materialized-views?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV), and creating API endpoints. 

### churn_risk_score.pipe

```bash
DESCRIPTION >
    Calculates a churn risk score for each customer based on various signals

... SQL >
    %
    SELECT 
        customer_id,
        ... CASE
            WHEN datediff('day', last_login_date, now()) > 30 THEN 'Inactive'
            ... END as customer_status
    FROM customer_data
... TYPE endpoint
```

This pipe calculates a churn risk score for each customer by analyzing their interaction patterns and engagement metrics. The SQL logic considers various signals, such as days since last login and customer satisfaction with support tickets, to determine the risk score. The endpoint allows querying for individual customers or all customers, providing flexibility. 

### churn_trend_analysis.pipe

```bash
DESCRIPTION >
    Shows churn trends over time with customizable time granularity

... SQL >
    %
    SELECT 
        ... FROM customer_data
... TYPE endpoint
```

This pipe helps identify periods with abnormal churn rates by showing churn trends over time. The SQL query groups data based on a customizable time granularity, allowing for deep analysis of churn patterns. 

### churn_analysis_by_segment.pipe

```bash
DESCRIPTION >
    Provides churn statistics aggregated by different segments

... SQL >
    %
    SELECT 
        ... FROM customer_data
... TYPE endpoint
```

This endpoint offers churn statistics aggregated by different customer segments, useful for pinpointing high-churn areas. 

## Deploying to production

Deploy your project to Tinybird Cloud using the CLI:

```bash
tb --cloud deploy
```

This command makes your API [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) production-ready and scalable. Tinybird manages resources as code, facilitating integration with CI/CD pipelines. Secure your APIs with token-based authentication:

```bash
curl -X GET "https://api.tinybird.co/v0/pipes/your_endpoint.json?token=your_token&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV"
```


## Conclusion

Throughout this tutorial, you've learned how to build a Customer Churn Analysis API using Tinybird. We've covered data ingestion, transforming data with pipes, and deploying scalable, secure APIs. Tinybird simplifies the development of real-time analytics APIs, allowing you to focus on creating value rather than managing infrastructure. [Sign up for Tinybird](https://cloud.tinybird.co/signup?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) to build and deploy your first real-time data APIs in a few minutes.