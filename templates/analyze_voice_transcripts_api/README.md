
# Voice Call Sentiment Analysis API

## Tinybird

### Overview
This project provides an API to analyze voice call transcripts for sentiment analysis. It enables monitoring of call center performance by tracking customer sentiment, agent performance, and overall call trends.

### Data sources

#### voice_call_transcripts
This datasource stores voice call transcripts with associated metadata to enable sentiment analysis.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=voice_call_transcripts" \
  -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
  -d '{
    "call_id": "call_12345",
    "transcript": "Customer: I am really happy with your service. Agent: Thank you for your feedback!",
    "customer_id": "cust_789",
    "agent_id": "agent_456",
    "duration_seconds": 180,
    "timestamp": "2023-06-15 14:30:00",
    "call_type": "support",
    "caller_phone": "+1234567890",
    "tags": ["support", "billing"]
  }'
```

### Endpoints

#### analyze_sentiment
This endpoint analyzes voice call transcripts for sentiment using simple keyword matching.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/analyze_sentiment.json?token=$TB_ADMIN_TOKEN&call_id=call_12345&customer_id=cust_789&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59"
```

Parameters:
- `call_id` (optional): Filter by specific call ID
- `customer_id` (optional): Filter by customer ID
- `agent_id` (optional): Filter by agent ID
- `start_date` (optional): Start date filter in YYYY-MM-DD HH:MM:SS format
- `end_date` (optional): End date filter in YYYY-MM-DD HH:MM:SS format
- `limit` (optional): Maximum number of records to return (default: 100)

#### agent_performance
This endpoint analyzes agent performance based on call sentiment, showing total calls, positive call percentages, and average call duration.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/agent_performance.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59"
```

Parameters:
- `start_date` (optional): Start date filter in YYYY-MM-DD HH:MM:SS format
- `end_date` (optional): End date filter in YYYY-MM-DD HH:MM:SS format
- `limit` (optional): Maximum number of agents to return (default: 50)

#### sentiment_summary
This endpoint provides a summary of sentiment across calls, grouped by day, showing positive, negative, and neutral call counts.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/sentiment_summary.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&agent_id=agent_456"
```

Parameters:
- `start_date` (optional): Start date filter in YYYY-MM-DD HH:MM:SS format
- `end_date` (optional): End date filter in YYYY-MM-DD HH:MM:SS format
- `agent_id` (optional): Filter by agent ID
- `limit` (optional): Maximum number of days to return (default: 30)
