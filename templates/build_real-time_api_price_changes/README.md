
# E-commerce Price Change Monitoring API

This project enables real-time tracking and analysis of product price changes in e-commerce platforms.

## Tinybird

### Overview

This Tinybird project provides a real-time API for monitoring price changes across e-commerce products. It allows users to track specific product price histories, identify significant price drops, and analyze price trends by product categories.

### Data sources

#### product_price_changes

This data source captures price changes for products in e-commerce platforms, storing essential information like product details, old and new prices, percentage changes, and timestamps.

**Ingestion example:**

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=product_price_changes" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "product_id": "ABC123",
       "product_name": "Wireless Headphones",
       "category": "electronics",
       "merchant_id": "MERCH001",
       "old_price": 129.99,
       "new_price": 99.99,
       "price_change": -30.0,
       "price_change_percentage": -23.08,
       "currency": "USD",
       "change_timestamp": "2023-06-15 09:30:00",
       "event_timestamp": "2023-06-15 09:30:05"
     }'
```

### Endpoints

#### price_changes_by_product

Returns the price change history for a specific product, ordered by change timestamp.

**Usage example:**

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/price_changes_by_product.json?product_id=ABC123&limit=5&token=$TB_ADMIN_TOKEN"
```

#### significant_price_drops

Identifies products with significant price drops, based on a configurable threshold percentage.

**Usage example:**

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/significant_price_drops.json?threshold=-15.0&category=electronics&from_date=2023-06-01%2000:00:00&limit=10&token=$TB_ADMIN_TOKEN"
```

#### price_changes_by_category

Gets recent price changes within a specific product category, with options to filter by minimum percentage change and date range.

**Usage example:**

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/price_changes_by_category.json?category=electronics&min_percentage_change=5.0&from_date=2023-06-01%2000:00:00&limit=20&token=$TB_ADMIN_TOKEN"
```
