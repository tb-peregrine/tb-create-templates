# Build a Real-time Messaging Analytics API with Tinybird

In the realms of messaging applications, understanding user behavior and conversation dynamics is crucial for delivering a seamless user experience. Analyzing messaging data in real-time can provide invaluable insights into conversation trends, user engagement, and peak activity hours. This tutorial will guide you through building a real-time messaging analytics API using Tinybird, focusing on conversation retrieval, user messaging statistics, and hourly activity analysis. Tinybird is a data analytics backend for software developers. You use Tinybird to build real-time analytics APIs without needing to set up or manage the underlying infrastructure. Tinybird offers a local-first development workflows, git-based deployments, resource definitions as code, and features for AI-native developers. By leveraging Tinybird's data sources and pipes, you'll be able to ingest messaging data, transform it, and expose the resulting analytics through API [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints). Let's dive into the technical steps to create a scalable analytics API that can handle large volumes of messaging data in real-time. ## Understanding the data

Imagine your data looks like this:

```json
{"message_id": "msg_5361", "sender_id": "user_361", "recipient_id": "user_361", "conversation_id": "conv_361", "message_type": "image", "message_content": "This is a sample message with id 5361", "timestamp": "2025-04-15 04:00:55", "read": 1, "attachments": [], "character_count": 171}
```

This sample represents a message within a messaging application, including details such as the sender, recipient, conversation ID, message type, content, timestamp, and more. To store this data, you first need to create a Tinybird datasource:

```json
DESCRIPTION >
    Stores message data from a messaging application including metadata about sender, recipient, timestamp, and message content

SCHEMA >
    `message_id` String `json:$.message_id`,
    `sender_id` String `json:$.sender_id`,
    `recipient_id` String `json:$.recipient_id`,
    `conversation_id` String `json:$.conversation_id`,
    `message_type` String `json:$.message_type`,
    `message_content` String `json:$.message_content`,
    `timestamp` DateTime `json:$.timestamp`,
    `read` UInt8 `json:$.read`,
    `attachments` Array(String) `json:$.attachments[:]`,
    `character_count` UInt32 `json:$.character_count`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(timestamp)"
ENGINE_SORTING_KEY "conversation_id, timestamp"
```

This schema highlights the importance of choosing the right data types and sorting keys. Sorting by `conversation_id` and `timestamp` optimizes query performance for retrieving conversation messages in chronological order. To ingest data into this datasource, Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request:

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

For event/streaming data, the Kafka connector can further enhance your data ingestion pipeline by providing a robust and scalable method to stream data into Tinybird. For batch or file-based data ingestion, the [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api) and S3 connector are excellent choices, allowing for efficient bulk data loading. ## Transforming data and publishing APIs

Tinybird's pipes enable you to transform your data in real-time and publish it as API endpoints. Pipes can perform batch transformations, act as [Materialized views](https://www.tinybird.co/docs/forward/work-with-data/optimize/materialized-views), or directly serve as API endpoints. Consider the `get_messages_by_conversation` endpoint:

```sql
DESCRIPTION >
    Retrieve messages from a specific conversation with optional filtering by date range

NODE get_messages_node
SQL >
    %
    SELECT 
        message_id,
        sender_id,
        recipient_id,
        message_type,
        message_content,
        timestamp,
        read,
        attachments,
        character_count
    FROM messages
    WHERE conversation_id = {{String(conversation_id, '')}}
    {% if defined(start_date) %}
    AND timestamp >= {{DateTime(start_date, '2023-01-01 00:00:00')}}
    {% end %}
    {% if defined(end_date) %}
    AND timestamp <= {{DateTime(end_date, '2023-12-31 23:59:59')}}
    {% end %}
    ORDER BY timestamp
    {% if defined(limit) %}
    LIMIT {{Int32(limit, 100)}}
    {% end %}

TYPE endpoint
```

This pipe selects messages by conversation ID with optional date range filtering. The SQL query demonstrates how to use templating logic for dynamic parameter handling, making the API flexible and adaptable to different use cases. To call this API, use:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/[pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes)/get_messages_by_conversation.json?token=$TB_ADMIN_TOKEN&conversation_id=conv123&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&limit=50"
```


## Deploying to production

Deploying your project to the Tinybird Cloud is straightforward with the `tb --cloud deploy` command. This operation creates production-ready, scalable API endpoints. Tinybird manages resources as code, which facilitates integration with CI/CD pipelines and ensures that your data infrastructure is version-controlled and reproducible. For securing your APIs, Tinybird utilizes token-based authentication:

```bash
curl -X GET "https://api.tinybird.co/v0/pipes/your_pipe_name.json?token=<your_token>"
```


## Conclusion

Throughout this tutorial, you've learned how to ingest messaging data into Tinybird, transform it using pipes, and publish real-time analytics APIs. Tinybird simplifies handling large volumes of data in real-time, making it a great choice for building scalable analytics backends. [Sign up for Tinybird](https://cloud.tinybird.co/signup) to build and deploy your first real-time data APIs in a few minutes. Tinybird is free to start, with no time limit and no credit card required, enabling you to immediately begin implementing the solutions outlined in this tutorial.