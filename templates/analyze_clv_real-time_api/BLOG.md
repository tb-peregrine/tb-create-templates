# Build a Real-Time Customer Lifetime Value Analytics API with Tinybird

In the ever-evolving domain of data analytics, the ability to compute and analyze customer lifetime value (CLTV) in real-time is a game-changer for businesses aiming to enhance customer relationships and optimize their strategies. This tutorial will guide you through creating a CLTV analytics API, leveraging transaction data and customer demographics. We'll use Tinybird, a data analytics backend designed for software developers, as our primary tool. Tinybird enables you to construct real-time analytics APIs without the need to manage the underlying infrastructure. It simplifies handling large volumes of data, offering local-first development workflows, git-based deployments, and resource definitions as code, among other features tailored for AI-native developers. Our focus will be on setting up the necessary data sources in Tinybird, transforming the data through pipes to calculate CLTV, and finally, deploying a set of API [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) that provide insights on average CLTV across all customers, CLTV for specific customers, and CLTV analysis by location. 

## Understanding the data

Imagine your data looks like this:

**customer_demographics.ndjson**
```json
{"customer_id": "cust_3377", "age": 45, "location": "San Diego"}
... ```

**customer_transactions.ndjson**
```json
{"customer_id": "CUST_969", "transaction_date": "2025-04-28 16:05:45", "transaction_amount": 184751118}
... ```

This data represents customer demographics and transaction records, crucial for calculating the CLTV. The next step is to create Tinybird [data sources](https://www.tinybird.co/docs/forward/get-data-in/data-sources?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) to store this information. For the `customer_demographics` data, our `.datasource` file looks like this:

```json
DESCRIPTION >
    This datasource contains customer demographic information. SCHEMA >
    `customer_id` String `json:$.customer_id`,
    `age` UInt8 `json:$.age`,
    `location` String `json:$.location`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "location"
ENGINE_SORTING_KEY "customer_id"
```

And for `customer_transactions`:

```json
DESCRIPTION >
    This datasource contains customer transaction data. SCHEMA >
    `customer_id` String `json:$.customer_id`,
    `transaction_date` DateTime `json:$.transaction_date`,
    `transaction_amount` Float64 `json:$.transaction_amount`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(transaction_date)"
ENGINE_SORTING_KEY "customer_id, transaction_date"
```

These schemas are designed to optimize query performance, with sorting and partitioning keys chosen based on the query patterns we anticipate. Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request. This real-time nature and low latency are crucial for up-to-date analytics. Here's how you can ingest data into each datasource:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=customer_demographics&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{"customer_id":"cust123","age":35,"location":"New York"}'

curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=customer_transactions&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{"customer_id":"cust123","transaction_date":"2023-01-15 14:30:00","transaction_amount":125.50}'
```

For data that's not event/streaming in nature, Tinybird also supports batch ingestion through the [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) and connectors like Kafka and S3, broadening the range of data handling capabilities. 

## Transforming data and publishing APIs

Tinybird's pipes facilitate data transformation and API publication. Pipes can perform batch transformations, create real-time [Materialized views](https://www.tinybird.co/docs/forward/work-with-data/optimize/materialized-views?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV), and publish API endpoints. 

### Endpoints:


#

### CLTV Summary

This endpoint calculates the average CLTV across all customers:

```sql
DESCRIPTION >
    This endpoint calculates the average CLTV. NODE cltv_summary_node
SQL >
    SELECT avg(cltv) AS average_cltv
    FROM (
        SELECT
            customer_id,
            sum(transaction_amount) AS cltv
        FROM customer_transactions
        GROUP BY customer_id
    )

TYPE endpoint
```


#

### Customer CLTV

Retrieves the CLTV for a specific customer:

```sql
DESCRIPTION >
    This endpoint retrieves CLTV for a specific customer. NODE customer_cltv_node
SQL >
    SELECT
        customer_id,
        sum(transaction_amount) AS cltv
    FROM customer_transactions
    WHERE customer_id = {{String(customer_id, 'default_customer')}}
    GROUP BY customer_id

TYPE endpoint
```


#

### CLTV by Location

Calculates the average CLTV segmented by location:

```sql
DESCRIPTION >
    This endpoint calculates the average CLTV for each location. NODE cltv_by_location_node
SQL >
    SELECT
        d.location,
        avg(t.cltv) AS average_cltv
    FROM customer_demographics d
    JOIN (
        SELECT
            customer_id,
            sum(transaction_amount) AS cltv
        FROM customer_transactions
        GROUP BY customer_id
    ) t ON d.customer_id = t.customer_id
    GROUP BY d.location

TYPE endpoint
```

These examples show how Tinybird transforms data into actionable API endpoints, with SQL logic that's easy to understand and customize. 

## Deploying to production

Deploying your project to Tinybird Cloud is straightforward using the `tb --cloud deploy` command. This process creates production-ready, scalable API endpoints. Tinybird handles resources as code, which means integrating with CI/CD pipelines is seamless, and version control is built into the development process. Here's how you might call one of the deployed endpoints:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/[pipes?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV](https://www.tinybird.co/docs/forward/work-with-data/pipes?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV)/cltv_summary.json?token=$TB_ADMIN_TOKEN"
```

API security is handled through token-based authentication, ensuring that your data remains secure while being accessible to authorized users. 

## Conclusion

Throughout this tutorial, we've covered setting up data sources, transforming data, and publishing real-time analytics APIs with Tinybird. This process allows for the efficient analysis of customer lifetime value, leveraging real-time data streaming, optimized query performance, and scalable API endpoints. [Sign up for Tinybird](https://cloud.tinybird.co/signup?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) to build and deploy your first real-time data APIs in a few minutes. Tinybird is free to start, with no time limit and no credit card required, making it an excellent option for developers looking to create data-centric applications and services.