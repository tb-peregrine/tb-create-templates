# Search Query Analysis API

This project provides a robust API for processing, analyzing, and extracting insights from search query data with intent analysis capabilities.

## Tinybird

### Overview

This Tinybird project provides a comprehensive search query analytics platform that allows you to analyze search patterns, understand user intent, and optimize search experiences. The API enables real-time monitoring of search performance metrics, tracking of user behavior, and identification of query intent trends.

### Data sources

#### search_queries

Stores detailed search query data with metadata for analysis including query text, user information, session data, and result metrics.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=search_queries" \
  -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
  -d '{
    "query_id": "q123456",
    "user_id": "u789012",
    "query_text": "how to fix printer",
    "timestamp": "2023-05-15 14:30:00",
    "device_type": "desktop",
    "session_id": "sess_abcdef123",
    "results_count": 25,
    "clicked_results": ["result1", "result3"],
    "search_category": "support",
    "search_filters": "hardware,printers",
    "search_duration_ms": 245,
    "user_location": "NYC"
  }'
```

#### search_query_intents

Stores the classified intent for each search query, including confidence scores and identified keywords.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=search_query_intents" \
  -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
  -d '{
    "query_id": "q123456",
    "query_text": "how to fix printer",
    "intent_category": "support",
    "intent_confidence": 0.87,
    "intent_keywords": ["fix", "printer", "help"],
    "timestamp": "2023-05-15 14:30:05"
  }'
```

### Endpoints

#### top_search_queries

Returns the most frequent search queries with engagement metrics.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/top_search_queries.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&search_category=support&limit=10"
```

Parameters:
- `start_date`: Starting date for the analysis (format: YYYY-MM-DD HH:MM:SS)
- `end_date`: End date for the analysis (format: YYYY-MM-DD HH:MM:SS)
- `search_category`: Filter by search category
- `limit`: Number of queries to return (default: 20)

#### search_queries_by_time

Provides search query metrics aggregated by time intervals.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/search_queries_by_time.json?token=$TB_ADMIN_TOKEN&time_interval=1%20day&start_date=2023-01-01%2000:00:00&end_date=2023-01-31%2023:59:59&device_type=mobile"
```

Parameters:
- `time_interval`: Time interval for aggregation (e.g., '1 hour', '1 day')
- `start_date`: Starting date (format: YYYY-MM-DD HH:MM:SS)
- `end_date`: End date (format: YYYY-MM-DD HH:MM:SS)
- `search_category`: Filter by search category
- `device_type`: Filter by device type

#### intent_trend_analysis

Shows trends in search query intents over time.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/intent_trend_analysis.json?token=$TB_ADMIN_TOKEN&time_interval=1%20day&min_confidence=0.7&intent_categories=purchase,information"
```

Parameters:
- `time_interval`: Time interval for aggregation (e.g., '1 day', '1 week')
- `start_date`: Starting date (format: YYYY-MM-DD HH:MM:SS)
- `end_date`: End date (format: YYYY-MM-DD HH:MM:SS)
- `min_confidence`: Minimum confidence score threshold
- `intent_categories`: Comma-separated list of intent categories to include

#### query_intent_distribution

Provides the distribution of search query intents with metrics.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/query_intent_distribution.json?token=$TB_ADMIN_TOKEN&min_confidence=0.6"
```

Parameters:
- `start_date`: Starting date (format: YYYY-MM-DD HH:MM:SS)
- `end_date`: End date (format: YYYY-MM-DD HH:MM:SS)
- `min_confidence`: Minimum confidence score threshold
- `intent_category`: Filter by a specific intent category

#### search_queries_details

Provides detailed information about individual search queries with intent data.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/search_queries_details.json?token=$TB_ADMIN_TOKEN&user_id=u789012&intent_category=support&limit=50"
```

Parameters:
- `query_id`: Filter by specific query ID
- `user_id`: Filter by user ID
- `intent_category`: Filter by intent category
- `search_term`: Search for queries containing this term
- `start_date`: Starting date (format: YYYY-MM-DD HH:MM:SS)
- `end_date`: End date (format: YYYY-MM-DD HH:MM:SS)
- `limit`: Number of results to return (default: 100)
- `offset`: Offset for pagination
