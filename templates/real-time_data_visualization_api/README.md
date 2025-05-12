# E-commerce Real-time Data API

This project provides a real-time API for visualizing key e-commerce metrics using Tinybird.  It focuses on providing insights into product performance, event tracking, and revenue trends.

## Tinybird

### Overview

This Tinybird project provides a real-time API for e-commerce data, focusing on top product performance, event counts by country, and total revenue trends. It ingests e-commerce event data and transforms it into valuable insights through SQL-based endpoints.

### Data sources

#### ecommerce_events

This data source stores raw e-commerce events, including event time, type, user ID, product ID, category, price, quantity, session ID, and country.  It is the foundation for all the derived metrics in this project.

Example ingestion:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=ecommerce_events" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{"event_time":"2024-10-27 10:00:00","event_type":"purchase","user_id":"user123","product_id":"product456","category":"electronics","price":100.0,"quantity":1,"session_id":"session789","country":"US"}'
```

### Endpoints

#### top_products

This endpoint returns the top 10 selling products based on total revenue.  It provides insights into which products are driving the most sales.

Example usage:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/top_products.json?token=$TB_ADMIN_TOKEN"
```

#### events_by_country

This endpoint returns the number of events per country, providing a geographical overview of user activity.

Example usage:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/events_by_country.json?token=$TB_ADMIN_TOKEN"
```

#### total_revenue

This endpoint returns the total revenue over time, aggregated into 15-minute intervals.  It allows you to track revenue trends in near real-time.

Example usage:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/total_revenue.json?token=$TB_ADMIN_TOKEN"
```
