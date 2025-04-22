# Product Performance Analytics API

## Tinybird

### Overview

This Tinybird project provides a comprehensive API for tracking and analyzing product performance metrics against category benchmarks. It enables businesses to monitor sales, customer satisfaction, conversion rates, and other key performance indicators for their products across different categories. The API allows for comparison against category benchmarks to identify top-performing products and underperforming ones that need attention.

### Data Sources

#### `product_metrics`
Stores key performance indicators for products including sales, satisfaction ratings, and conversion metrics.

**Ingest data:**
```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=product_metrics" \
  -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
  -d '{
    "product_id": "p123",
    "product_name": "Premium Coffee Maker",
    "category": "Kitchen Appliances",
    "timestamp": "2023-06-15 09:30:00",
    "sales_amount": 149.99,
    "units_sold": 25,
    "customer_satisfaction": 4.7,
    "page_views": 1250,
    "conversion_rate": 0.045,
    "return_rate": 0.02
  }'
```

#### `product_benchmarks`
Contains benchmark metrics by category for comparing product performance.

**Ingest data:**
```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=product_benchmarks" \
  -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
  -d '{
    "category": "Kitchen Appliances",
    "metric_name": "sales_amount",
    "benchmark_value": 120.5,
    "updated_at": "2023-06-01 00:00:00"
  }'
```

### Endpoints

#### `product_performance_vs_benchmark`
Compare product performance metrics against category benchmarks with optional filtering.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/product_performance_vs_benchmark.json?token=$TB_ADMIN_TOKEN&category=Electronics&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&sort_by=sales_pct_of_benchmark&sort_order=desc&limit=10"
```

#### `category_performance_trends`
Analyze performance trends by product category over time.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/category_performance_trends.json?token=$TB_ADMIN_TOKEN&category=Electronics&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59"
```

#### `update_benchmarks`
API to calculate and update benchmark values for product categories.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/update_benchmarks.json?token=$TB_ADMIN_TOKEN&category=Electronics&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59"
```

#### `product_performance`
Get detailed performance metrics for specific products with optional filtering.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/product_performance.json?token=$TB_ADMIN_TOKEN&product_id=p123&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59"
```

#### `top_performing_products`
Get top performing products based on selected metrics compared to category benchmarks.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/top_performing_products.json?token=$TB_ADMIN_TOKEN&category=Electronics&metric=sales_amount&limit=5"
```
