# E-Commerce Analytics API

## Tinybird

### Overview
This Tinybird project provides a real-time API for analyzing e-commerce transaction data. It processes transaction events and exposes endpoints for analyzing revenue metrics, customer behavior, product performance, and geographic sales patterns to support business intelligence and decision-making.

### Data Sources

#### ecommerce_transactions
This data source stores raw e-commerce transaction data including order details, customer information, and revenue metrics.

**Sample Data Ingestion:**
```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=ecommerce_transactions" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
         "transaction_id": "tx-12345",
         "customer_id": "cust-789",
         "order_date": "2023-06-15 14:30:00",
         "product_id": "prod-456",
         "product_name": "Wireless Headphones",
         "category": "Electronics",
         "quantity": 2,
         "unit_price": 79.99,
         "total_amount": 159.98,
         "payment_method": "Credit Card",
         "country": "United States",
         "device": "Mobile",
         "is_completed": 1,
         "timestamp": "2023-06-15 14:32:15"
     }'
```

### Endpoints

#### device_usage_analysis
Analyzes transaction patterns by device type with revenue metrics, showing which devices contribute most to sales.

**Usage:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/device_usage_analysis.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59"
```

#### revenue_by_date
Calculates daily revenue from e-commerce transactions, providing a time-series view of business performance.

**Usage:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/revenue_by_date.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59"
```

#### customer_purchase_history
Retrieves detailed purchase history for a specific customer, enabling personalized analysis and customer service.

**Usage:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/customer_purchase_history.json?token=$TB_ADMIN_TOKEN&customer_id=cust-789&limit=50"
```

#### product_performance
Analyzes product performance metrics including revenue, units sold, and order frequency to identify top-performing items.

**Usage:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/product_performance.json?token=$TB_ADMIN_TOKEN&category=Electronics&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&limit=50"
```

#### revenue_by_country
Provides geographic revenue analysis showing transaction metrics by country to identify key markets.

**Usage:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/revenue_by_country.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59"
```

#### payment_method_analysis
Analyzes transaction frequency and revenue by payment method to understand customer payment preferences.

**Usage:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/payment_method_analysis.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59"
```
