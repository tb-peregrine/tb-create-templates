
# Customer Satisfaction Analytics API

This project provides a comprehensive API for tracking and analyzing customer satisfaction data, enabling businesses to monitor satisfaction trends, identify areas for improvement, and make data-driven decisions.

## Tinybird

### Overview

This Tinybird project provides a robust backend for customer satisfaction analytics. It processes and analyzes customer feedback data to deliver real-time insights on satisfaction ratings, trends, and sentiment analysis across different categories and channels.

### Data sources

#### customer_satisfaction

Stores raw customer satisfaction data including ratings, feedback text, product categories, and channels.

**Example data ingestion:**

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=customer_satisfaction" \
    -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
    -d '{
        "customer_id": "cust_12345",
        "rating": 4,
        "feedback": "Very satisfied with the product quality, but delivery was delayed.",
        "category": "Electronics", 
        "product_id": "prod_789",
        "channel": "Website",
        "timestamp": "2023-04-15 14:30:00"
    }'
```

### Endpoints

#### customer_satisfaction_dashboard

Provides main dashboard metrics showing current vs previous period satisfaction ratings with change percentages by category.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/customer_satisfaction_dashboard.json?token=$TB_ADMIN_TOKEN&current_start=2023-04-01%2000:00:00&current_end=2023-04-30%2023:59:59&previous_start=2023-03-01%2000:00:00&previous_end=2023-03-31%2023:59:59"
```

Optional parameters:
- `category`: Filter results for a specific category

#### satisfaction_trends

Shows trend analysis for customer satisfaction over time with 7-day rolling averages.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/satisfaction_trends.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-04-30%2023:59:59"
```

Optional parameters:
- `category`: Filter results for a specific category

#### average_satisfaction_by_period

Calculates average satisfaction ratings over different time periods (hour, day, week, month).

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/average_satisfaction_by_period.json?token=$TB_ADMIN_TOKEN&period=week&start_date=2023-01-01%2000:00:00&end_date=2023-04-30%2023:59:59"
```

Optional parameters:
- `period`: Time period for aggregation (hour, day, week, month)
- `category`: Filter results for a specific category

#### rating_distribution

Provides distribution analysis of ratings across different categories or channels.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/rating_distribution.json?token=$TB_ADMIN_TOKEN&group_by=category"
```

Optional parameters:
- `group_by`: Group results by 'category' or 'channel'
- `start_date`: Filter from this date (YYYY-MM-DD HH:MM:SS)
- `end_date`: Filter to this date (YYYY-MM-DD HH:MM:SS)
- `category`: Filter for a specific category
- `channel`: Filter for a specific channel

#### feedback_sentiment_analysis

Analyzes customer feedback text to enable keyword-based sentiment analysis.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/feedback_sentiment_analysis.json?token=$TB_ADMIN_TOKEN&rating_min=1&rating_max=3&search_term=delivery"
```

Optional parameters:
- `rating_min`: Minimum rating value (1-5)
- `rating_max`: Maximum rating value (1-5)
- `category`: Filter for a specific category
- `search_term`: Keyword to search in feedback text
- `limit`: Maximum number of results to return
