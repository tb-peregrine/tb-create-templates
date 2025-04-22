
# Sentiment Analysis API for User Feedback

## Tinybird

### Overview
This Tinybird project provides an API for processing, storing, and analyzing user feedback with sentiment analysis. It enables tracking sentiment trends over time, comparing product ratings, and analyzing feedback from different sources, helping businesses gain insights into customer satisfaction and identify areas for improvement.

### Data Sources

#### user_feedback
Stores raw user feedback including text, user information, timestamps, and product details.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=user_feedback" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "feedback_id": "fb123",
       "user_id": "user456",
       "feedback_text": "I really love this product, works great!",
       "product_id": "prod789",
       "product_name": "Smart Speaker",
       "category": "Electronics",
       "rating": 5,
       "timestamp": "2023-09-15 14:30:00",
       "source": "mobile_app",
       "language": "en"
     }'
```

#### feedback_sentiment
Stores sentiment analysis results for user feedback.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=feedback_sentiment" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "feedback_id": "fb123",
       "user_id": "user456",
       "feedback_text": "I really love this product, works great!",
       "sentiment_score": 0.85,
       "sentiment_label": "positive",
       "timestamp": "2023-09-15 14:30:00",
       "product_id": "prod789"
     }'
```

#### sentiment_stats_by_day
Stores aggregated daily sentiment statistics for efficient trend analysis. This is populated automatically by the daily_sentiment_stats materialized pipe.

### Endpoints

#### get_feedback
Query user feedback with optional filters for date range, product, and category.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_feedback.json?start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&product_id=prod789&token=$TB_ADMIN_TOKEN"
```

#### get_sentiment_analysis
Query sentiment analysis results with filtering options.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_sentiment_analysis.json?start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&product_id=prod789&sentiment_label=positive&token=$TB_ADMIN_TOKEN"
```

#### product_ratings_analysis
Analyze product ratings and correlate with sentiment scores.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/product_ratings_analysis.json?start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&category=Electronics&token=$TB_ADMIN_TOKEN"
```

#### sentiment_trends_summary
Provides aggregated sentiment trend analysis using pre-materialized data.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/sentiment_trends_summary.json?start_date=2023-01-01&end_date=2023-12-31&product_id=prod789&token=$TB_ADMIN_TOKEN"
```

#### sentiment_trends
Analyze sentiment trends over time with aggregated metrics.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/sentiment_trends.json?start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&product_id=prod789&token=$TB_ADMIN_TOKEN"
```

#### feedback_source_analysis
Analyze feedback by source (e.g., mobile app, website, customer service).

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/feedback_source_analysis.json?start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&token=$TB_ADMIN_TOKEN"
```
