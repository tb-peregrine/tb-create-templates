
## Tinybird

### Overview

This project provides a real-time API for analyzing shipment data and product information, enabling insights into shipment status, late deliveries, and product-specific shipment summaries.

### Data sources

#### `product_catalog`

This data source contains details about each product, including its ID, name, category, and unit price.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=product_catalog" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{"product_id":"product123","product_name":"Awesome Widget","category":"Electronics","unit_price":29.99}'
```

#### `raw_shipments`

This data source stores raw shipment data, capturing information such as shipment ID, product ID, origin and destination locations, quantity, timestamps, and status.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=raw_shipments" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{"shipment_id":"shipment456","product_id":"product123","origin_location":"New York","destination_location":"Los Angeles","quantity":10,"shipment_timestamp":"2024-01-01 10:00:00","estimated_delivery_timestamp":"2024-01-05 18:00:00","actual_delivery_timestamp":"2024-01-05 17:00:00","status":"Delivered"}'
```

### Endpoints

#### `late_shipments`

This endpoint returns a list of shipments that were delivered later than their estimated delivery date.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/late_shipments.json?token=$TB_ADMIN_TOKEN"
```

#### `shipment_status_counts`

This endpoint provides a count of shipments for each status.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/shipment_status_counts.json?token=$TB_ADMIN_TOKEN"
```

#### `product_shipment_summary`

This endpoint generates a shipment summary for a specific product, including total quantity shipped, total shipments, and average delivery time.  It also supports filtering by product category.  If no product category is defined it will default to 'Electronics'.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/product_shipment_summary.json?token=$TB_ADMIN_TOKEN&product_category=Electronics"
```
