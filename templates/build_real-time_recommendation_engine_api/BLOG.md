# Build a Real-Time Product Recommendation Engine with Tinybird

Creating a product recommendation engine that operates in real-time can significantly enhance user experience by providing personalized suggestions based on their interactions. This tutorial will guide you through building such an API using Tinybird. Tinybird is a data analytics backend for software developers. You use Tinybird to build real-time analytics APIs without needing to set up or manage the underlying infrastructure. Tinybird offers a local-first development workflow, git-based deployments, resource definitions as code, and features for AI-native developers. By leveraging Tinybird's data sources and [pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes), you can implement a recommendation engine that responds dynamically to user behavior. This solution captures user interactions with products—like views, clicks, and purchases—and uses this data to generate personalized product recommendations. We will start by understanding how to model and ingest this interaction data into Tinybird. Then, we'll transform this data and publish an API endpoint that serves real-time recommendations. Finally, we'll cover how to deploy this solution to production with Tinybird. ## Understanding the data

Imagine your data looks like this:
```json
{"user_id": "user_413", "product_id": "prod_413", "interaction_type": "favorite", "timestamp": "2025-04-26 12:43:38", "session_id": "session_413", "value": 266338041300}
{"user_id": "user_5", "product_id": "prod_5", "interaction_type": "view", "timestamp": "2025-05-02 19:07:06", "session_id": "session_2005", "value": 52184700500}
... ```
This sample data from `user_interactions.ndjson` represents various user interactions with products, capturing the type of interaction, when it occurred, and other related details. To store this data in Tinybird, we create a data source with the following schema:
```json
DESCRIPTION >
    Stores user interactions with products such as views, clicks, purchases

SCHEMA >
    `user_id` String `json:$.user_id`,
    `product_id` String `json:$.product_id`,
    `interaction_type` String `json:$.interaction_type`,
    `timestamp` DateTime `json:$.timestamp`,
    `session_id` String `json:$.session_id`,
    `value` Float32 `json:$.value`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(timestamp)"
ENGINE_SORTING_KEY "user_id, product_id, timestamp"
```
This schema is designed to efficiently query interactions by user and product, with a focus on performance. Sorting keys are chosen to optimize query speed for common access patterns, such as retrieving all interactions by a specific user. For data ingestion, Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request, ensuring low-latency, real-time data availability. Here's how you can ingest data:
```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=user_interactions" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
         "user_id": "user123",
         "product_id": "prod456",
         "interaction_type": "view",
         "timestamp": "2023-05-22 10:30:45",
         "session_id": "sess789",
         "value": 1.0
     }'
```
Beyond the Events API, you might consider the Kafka connector for streaming data or the [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api) and S3 connector for batch data ingestion. ## Transforming data and publishing APIs

Tinybird transforms data and publishes APIs through pipes. Pipes can perform batch transformations, act as [Materialized views](https://www.tinybird.co/docs/forward/work-with-data/optimize/materialized-views), and ultimately serve as the backbone for API endpoints. For our recommendation engine, we have the following endpoint in `user_based_recommendations.pipe`:
```sql
DESCRIPTION >
    Generates product recommendations based on user interactions

NODE user_based_recommendations_node
SQL >
    SELECT 
        product_id,
        count() AS popularity_score,
        arrayStringConcat(groupArray(DISTINCT user_id), ',') AS users_who_interacted
    FROM user_interactions
    WHERE {% if defined(user_id) %}user_id != {{String(user_id, '')}} AND{% end %}
          interaction_type IN ('purchase', 'view', 'click')
    GROUP BY product_id
    ORDER BY popularity_score DESC
    LIMIT {{Int32(limit, 10)}}

TYPE endpoint
```
This pipe aggregates user interactions to calculate popularity scores for products, optionally excluding products already interacted with by a specific user. Query parameters make this API flexible, allowing consumers to specify a user ID and a limit for the number of recommendations. Example API calls:
```bash
# General recommendations
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_based_recommendations.json?token=$TB_ADMIN_TOKEN&limit=5"


# Recommendations excluding specific user interactions
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_based_recommendations.json?token=$TB_ADMIN_TOKEN&user_id=user123&limit=10"
```


## Deploying to production

Deploy your project to Tinybird Cloud with `tb --cloud deploy`. This command creates production-ready, scalable API [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints) with minimal effort. Tinybird manages resources as code, facilitating integration with CI/CD pipelines and ensuring a seamless development-to-production workflow. For security, Tinybird uses token-based authentication to protect your endpoints. Here's an example of how to call your deployed endpoint:
```bash
curl "https://api.tinybird.co/v0/pipes/user_based_recommendations.json?token=YOUR_READ_TOKEN&limit=10"
```


## Conclusion

In this tutorial, we've built a real-time product recommendation engine by leveraging Tinybird's [data sources](https://www.tinybird.co/docs/forward/get-data-in/data-sources) and pipes. This solution streams user interaction data, processes it to identify popular and relevant products, and serves personalized recommendations through a REST API. Tinybird simplifies the complex data engineering tasks, allowing you to focus on creating value from your data. [Sign up for Tinybird](https://cloud.tinybird.co/signup) to build and deploy your first real-time data APIs in a few minutes.