
# User Feedback Sentiment & Topic Analysis API

## Tinybird

### Overview
This Tinybird project provides a set of APIs for ingesting, processing, and analyzing user feedback data. It combines sentiment analysis and topic modeling to extract insights from user feedback, helping product teams understand customer satisfaction, identify trending topics, and discover emerging issues.

### Data Sources

#### user_feedback
Stores raw user feedback data including text, ratings, and metadata.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=user_feedback" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "feedback_id": "f123",
       "user_id": "u456",
       "feedback_text": "I love the new features but the app is a bit slow",
       "rating": 4,
       "timestamp": "2023-05-15 13:45:00",
       "product_id": "p789",
       "channel": "app"
     }'
```

#### feedback_sentiment_analysis
Stores the results of sentiment analysis performed on user feedback.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=feedback_sentiment_analysis" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "feedback_id": "f123",
       "sentiment_score": 0.75,
       "sentiment_label": "positive",
       "processed_at": "2023-05-15 13:46:00"
     }'
```

#### feedback_topics
Stores topic modeling results for user feedback, identifying the main themes.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=feedback_topics" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "feedback_id": "f123",
       "topic_id": 2,
       "topic_name": "performance",
       "topic_probability": 0.85,
       "processed_at": "2023-05-15 13:47:00"
     }'
```

### Endpoints

#### topic_distribution
API to get topic distribution across all feedback with filtering options.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/topic_distribution.json?token=$TB_ADMIN_TOKEN&product_id=p789&channel=app&min_probability=0.5&sentiment=positive&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&limit=10"
```

#### get_feedback_topics
API to retrieve topic distribution for specific user feedback.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_feedback_topics.json?token=$TB_ADMIN_TOKEN&topic_id=2&product_id=p789&min_probability=0.7&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&limit=50"
```

#### feedback_search
API to search user feedback by text content with additional filters.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/feedback_search.json?token=$TB_ADMIN_TOKEN&search_term=slow&product_id=p789&channel=app&sentiment=negative&topic_name=performance&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&limit=20"
```

#### get_feedback_sentiment
API to retrieve sentiment analysis for user feedback with various filtering options.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_feedback_sentiment.json?token=$TB_ADMIN_TOKEN&product_id=p789&channel=app&min_rating=3&max_rating=5&sentiment=positive&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&limit=50"
```

#### sentiment_summary
API to get sentiment summary statistics with filtering and grouping options.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/sentiment_summary.json?token=$TB_ADMIN_TOKEN&product_id=p789&channel=app&group_by=product&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59"
```

#### trending_topics
API to identify trending topics over time in user feedback.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/trending_topics.json?token=$TB_ADMIN_TOKEN&product_id=p789&channel=app&topic_name=performance&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&limit=30"
```
