# Build a Real-Time E-commerce Price Change Monitoring API with Tinybird

E-commerce platforms are dynamic environments where product prices change frequently due to promotions, stock levels, and competitive pricing strategies. Tracking these changes in real-time can provide valuable insights into market trends, competitor behavior, and consumer demand. However, managing streaming data and providing real-time analytics can be technically challenging. This tutorial guides you through creating an API that monitors product price changes in e-commerce platforms using Tinybird. Tinybird is a data analytics backend for software developers. You use Tinybird to build real-time analytics APIs without needing to set up or manage the underlying infrastructure. Tinybird offers a local-first development workflows, git-based deployments, resource definitions as code, and features for AI-native developers. By leveraging Tinybird's data sources and [pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes), you can ingest, transform, and query large volumes of data in real-time, making it an ideal solution for monitoring e-commerce price changes. ## Understanding the data

Imagine your data looks like this:

```json
{"product_id": "prod_8258", "product_name": "Product 258", "category": "Home", "merchant_id": "merchant_58", "old_price": 438, "new_price": 438, "price_change": 0, "price_change_percentage": 0, "currency": "CAD", "change_timestamp": "2025-05-04 17:09:41", "event_timestamp": "2025-05-12 17:09:41"}
{"product_id": "prod_7000", "product_name": "Product 0", "category": "Electronics", "merchant_id": "merchant_0", "old_price": 730, "new_price": 730, "price_change": 0, "price_change_percentage": 0, "currency": "USD", "change_timestamp": "2025-05-12 17:09:41", "event_timestamp": "2025-05-12 17:09:41"}
... ```

This data represents price changes for various products across different categories and merchants. Each record contains product details, the old and new prices, the change in price, the percentage change, and the timestamps for the change and the event recording. To store this data in Tinybird, create a data source with the following schema:

```json
DESCRIPTION >
    Captures price changes for products in e-commerce

SCHEMA >
    `product_id` String `json:$.product_id`,
    `product_name` String `json:$.product_name`,
    `category` String `json:$.category`,
    `merchant_id` String `json:$.merchant_id`,
    `old_price` Float64 `json:$.old_price`,
    `new_price` Float64 `json:$.new_price`,
    `price_change` Float64 `json:$.price_change`,
    `price_change_percentage` Float64 `json:$.price_change_percentage`,
    `currency` String `json:$.currency`,
    `change_timestamp` DateTime `json:$.change_timestamp`,
    `event_timestamp` DateTime `json:$.event_timestamp`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(change_timestamp)"
ENGINE_SORTING_KEY "category, merchant_id, product_id, change_timestamp"
```

The schema design choices, including sorting keys, optimize query performance by organizing data efficiently. To ingest data, Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request. This method is ideal for real-time data collection, providing low latency. Here is a sample ingestion code:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=product_price_changes" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "product_id": "ABC123",
       ... }'
```

For event/streaming data, the Kafka connector offers benefits like scalable ingestion from Kafka topics. For batch/file data, the [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api) and S3 connector facilitate efficient data uploads and synchronization. ## Transforming data and publishing APIs

Tinybird transforms data through pipes, which can perform batch transformations, real-time transformations ([Materialized views](https://www.tinybird.co/docs/forward/work-with-data/optimize/materialized-views)), and create API endpoints. ### Materialized Views

If your project includes materialized views, these optimize your data pipeline by pre-aggregating data, thus improving query performance and reducing response times. ### Endpoint pipes

For each endpoint pipe, the complete SQL query is crucial for understanding the logic behind the API. For example, the `price_changes_by_product` endpoint looks like this:

```sql
DESCRIPTION >
    Get price change history for a specific product

NODE price_changes_by_product_node
SQL >
    SELECT 
        product_id,
        product_name,
        category,
        old_price,
        new_price,
        price_change,
        price_change_percentage,
        currency,
        change_timestamp
    FROM product_price_changes
    WHERE product_id = {{String(product_id, "ABC123")}}
    ORDER BY change_timestamp DESC
    LIMIT {{UInt16(limit, 10)}}

TYPE endpoint
```

This query retrieves the price change history for a given product, highlighting how query parameters like `product_id` and `limit` make the API flexible. Example API call:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/price_changes_by_product.json?product_id=ABC123&limit=5&token=$TB_ADMIN_TOKEN"
```


## Deploying to production

Deploy your project to Tinybird Cloud with the following command:

```bash
tb --cloud deploy
```

This creates production-ready, scalable API [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints). Tinybird manages resources as code, integrating seamlessly with CI/CD pipelines. Secure your APIs with token-based authentication. Example curl command to call the deployed endpoint:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/price_changes_by_product.json?product_id=ABC123&limit=5&token=$TB_ADMIN_TOKEN"
```


## Conclusion

In this tutorial, you've learned how to build a real-time API for monitoring e-commerce price changes using Tinybird. By following these steps, you've seen how to ingest, transform, and query large volumes of data, creating efficient, scalable APIs for real-time analytics. Using Tinybird for this use case offers significant technical benefits, including the ability to handle streaming data, real-time transformations, and the ease of deploying and securing your APIs. [Sign up for Tinybird](https://cloud.tinybird.co/signup) to build and deploy your first real-time data APIs in a few minutes.