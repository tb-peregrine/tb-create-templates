# Building a Real-Time Inventory Management System with Tinybird

## Introduction
Managing an inventory can be a complex task, especially when it comes to maintaining real-time insights into stock levels, transactions, and overall inventory health. Software developers in the e-commerce and retail sectors often need to build systems that can handle these tasks efficiently, ensuring that stock levels are accurate, and transactions are recorded in real time. This is where Tinybird comes into play, providing the backbone for creating powerful, real-time data APIs.

Tinybird is a data analytics platform designed to ingest, transform, and serve large volumes of data through SQL-based real-time APIs. In this tutorial, we'll explore how to leverage Tinybird's datasources and pipes to build an Inventory Management System. This system will track inventory items, monitor stock levels, and record inventory transactions, providing businesses with the real-time insights they need to manage their inventory effectively.

## Section 1: Understanding the Data

Imagine your data looks like this:

```json
{
  "item_id": "item_915",
  "item_name": "Product 15",
  "category": "Electronics",
  "current_stock": 915,
  "min_stock_level": 25,
  "max_stock_level": 515,
  "unit_price": 305,
  "supplier_id": "supplier_15",
  "warehouse_id": "wh_0",
  "last_updated": "2025-04-14 20:49:33"
}
```

This sample data represents an inventory item in a retail or e-commerce business, including details such as the item name, category, current stock levels, and pricing information.

To store and manage this data in Tinybird, we create datasources with a schema that reflects the structure of our inventory items and transactions. Here’s how to define a datasource for inventory items in Tinybird:

```sql
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

This schema design ensures efficient query performance by using a sorting key that aligns with common query patterns, such as retrieving items by ID and warehouse location.

For data ingestion, Tinybird's Events API allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request. This real-time nature of the Events API, combined with its low latency, makes it ideal for tracking inventory transactions as they happen.

Here's a sample code for ingesting inventory items using the Events API:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=inventory_items" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
         "item_id": "ITM001",
         "item_name": "Wireless Headphones",
         "category": "Electronics",
         "current_stock": 45,
         "min_stock_level": 10,
         "max_stock_level": 100,
         "unit_price": 49.99,
         "supplier_id": "SUP123",
         "warehouse_id": "WH001",
         "last_updated": "2023-06-15 14:30:00"
     }'
```

In addition to the Events API, Tinybird provides other ingestion methods that cater to different data sources and requirements, such as the Kafka connector for streaming data and the Datasources API for batch ingestion from files.

## Section 2: Building Data Transformation Pipes

Tinybird pipes are powerful tools for transforming and serving your data in real-time. They allow you to create batch transformations, real-time transformations (similar to materialized views), and API endpoints.

Let’s create an endpoint to get detailed information about a specific inventory item, including its recent transactions:

```sql
DESCRIPTION >
    Endpoint to get detailed information about a specific inventory item including recent transactions

NODE get_inventory_details_node
SQL >
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
        AND warehouse_id = {{String(warehouse_id, '')}}
    )
    SELECT 
        i.*,
        t.transaction_id,
        t.transaction_type,
        t.quantity,
        t.transaction_date,
        t.user_id,
        t.reference_id,
        t.notes
    FROM item AS i
    LEFT JOIN inventory_transactions AS t 
    ON i.item_id = t.item_id AND i.warehouse_id = t.warehouse_id
    WHERE t.transaction_date IS NULL OR t.transaction_date >= now() - interval 30 day
    ORDER BY t.transaction_date DESC
    LIMIT 100

TYPE endpoint
```

This pipe defines an SQL query that fetches detailed information about an inventory item, including its transactions over the last 30 days. Query parameters like `item_id` and `warehouse_id` make the API flexible, allowing users to retrieve data for specific items or locations.

Example API call to get details for a specific item:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_inventory_details.json?token=$TB_ADMIN_TOKEN&item_id=ITM001&warehouse_id=WH001"
```

By explaining the SQL logic and including complete code for each pipe, you can see how Tinybird turns complex data operations into simple, real-time API endpoints.

## Section 3: Deployment and Production Use

Deploying your project to the Tinybird Cloud is straightforward with the Tinybird CLI. Run the `tb --cloud deploy` command to deploy your datasources and pipes, creating production-ready, scalable API endpoints.

Tinybird treats your data resources as code, enabling you to manage and version your infrastructure alongside your application code. This approach fits seamlessly into CI/CD pipelines, ensuring that your data processing logic evolves with your application.

Securing your APIs is crucial for production use. Tinybird provides token-based authentication, allowing you to control access to your data endpoints. Here's how you can make an authenticated API call:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_inventory_items.json?token=$TB_ADMIN_TOKEN"
```

## Conclusion

Throughout this tutorial, we've covered how to use Tinybird to build a real-time Inventory Management System. We've seen how to define datasources, ingest data in real-time, transform data with pipes, and deploy scalable, secure API endpoints. Tinybird provides a powerful platform for handling real-time data at scale, making it an excellent choice for developers looking to implement efficient data processing and analytics solutions.

Sign up for Tinybird today at tinybird.co to start building real-time data APIs for your use case.