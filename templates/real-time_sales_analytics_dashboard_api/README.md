
# Real-time Sales Analytics Dashboard API

## Tinybird

### Overview

This project provides a real-time sales analytics API built with Tinybird. It allows you to track sales events and analyze sales data by products, locations, and time periods. The API endpoints are designed to power dashboards and analytics interfaces with low-latency responses suitable for real-time monitoring.

### Data Sources

#### sales_events

This data source stores all sales transaction events with detailed information about products, customers, stores, and timestamps.

```
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=sales_events" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
           "transaction_id": "tx-12345",
           "product_id": "p-789",
           "product_name": "Premium Headphones",
           "category": "Electronics",
           "price": 129.99,
           "quantity": 1,
           "total_amount": 129.99,
           "customer_id": "cust-456",
           "store_id": "store-123",
           "store_location": "New York",
           "timestamp": "2023-05-15 14:30:00"
         }'
```

### Endpoints

#### top_products

This endpoint returns the top-selling products by revenue or quantity sold, with options to filter by category, store, and date range.

```
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/top_products.json?token=$TB_ADMIN_TOKEN&limit=5&sort_by=revenue&category=Electronics&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59"
```

Parameters:
- `category` (optional): Filter by product category
- `store_id` (optional): Filter by specific store
- `start_date` (optional, default: 2023-01-01 00:00:00): Start date for the analysis period
- `end_date` (optional, default: current timestamp): End date for the analysis period
- `sort_by` (optional, default: 'revenue'): Sort results by 'revenue' or 'units_sold'
- `limit` (optional, default: 10): Number of products to return

#### sales_by_location

This endpoint provides sales metrics aggregated by store location, allowing you to compare performance across different stores.

```
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/sales_by_location.json?token=$TB_ADMIN_TOKEN&category=Electronics&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59"
```

Parameters:
- `category` (optional): Filter by product category
- `start_date` (optional, default: 2023-01-01 00:00:00): Start date for the analysis period
- `end_date` (optional, default: current timestamp): End date for the analysis period
- `limit` (optional, default: 50): Number of locations to return

#### sales_by_period

This endpoint provides time-series sales data aggregated by day or hour, perfect for trend analysis and charts.

```
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/sales_by_period.json?token=$TB_ADMIN_TOKEN&time_granularity=day&category=Electronics&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59"
```

Parameters:
- `time_granularity` (optional, default: 'day'): Aggregate by 'day' or 'hour'
- `category` (optional): Filter by product category
- `product_id` (optional): Filter by specific product
- `store_id` (optional): Filter by specific store
- `start_date` (optional, default: 2023-01-01 00:00:00): Start date for the analysis period
- `end_date` (optional, default: current timestamp): End date for the analysis period
- `limit` (optional, default: 30): Number of time periods to return
