# Social Media Sentiment Analysis API

## Tinybird

### Overview
This project provides a real-time social media sentiment analysis API built with Tinybird. It allows you to track, analyze, and visualize sentiment across different social media platforms, helping you understand how your brand or topics are perceived online.

### Data Sources

#### social_media_posts
A collection of social media posts with their metadata, content, and sentiment analysis scores. This datasource stores all the post information needed for real-time sentiment analysis.

**Sample Ingestion:**
```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=social_media_posts" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "post_id": "p12345",
       "platform": "twitter",
       "content": "I really love this new product! Amazing features.",
       "user_id": "user123",
       "timestamp": "2023-06-15 14:30:00",
       "likes": 42,
       "shares": 12,
       "sentiment_score": 0.85,
       "tags": ["product", "review", "positive"]
     }'
```

### Endpoints

#### 1. top_posts
Returns the most engaging or positively received posts based on customizable filters. Useful for identifying trending content or positive brand mentions.

**Sample Request:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/top_posts.json?token=$TB_ADMIN_TOKEN&platform_filter=twitter&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&sort_by=engagement&limit=5"
```

**Parameters:**
- `start_date`: Filter posts after this date (format: YYYY-MM-DD HH:MM:SS)
- `end_date`: Filter posts before this date (format: YYYY-MM-DD HH:MM:SS)
- `platform_filter`: Filter by specific platform
- `sentiment_min`: Minimum sentiment score (-1.0 to 1.0)
- `sentiment_max`: Maximum sentiment score (-1.0 to 1.0)
- `sort_by`: Sort by 'engagement' or 'sentiment'
- `limit`: Number of posts to return

#### 2. sentiment_by_platform
Provides an overview of sentiment metrics across different social media platforms, allowing you to compare sentiment performance between channels.

**Sample Request:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/sentiment_by_platform.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59"
```

**Parameters:**
- `start_date`: Filter posts after this date (format: YYYY-MM-DD HH:MM:SS)
- `end_date`: Filter posts before this date (format: YYYY-MM-DD HH:MM:SS)
- `platform_filter`: Filter to a specific platform

#### 3. sentiment_trends
Tracks sentiment over time to identify trends, allowing you to analyze how sentiment evolves and correlate changes with external events.

**Sample Request:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/sentiment_trends.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&interval=1%20week"
```

**Parameters:**
- `start_date`: Filter posts after this date (format: YYYY-MM-DD HH:MM:SS)
- `end_date`: Filter posts before this date (format: YYYY-MM-DD HH:MM:SS)
- `platform_filter`: Filter to a specific platform
- `interval`: Time bucket size (e.g., '1 day', '1 week', '1 month')
