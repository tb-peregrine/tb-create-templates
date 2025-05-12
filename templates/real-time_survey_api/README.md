# Survey Response Analytics API

## Tinybird

### Overview
This project is a real-time API for processing and analyzing survey response data. It provides endpoints to retrieve survey statistics, track user feedback trends over time, and fetch individual survey responses with flexible filtering options.

### Data sources

#### survey_responses
This datasource stores raw survey responses data including response ID, survey ID, user ID, timestamp, questions, answers, rating, feedback, and tags.

Example of how to ingest data:
```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=survey_responses" \
  -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
  -d '{
    "response_id": "resp_123",
    "survey_id": "survey_456",
    "user_id": "user_789",
    "timestamp": "2023-06-15 14:30:00",
    "questions": ["How satisfied are you?", "Would you recommend us?"],
    "answers": ["Very satisfied", "Yes, definitely"],
    "rating": 5,
    "feedback": "Great service, very responsive team!",
    "tags": ["customer", "support", "feedback"]
  }'
```

### Endpoints

#### get_survey_stats
This endpoint provides aggregated statistics about survey responses including total responses, average rating, minimum and maximum ratings, and counts of positive and negative responses.

Example usage:
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_survey_stats.json?token=$TB_ADMIN_TOKEN&survey_id=survey_456&from_date=2023-01-01 00:00:00&to_date=2023-12-31 23:59:59"
```

#### get_user_feedback_trends
This endpoint shows trends in user feedback over time, with daily aggregations of response counts and average ratings.

Example usage:
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_user_feedback_trends.json?token=$TB_ADMIN_TOKEN&survey_id=survey_456&from_date=2023-05-01 00:00:00&to_date=2023-06-30 23:59:59"
```

#### get_survey_responses
This endpoint retrieves individual survey responses with multiple filtering options including survey ID, user ID, rating range, and date range.

Example usage:
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_survey_responses.json?token=$TB_ADMIN_TOKEN&survey_id=survey_456&min_rating=4&limit=50"
```
