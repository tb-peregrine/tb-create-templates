# Build a Real-Time Inventory Tracking System with Tinybird

Keeping track of inventory in real-time is a critical aspect of business operations for many companies. From retail to manufacturing, the ability to monitor stock levels, track movements, and quickly access inventory details can significantly enhance operational efficiency and decision-making. This tutorial guides you through building a real-time inventory tracking system API using Tinybird, a data analytics backend for software developers. Tinybird enables you to build real-time analytics APIs without needing to set up or manage the underlying infrastructure. It offers a local-first development workflow, git-based deployments, resource definitions as code, and features for AI-native developers. The API you'll build provides functionalities to track inventory items with their current stock levels, record all inventory transactions (additions, removals, adjustments), retrieve detailed information about specific items, view inventory summaries by category and location, and identify low stock items that need replenishment. By leveraging Tinybird's data sources and [pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV), you'll see how to ingest, transform, and expose your inventory data through scalable, real-time APIs. 

## Understanding the data

Imagine your data looks like this:

```json
{"item_id": "item_6396", "item_name": "Product 396", "category": "Clothing", "quantity": 396, "location": "Warehouse B", "last_updated": "2025-05-06 16:31:27", "low_stock_threshold": 56, "unit_price": 676}
{"item_id": "item_5406", "item_name": "Product 406", "category": "Clothing", "quantity": 406, "location": "Warehouse B", "last_updated": "2025-04-16 16:31:27", "low_stock_threshold": 16, "unit_price": 486}
```

This data represents inventory items, each with details like item ID, name, category, quantity available, location, last updated timestamp, low stock threshold, and unit price. For this tutorial, you will store this data in Tinybird [data sources](https://www.tinybird.co/docs/forward/get-data-in/data-sources?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV). To create a Tinybird data source for inventory items, you would define it like so:

```json
DESCRIPTION >
    Stores inventory items with their current stock levels and other details

SCHEMA >
    `item_id` String `json:$.item_id`,
    `item_name` String `json:$.item_name`,
    `category` String `json:$.category`,
    `quantity` Int32 `json:$.quantity`,
    `location` String `json:$.location`,
    `last_updated` DateTime `json:$.last_updated`,
    `low_stock_threshold` Int32 `json:$.low_stock_threshold`,
    `unit_price` Float32 `json:$.unit_price`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(last_updated)"
ENGINE_SORTING_KEY "category, item_id"
```

Schema design choices and column types are tailored to efficiently query and manage inventory data, with sorting keys to optimize query performance. For data ingestion, Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request, offering real-time ingestion with low latency. Here's how you might ingest an inventory item:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=inventory_items&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV" \
  -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
  -d '{
    "item_id": "ITM001",
    "item_name": "Widget A",
    "category": "Widgets",
    "quantity": 120,
    "location": "Warehouse 1",
    "last_updated": "2023-10-15 14:30:00",
    "low_stock_threshold": 50,
    "unit_price": 29.99
  }'
```

For batch/file data, you can use the [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) or S3 connector, and for event/streaming data, the Kafka connector is beneficial for integrating with existing data pipelines. 

## Transforming data and publishing APIs

Transformations and API publishing in Tinybird are handled through pipes. Pipes can perform batch transformations, real-time transformations, and create API [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV). This section will focus on creating endpoint pipes to expose our inventory data through APIs. 

### Get Inventory Items Endpoint

To retrieve inventory items, possibly filtered by category, location, and low stock status, you define a pipe like this:

```sql
DESCRIPTION >
    API endpoint to get inventory items, with optional filtering by category, location, and low stock items

NODE get_inventory_items_node
SQL >
    %
    SELECT
        item_id,
        item_name,
        category,
        quantity,
        location,
        last_updated,
        low_stock_threshold,
        unit_price,
        quantity <= low_stock_threshold AS is_low_stock
    FROM inventory_items
    WHERE 1=1
    {% if defined(category) %}
        AND category = {{String(category, '')}}
    {% end %}
    {% if defined(location) %}
        AND location = {{String(location, '')}}
    {% end %}
    {% if defined(low_stock_only) %}
        AND quantity <= low_stock_threshold
    {% end %}
    ORDER BY 
    {% if defined(sort_by) %}
        {{String(sort_by, 'item_name')}}
    {% else %}
        item_name
    {% end %}
    {% if defined(limit) %}
    LIMIT {{Int32(limit, 100)}}
    {% else %}
    LIMIT 100
    {% end %}

TYPE endpoint
```

This pipe's SQL logic demonstrates how you can leverage SQL templates and parameters to make your API flexible and powerful. For example, fetching low stock items in a specific location might look like this:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_inventory_items.json?token=%24TB_ADMIN_TOKEN&location=Warehouse+1&low_stock_only=1&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV"
```


#

## Detailed Item Information Endpoint

To get detailed information about a specific inventory item, including recent transactions, the `get_item_details` pipe is defined as follows:

```sql
DESCRIPTION >
    API endpoint to get detailed information about a specific inventory item, including recent transactions

NODE get_item_details_node
SQL >
    %
    WITH recent_transactions AS (
        SELECT
            transaction_id,
            transaction_type,
            quantity,
            timestamp,
            location,
            user_id,
            notes
        FROM inventory_transactions
        WHERE item_id = {{String(item_id, '')}}
        ORDER BY timestamp DESC
        LIMIT {{Int32(transaction_limit, 10)}}
    )
    
    SELECT
        i.item_id,
        i.item_name,
        i.category,
        i.quantity,
        i.location,
        i.last_updated,
        i.low_stock_threshold,
        i.unit_price,
        i.quantity <= i.low_stock_threshold AS is_low_stock,
        groupArray(recent_transactions.transaction_id) AS transaction_ids,
        groupArray(recent_transactions.transaction_type) AS transaction_types,
        groupArray(recent_transactions.quantity) AS transaction_quantities,
        groupArray(recent_transactions.timestamp) AS transaction_timestamps,
        groupArray(recent_transactions.user_id) AS transaction_users
    FROM inventory_items AS i
    LEFT JOIN recent_transactions ON 1=1
    WHERE i.item_id = {{String(item_id, '')}}
    GROUP BY
        i.item_id,
        i.item_name,
        i.category,
        i.quantity,
        i.location,
        i.last_updated,
        i.low_stock_threshold,
        i.unit_price

TYPE endpoint
```

This pipe highlights the use of SQL to perform complex data transformations and aggregations, turning raw data into meaningful API responses. 

## Deploying to production

To deploy your project to Tinybird Cloud, use the command:

```bash
tb --cloud deploy
```

This command creates production-ready, scalable API endpoints from your pipes. Tinybird manages resources as code, allowing you to integrate with CI/CD pipelines and ensuring your data APIs are version-controlled and easily deployable. Securing your APIs is straightforward with token-based authentication, ensuring only authorized users can access your endpoints. Example API call:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_inventory_items.json?token=%24TB_ADMIN_TOKEN&limit=50&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV"
```


## Conclusion

In this tutorial, you've learned how to build a real-time inventory tracking system API with Tinybird. You've seen how to ingest data, transform it, and publish it through scalable, real-time APIs. This approach not only simplifies the management of inventory data but also optimizes performance and security. The technical benefits of using Tinybird for this use case are clear: real-time data processing, flexible API endpoints, and the ability to deploy and scale without managing infrastructure. [Sign up for Tinybird](https://cloud.tinybird.co/signup?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) to build and deploy your first real-time data APIs in a few minutes. Get started now to experience the ease of transforming and exposing your data through powerful APIs.