# Customer Feedback Analysis API

This project provides a real-time API to ingest, process, and analyze customer feedback data to help businesses understand customer sentiment and product performance.

## Tinybird

### Overview

This Tinybird project creates a real-time API for processing and analyzing customer feedback. It enables businesses to track sentiment, ratings, and emerging trends from customer feedback across different products.

### Data sources

#### feedback_events

This datasource stores raw customer feedback events ingested in real-time, including ratings, sentiment analysis, and associated tags.

Example of how to ingest data:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=feedback_events" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "feedback_id": "fb-12345",
       "customer_id": "cust-789",
       "product_id": "prod-456",
       "rating": 4,
       "feedback_text": "I really like this product, but delivery was slow",
       "sentiment": "positive",
       "tags": ["quality", "delivery-issues"],
       "timestamp": "2023-05-15 14:30:00"
     }'
```

### Endpoints

#### get_feedback_summary

Provides aggregated feedback statistics with optional filtering by date range and product ID.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_feedback_summary.json?token=$TB_ADMIN_TOKEN&product_id=prod-456&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&limit=50"
```

#### get_trending_tags

Identifies trending tags in customer feedback with options to filter by product and date range.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_trending_tags.json?token=$TB_ADMIN_TOKEN&product_id=prod-456&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&limit=10"
```

#### get_feedback_by_product

Retrieves detailed feedback for a specific product with optional filtering by rating and date range.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_feedback_by_product.json?token=$TB_ADMIN_TOKEN&product_id=prod-456&min_rating=3&max_rating=5&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&limit=20"
```

Note: DateTime parameters must be formatted as YYYY-MM-DD HH:MM:SS, or else will fail.
