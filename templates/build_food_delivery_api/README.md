# Food Delivery Analytics API

## Tinybird

### Overview
This project provides a real-time analytics API for a food delivery service. It enables tracking and analysis of order trends, restaurant performance, and order status metrics to help optimize operations and improve customer experience.

### Data sources

#### food_delivery_orders
This data source stores all food delivery order information including order details, customer information, restaurant information, driver details, payment data, and delivery metrics.

**Ingestion Example:**
```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=food_delivery_orders" \
    -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
    -d '{
        "order_id": "ord-12345",
        "customer_id": "cust-789",
        "restaurant_id": "rest-456",
        "driver_id": "drv-123",
        "timestamp": "2023-06-15 18:30:00",
        "status": "delivered",
        "total_amount": 45.99,
        "delivery_fee": 4.99,
        "tip_amount": 8.00,
        "delivery_time_minutes": 28,
        "items": ["burger", "fries", "soda"],
        "city": "New York",
        "payment_method": "credit_card"
    }'
```

### Endpoints

#### daily_order_trends
This endpoint provides daily aggregated metrics about orders, including total orders, sales, average delivery time, delivery fees, and tips. Useful for tracking overall business performance over time.

**Usage Example:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/daily_order_trends.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-03-01%2023:59:59&city=New%20York&limit=10"
```

#### orders_by_restaurant
This endpoint provides analytics grouped by restaurant, including total orders, sales, average delivery time, and tip percentage. Helps identify top-performing restaurants and those that may need operational improvements.

**Usage Example:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/orders_by_restaurant.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-06-30%2023:59:59&city=Chicago&limit=50"
```

#### order_status_summary
This endpoint provides a summary of orders by status, including count, total sales, and average delivery time per status. Useful for monitoring order fulfillment performance and identifying potential issues in the delivery process.

**Usage Example:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/order_status_summary.json?token=$TB_ADMIN_TOKEN&start_date=2023-05-01%2000:00:00&end_date=2023-05-31%2023:59:59"
```
