# Customer Feedback Analytics API

A real-time API for processing, storing, and analyzing customer feedback data to extract valuable insights and trends.

## Tinybird

### Overview

This project implements a comprehensive customer feedback analytics system using Tinybird. It processes raw customer feedback data including ratings, comments, and sentiment scores to provide actionable insights through various API endpoints. The system supports filtering by categories, time periods, products, and sentiment to help businesses understand customer satisfaction trends and identify areas for improvement.

### Data sources

#### customer_feedback

Stores raw customer feedback data including ratings, comments, and sentiment analysis scores.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=customer_feedback" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
           "feedback_id": "fb-12345",
           "customer_id": "cust-789",
           "product_id": "prod-456",
           "category": "electronics",
           "rating": 4,
           "comment": "Great product, works as expected!",
           "sentiment_score": 0.85,
           "created_at": "2023-05-15 14:30:00",
           "source": "website"
         }'
```

#### feedback_stats_daily

Aggregated daily feedback statistics for faster analytics queries. This data source is materialized by the `materialize_daily_stats` pipe.

```bash
# Note: This datasource is populated by the materialize_daily_stats pipe
# You don't need to directly insert data into this datasource
```

### Endpoints

#### get_feedback

Retrieve filtered customer feedback data with multiple filtering options.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_feedback.json?token=$TB_ADMIN_TOKEN&category=electronics&min_rating=3&sentiment=positive&date_from=2023-01-01%2000:00:00&date_to=2023-12-31%2023:59:59&limit=50"
```

#### feedback_daily_stats

Query pre-aggregated daily feedback statistics for efficient trend analysis.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/feedback_daily_stats.json?token=$TB_ADMIN_TOKEN&category=electronics&source=website&date_from=2023-01-01%2000:00:00&date_to=2023-12-31%2023:59:59"
```

#### feedback_sentiment_by_product

Analyze sentiment and ratings by product to identify top-performing and problematic products.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/feedback_sentiment_by_product.json?token=$TB_ADMIN_TOKEN&category=electronics&min_feedback=10&order_by=avg_rating&order=DESC"
```

#### feedback_trends

Analyze feedback trends over time with configurable time buckets (hour, day, week, month).

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/feedback_trends.json?token=$TB_ADMIN_TOKEN&time_bucket=week&category=electronics&date_from=2023-01-01%2000:00:00&date_to=2023-12-31%2023:59:59"
```

#### feedback_analytics

Get comprehensive analytics and insights from customer feedback across different categories.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/feedback_analytics.json?token=$TB_ADMIN_TOKEN&source=mobile_app&order_by=avg_sentiment&order=DESC"
```
