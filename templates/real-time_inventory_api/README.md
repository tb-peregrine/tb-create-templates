
## Tinybird

### Overview

This Tinybird project provides a real-time API for tracking inventory levels across multiple warehouses. It allows you to query current stock levels, view recent inventory movements, and get summary statistics for each warehouse.

### Data Sources

#### inventory

This data source stores real-time inventory data, including product ID, warehouse ID, quantity, timestamp of the event, the operation performed (add/remove), batch ID, and the unit price of the product.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=inventory" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{"product_id":"product123","warehouse_id":"warehouseA","quantity":10,"timestamp":"2024-01-01 12:00:00","operation":"add","batch_id":"batch001","unit_price":25.50}'
```

### Endpoints

#### warehouse_summary

This endpoint retrieves an inventory summary for each warehouse, including the number of unique products, the total number of items, and the total inventory value.  You can optionally filter by `warehouse_id`.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/warehouse_summary.json?token=$TB_ADMIN_TOKEN&warehouse_id=warehouseA"
```

#### inventory_current

This endpoint returns the current stock level for a specific product in a specific warehouse. You can filter by `product_id` and `warehouse_id`.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/inventory_current.json?token=$TB_ADMIN_TOKEN&product_id=product123&warehouse_id=warehouseA"
```

#### inventory_movements

This endpoint retrieves inventory movements within a specified date range.  You can filter by `product_id`, `warehouse_id`, `start_date` and `end_date`. The date parameters need to be passed with the format "YYYY-MM-DD HH:MM:SS". You can also specify a `limit` to the number of results returned.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/inventory_movements.json?token=$TB_ADMIN_TOKEN&product_id=product123&warehouse_id=warehouseA&start_date=2023-12-01 00:00:00&end_date=2024-01-01 23:59:59&limit=50"
```
