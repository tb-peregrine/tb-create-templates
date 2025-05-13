# Build a Real-time Inventory Management API with Tinybird

Managing inventory in real-time is crucial for businesses to keep pace with demand, minimize stockouts, and reduce excess inventory. At the core of such a system is the ability to track inventory items, monitor stock levels, and record transactions efficiently. This tutorial demonstrates how to build a real-time inventory management API that offers these capabilities using Tinybird. Tinybird is a data analytics backend for software developers. You use Tinybird to build real-time analytics APIs without needing to set up or manage the underlying infrastructure. Tinybird offers a local-first development workflows, git-based deployments, resource definitions as code, and features for AI-native developers. By leveraging Tinybird's data sources and [pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV), this tutorial will guide you through creating a scalable API capable of serving real-time inventory data. 

## Understanding the data

Imagine your data looks like this:

```json
{"item_id": "item_915", "item_name": "Product 15", "category": "Electronics", "current_stock": 915, "min_stock_level": 25, "max_stock_level": 515, "unit_price": 305, "supplier_id": "supplier_15", "warehouse_id": "wh_0", "last_updated": "2025-04-14 20:49:33"}
{"item_id": "item_965", "item_name": "Product 65", "category": "Electronics", "current_stock": 965, "min_stock_level": 25, "max_stock_level": 565, "unit_price": 885, "supplier_id": "supplier_5", "warehouse_id": "wh_0", "last_updated": "2025-05-04 20:49:33"}
...
```

This data represents inventory items, including details like item ID, name, category, current stock levels, minimum and maximum stock levels, unit pricing, supplier ID, and warehouse ID. To store this data in Tinybird, you'll first create [data sources](https://www.tinybird.co/docs/forward/get-data-in/data-sources?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV). A data source in Tinybird is similar to a table in a traditional database, designed for high-speed, real-time data analytics. To create a data source for inventory items, you can define it as follows:

```json
DESCRIPTION >
    Stores inventory items with their current stock levels and other details

SCHEMA >
    `item_id` String `json:$.item_id`,
    `item_name` String `json:$.item_name`,
    `category` String `json:$.category`,
    `current_stock` Int32 `json:$.current_stock`,
    `min_stock_level` Int32 `json:$.min_stock_level`,
    `max_stock_level` Int32 `json:$.max_stock_level`,
    `unit_price` Float32 `json:$.unit_price`,
    `supplier_id` String `json:$.supplier_id`,
    `warehouse_id` String `json:$.warehouse_id`,
    `last_updated` DateTime `json:$.last_updated`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(last_updated)"
ENGINE_SORTING_KEY "item_id, warehouse_id, last_updated"
```

This schema design considers real-time analytics' needs, with careful selection of column types and sorting keys to optimize query performance. 

#

## Ingesting data into Tinybird

Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request. This feature is crucial for real-time data ingestion, providing low latency and ensuring your data is always up to date. For instance, to ingest inventory items, you might use the following command:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=inventory_items&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
         "item_id": "ITM001",
         "item_name": "Wireless Headphones",
         "category": "Electronics",
         "current_stock": 45,
         ... }'
```

Beyond the Events API, Tinybird also supports other ingestion methods:
- For event/streaming data: The Kafka connector can be beneficial for integrating with existing Kafka streams. - For batch/file data: The [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) and S3 connector facilitate batch ingestion from various sources. 

## Transforming data and publishing APIs

Transforming data in Tinybird is accomplished through pipes. Pipes can perform batch transformations, act as real-time [Materialized views](https://www.tinybird.co/docs/forward/work-with-data/optimize/materialized-views?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV), and create API endpoints. 

#

## Creating API Endpoints

Let's dive into creating an API endpoint that retrieves detailed information about a specific inventory item, including its recent transactions. Here's how you can define this endpoint using Tinybird pipes:

```sql
DESCRIPTION >
    Endpoint to get detailed information about a specific inventory item including recent transactions

NODE get_inventory_details_node
SQL >
    %
    WITH item AS (
        SELECT 
            item_id,
            item_name,
            category,
            current_stock,
            min_stock_level,
            max_stock_level,
            unit_price,
            supplier_id,
            warehouse_id,
            last_updated,
            current_stock <= min_stock_level AS is_low_stock
        FROM inventory_items
        WHERE item_id = {{String(item_id, '')}}
        ... )
    SELECT 
        i.*,
        t.transaction_id,
        t.transaction_type,
        t.quantity,
        t.transaction_date,
        t.user_id,
        t.reference_id,
        t.notes
    ... TYPE endpoint
```

This pipe SQL joins inventory items with their transactions, providing a detailed view of an item's inventory movements. By utilizing templating and query parameters, this API becomes flexible, allowing clients to specify item IDs, warehouse IDs, and other filters. 

#

## Example API Calls

Here are some examples of how to call the APIs you've just created:

```bash
# Get details for a specific item
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_inventory_details.json?token=%24TB_ADMIN_TOKEN&item_id=ITM001&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV"
```

These API calls demonstrate the flexibility and power of Tinybird pipes to serve real-time data based on query parameters. 

## Deploying to production

To deploy your inventory management APIs to the Tinybird Cloud, use the Tinybird CLI with the following command:

```bash
tb --cloud deploy
```

This command creates production-ready, scalable API [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV). Tinybird treats your resources as code, enabling integration with CI/CD pipelines and ensuring your APIs are secure with token-based authentication. Example curl command to call your deployed endpoints:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_inventory_items.json?token=%24TB_ADMIN_TOKEN&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV"
```

## Conclusion

Throughout this tutorial, you've learned how to build a real-time inventory management API using Tinybird. We covered understanding your data, creating data sources, transforming data, publishing APIs, and deploying them to production. Tinybird's capabilities enable developers to create scalable, real-time analytics APIs efficiently. [Sign up for Tinybird](https://cloud.tinybird.co/signup?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) to build and deploy your first real-time data APIs in a few minutes.