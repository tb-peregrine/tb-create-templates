# Build a Real-Time Customer Feedback Analysis API with Tinybird

In this tutorial, we'll guide you through building a real-time API to ingest, process, and analyze customer feedback. Understanding customer sentiment and product performance is crucial for businesses to make informed decisions and improve their offerings. By leveraging Tinybird, we will create an API that enables real-time tracking of customer feedback across various products, focusing on sentiment analysis, ratings, and identifying emerging trends. Tinybird is a data analytics backend for software developers. You use Tinybird to build real-time analytics APIs without needing to set up or manage the underlying infrastructure. Tinybird offers a local-first development workflow, git-based deployments, resource definitions as code, and features for AI-native developers. This tutorial will explore how Tinybird's data sources and pipes can be utilized to ingest raw customer feedback, transform this data, and publish [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) for querying this information in real-time. 

## Understanding the data

Imagine your data looks like this:

```json
{"feedback_id": "fb_6577", "customer_id": "cust_577", "product_id": "prod_77", "rating": 3, "feedback_text": "Shipping was too slow", "sentiment": "negative", "tags": ["quality"], "timestamp": "2025-04-25 23:07:53"}
{"feedback_id": "fb_4020", "customer_id": "cust_20", "product_id": "prod_20", "rating": 1, "feedback_text": "Great product!", "sentiment": "neutral", "tags": [], "timestamp": "2025-04-28 19:37:10"}
... ```

This data represents individual feedback events from customers, including a unique feedback ID, customer ID, product ID, rating, feedback text, sentiment analysis results (positive, neutral, negative), associated tags, and a timestamp. To store this data, we create a Tinybird datasource named `feedback_events` with the following schema:

```json
DESCRIPTION >
    Raw customer feedback events ingested in real-time

SCHEMA >
    `feedback_id` String `json:$.feedback_id`,
    `customer_id` String `json:$.customer_id`,
    `product_id` String `json:$.product_id`,
    `rating` Int32 `json:$.rating`,
    `feedback_text` String `json:$.feedback_text`,
    `sentiment` String `json:$.sentiment`,
    `tags` Array(String) `json:$.tags[:]`,
    `timestamp` DateTime `json:$.timestamp`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(timestamp)"
ENGINE_SORTING_KEY "timestamp, product_id, customer_id"
```

The schema design choices, such as sorting keys, significantly impact query performance by optimizing how data is stored and accessed. To ingest data into this datasource, we leverage Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV):

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=feedback_events&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{...}'
```

Tinybird's Events API allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request. It provides real-time ingestion with low latency, ideal for live customer feedback scenarios. Other ingestion methods include the Kafka connector for event/streaming data and the [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) and S3 connector for batch/file data. 

## Transforming data and publishing APIs

Pipes in Tinybird facilitate data transformation and the publication of APIs. They support batch transformations (copies), real-time transformations ([Materialized views](https://www.tinybird.co/docs/forward/work-with-data/optimize/materialized-views?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV)), and creating API endpoints. 

### Aggregating Feedback

The `get_feedback_summary` endpoint aggregates feedback statistics, offering optional filtering by date range and product ID:

```sql
DESCRIPTION >
    Endpoint to get aggregated feedback statistics with optional filtering by date range

NODE get_feedback_summary_node
SQL >
    %
    SELECT 
        product_id,
        count() AS feedback_count,
        avg(rating) AS average_rating,
        countIf(sentiment = 'positive') AS positive_count,
        countIf(sentiment = 'neutral') AS neutral_count,
        countIf(sentiment = 'negative') AS negative_count
    FROM feedback_events
    ... TYPE endpoint
```

This SQL logic calculates the average rating and counts feedback by sentiment, demonstrating how query parameters can make the API flexible. 

### Identifying Trending Tags

Similarly, the `get_trending_tags` endpoint identifies trending tags within customer feedback:

```sql
DESCRIPTION >
    Endpoint to identify trending tags in customer feedback with optional filtering

NODE get_trending_tags_node
SQL >
    %
    WITH 
    ... ORDER BY tag_count DESC
    LIMIT {{Int(limit, 20)}}

TYPE endpoint
```

The SQL query extracts tags, counts them, and calculates their average rating, showcasing the use of materialized views to optimize data pipelines. 

### Detailed Feedback Retrieval

The `get_feedback_by_product` endpoint retrieves detailed feedback for a specific product:

```sql
DESCRIPTION >
    Endpoint to retrieve feedback for a specific product with optional filtering by rating and date range

NODE get_feedback_by_product_node
SQL >
    %
    SELECT 
        ... ORDER BY timestamp DESC
    LIMIT {{Int(limit, 100)}}

TYPE endpoint
```

This pipe uses templating logic to enable flexible filtering and sorting of feedback data, providing valuable insights into customer sentiment for specific products. 

## Deploying to production

To deploy these resources to Tinybird Cloud, use the command:

```bash
tb --cloud deploy
```

This command deploys your project, creating production-ready, scalable API endpoints. Tinybird manages resources as code, allowing for seamless integration with CI/CD pipelines. Securing these APIs involves token-based authentication, ensuring that access is controlled and data remains secure. Example API call:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/[pipes?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV](https://www.tinybird.co/docs/forward/work-with-data/pipes?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV)/get_feedback_summary.json?token=$TB_ADMIN_TOKEN&..."
```


## Conclusion

In this tutorial, we've walked through creating a real-time API for customer feedback analysis using Tinybird. We covered how to ingest and store raw feedback data, transform it to derive meaningful metrics, and publish scalable, secure endpoints for querying this information in real-time. Tinybird simplifies the process of building and deploying real-time analytics APIs, handling infrastructure management so you can focus on delivering value from your data. [Sign up for Tinybird](https://cloud.tinybird.co/signup?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) to build and deploy your first real-time data APIs in a few minutes.