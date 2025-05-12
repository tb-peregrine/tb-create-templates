# Build a Real-Time Inventory Tracking API with Tinybird

Keeping accurate track of inventory levels across multiple warehouses in real-time can be a daunting task for any organization. Traditional approaches often involve batch processing which can lead to data latency, impacting decision-making and operational efficiency. In this tutorial, we'll walk through how to build a real-time inventory tracking API using Tinybird. This API will enable you to query current stock levels, view recent inventory movements, and get summary statistics for each warehouse in real-time. Tinybird is a data analytics backend for software developers. You use Tinybird to build real-time analytics APIs without needing to set up or manage the underlying infrastructure. Tinybird offers a local-first development workflows, git-based deployments, resource definitions as code, and features for AI-native developers. By leveraging Tinybird's data sources and [pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes), you can ingest, transform, and expose your inventory data through high-performance APIs in a matter of minutes. Let's dive into the technical steps to implement this solution. ## Understanding the data

Imagine your data looks like this:

```json
{"product_id": "P1851", "warehouse_id": "WH2", "quantity": 851, "timestamp": "2025-04-21 14:28:00", "operation": "transfer", "batch_id": "B17851", "unit_price": 931}
{"product_id": "P1581", "warehouse_id": "WH2", "quantity": 581, "timestamp": "2025-05-01 12:28:00", "operation": "remove", "batch_id": "B12581", "unit_price": 981}
... ```

This data represents inventory movements across different warehouses, including the product ID, warehouse ID, the quantity of items moved, the timestamp of the operation, and the operation type (e.g., add, remove, transfer). To store this data in Tinybird, you first need to create a data source. Here's how the `inventory.datasource` file looks:

```json
DESCRIPTION >
    Real-time inventory data from multiple warehouses

SCHEMA >
    `product_id` String `json:$.product_id`,
    `warehouse_id` String `json:$.warehouse_id`,
    `quantity` Int32 `json:$.quantity`,
    `timestamp` DateTime `json:$.timestamp`,
    `operation` String `json:$.operation`,
    `batch_id` String `json:$.batch_id`,
    `unit_price` Float32 `json:$.unit_price`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(timestamp)"
ENGINE_SORTING_KEY "warehouse_id, product_id, timestamp"
```

This schema is designed to optimize query performance by sorting data by `warehouse_id`, `product_id`, and `timestamp`. For data ingestion, Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request. It provides low latency and real-time ingestion capabilities. Here's how you can send data to your `inventory` data source:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=inventory" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{"product_id":"product123","warehouse_id":"warehouseA","quantity":10,"timestamp":"2024-01-01 12:00:00","operation":"add","batch_id":"batch001","unit_price":25.50}'
```

Other ingestion methods include the Kafka connector for event/streaming data, which offers built-in scalability and fault tolerance, and the [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api) and S3 connector for batch/file data, allowing for efficient bulk data uploads. ## Transforming data and publishing APIs

With Tinybird, transforming data and publishing APIs is done through pipes. Pipes allow for batch transformations, real-time transformations, and the creation of API [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints). ### Endpoint: warehouse_summary

This endpoint provides a summary of inventory by warehouse. It includes the number of unique products, total items, and the total inventory value. Here's the complete pipe code:

```sql
DESCRIPTION >
    Get inventory summary by warehouse

NODE warehouse_summary_node
SQL >
    SELECT 
        warehouse_id,
        count(distinct product_id) as unique_products,
        sum(case when operation = 'add' then quantity
                 when operation = 'remove' then -quantity
                 else 0 end) as total_items,
        sum(case when operation = 'add' then quantity * unit_price
                 when operation = 'remove' then -quantity * unit_price
                 else 0 end) as inventory_value
    FROM inventory
    WHERE 1=1
    {% if defined(warehouse_id) %}
        AND warehouse_id = {{String(warehouse_id, '')}}
    {% end %}
    GROUP BY warehouse_id
    ORDER BY warehouse_id

TYPE endpoint
```

This SQL leverages Tinybird's templating logic to make the API flexible, allowing optional filtering by `warehouse_id`. ### Endpoint: inventory_current

This endpoint returns the current stock level for a specific product in a specific warehouse. Notice how the SQL logic aggregates quantities by operation type:

```sql
DESCRIPTION >
    Get current inventory levels by product and warehouse

NODE inventory_current_node
SQL >
    SELECT 
        product_id,
        warehouse_id,
        sum(case when operation = 'add' then quantity
                 when operation = 'remove' then -quantity
                 else 0 end) as current_stock,
        max(timestamp) as last_updated
    FROM inventory
    WHERE 1=1
    {% if defined(product_id) %}
        AND product_id = {{String(product_id, '')}}
    {% end %}
    {% if defined(warehouse_id) %}
        AND warehouse_id = {{String(warehouse_id, '')}}
    {% end %}
    GROUP BY product_id, warehouse_id
    HAVING current_stock > 0
    ORDER BY warehouse_id, product_id

TYPE endpoint
```


### Endpoint: inventory_movements

This pipe provides a detailed log of inventory movements within a specified date range, demonstrating the use of date parameters and a limit to control the output:

```sql
DESCRIPTION >
    Get inventory movements within a date range

NODE inventory_movements_node
SQL >
    SELECT 
        product_id,
        warehouse_id,
        operation,
        quantity,
        timestamp,
        batch_id
    FROM inventory
    WHERE 1=1
    {% if defined(product_id) %}
        AND product_id = {{String(product_id, '')}}
    {% end %}
    {% if defined(warehouse_id) %}
        AND warehouse_id = {{String(warehouse_id, '')}}
    {% end %}
    {%if not defined(start_date)%}
    AND timestamp >= now() - interval 7 day
    {%else%}
    AND timestamp >= {{DateTime(start_date)}}
    {%end%}
    {%if not defined(end_date)%}
    AND timestamp <= now()
    {%else%}
    AND timestamp <= {{DateTime(end_date)}}
    {%end%}
    ORDER BY timestamp DESC
    {% if defined(limit) %}
    LIMIT {{Int32(limit, 100)}}
    {% else %}
    LIMIT 100
    {% end %}

TYPE endpoint
```


## Deploying to production

Deploying your project to Tinybird Cloud is straightforward with the `tb --cloud deploy` command. This command deploys your [data sources](https://www.tinybird.co/docs/forward/get-data-in/data-sources) and pipes, creating production-ready, scalable API endpoints. Tinybird manages resources as code, enabling integration with CI/CD pipelines for seamless deployment workflows. Here's an example of how to call a deployed endpoint:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/inventory_current.json?token=$TB_ADMIN_TOKEN&product_id=product123&warehouse_id=warehouseA"
```

Token-based authentication ensures your APIs are secure and only accessible to authorized users. ## Conclusion

In this tutorial, we've covered how to build a real-time inventory tracking API using Tinybird. By following these steps, you've seen how to ingest data in real-time, transform it through pipes, and publish flexible, scalable APIs. Using Tinybird for this use case brings significant technical benefits, including the ability to process and analyze large volumes of data in real-time, the flexibility to create dynamic APIs, and the ease of deploying and managing your data infrastructure as code. [Sign up for Tinybird](https://cloud.tinybird.co/signup) to build and deploy your first real-time data APIs in a few minutes.