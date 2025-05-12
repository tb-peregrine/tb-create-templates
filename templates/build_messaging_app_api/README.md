
# Messaging Analytics API

This project provides an API for analyzing messaging application data, focusing on conversation retrieval and usage pattern analysis.

## Tinybird

### Overview

This Tinybird project provides analytics capabilities for a messaging application. It enables querying of conversation messages, user messaging statistics, and hourly activity patterns to help understand user behavior and application usage.

### Data sources

#### messages

Stores message data from a messaging application including metadata about sender, recipient, timestamp, and message content.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=messages" \
  -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
  -d '{
    "message_id": "msg123",
    "sender_id": "user456",
    "recipient_id": "user789",
    "conversation_id": "conv123",
    "message_type": "text",
    "message_content": "Hello there!",
    "timestamp": "2023-05-15 14:30:00",
    "read": 1,
    "attachments": [],
    "character_count": 12
  }'
```

### Endpoints

#### get_messages_by_conversation

Retrieves messages from a specific conversation with optional filtering by date range.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_messages_by_conversation.json?token=$TB_ADMIN_TOKEN&conversation_id=conv123&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&limit=50"
```

Parameters:
- `conversation_id` (required): ID of the conversation to retrieve messages from
- `start_date` (optional): Filter messages after this date (format: YYYY-MM-DD HH:MM:SS)
- `end_date` (optional): Filter messages before this date (format: YYYY-MM-DD HH:MM:SS)
- `limit` (optional): Maximum number of messages to return (default: 100)

#### get_user_message_stats

Provides messaging statistics for a specific user, including message counts, average length, and activity patterns.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_user_message_stats.json?token=$TB_ADMIN_TOKEN&user_id=user456&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59"
```

Parameters:
- `user_id` (required): ID of the user to retrieve stats for
- `start_date` (optional): Start date for analysis period (format: YYYY-MM-DD HH:MM:SS)
- `end_date` (optional): End date for analysis period (format: YYYY-MM-DD HH:MM:SS)

#### get_message_activity_by_hour

Analyzes messaging activity patterns broken down by hour of day to identify peak usage times.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_message_activity_by_hour.json?token=$TB_ADMIN_TOKEN&user_id=user456&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59"
```

Parameters:
- `user_id` (optional): Filter activity for a specific user
- `start_date` (optional): Start date for analysis period (format: YYYY-MM-DD HH:MM:SS)
- `end_date` (optional): End date for analysis period (format: YYYY-MM-DD HH:MM:SS)
