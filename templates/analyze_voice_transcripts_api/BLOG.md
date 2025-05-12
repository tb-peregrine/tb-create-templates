# Build a Voice Call Sentiment Analysis API with Tinybird

In this tutorial, you'll learn how to build an API that performs sentiment analysis on voice call transcripts. This API is particularly useful for monitoring call center performance, analyzing customer sentiment, agent effectiveness, and identifying trends over time. By leveraging Tinybird, a data analytics backend designed for software developers, you can implement this solution efficiently without worrying about the underlying infrastructure. Tinybird facilitates the creation of real-time analytics APIs by providing data sources for storing your data and pipes to transform data and expose it through [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints). This API will help you analyze voice call transcripts through simple keyword matching to categorize calls into positive, negative, or neutral sentiments. Additionally, you'll be able to evaluate agent performance and aggregate sentiment over time. Tinybird's data sources and pipes are central to this process, enabling real-time data ingestion, transformation, and API publication. Let's dive into the technical steps required to implement this voice call sentiment analysis API. ## Understanding the data

Imagine your data looks like this:

```json
{"call_id": "call_5389", "transcript": "Thank you for your assistance today. You have been very helpful in resolving my issue.", "customer_id": "cust_389", "agent_id": "agent_89", "duration_seconds": 569, "timestamp": "2025-04-14 03:32:28", "call_type": "billing", "caller_phone": "+1396805389", "tags": ["unsatisfied", "unsatisfied"]}
{"call_id": "call_8518", "transcript": "Hello, I need help with my account. I cannot access my services.", "customer_id": "cust_3518", "agent_id": "agent_18", "duration_seconds": 558, "timestamp": "2025-05-02 22:53:39", "call_type": "technical", "caller_phone": "+1385388518", "tags": []}
```

This data represents voice call transcripts along with metadata such as customer and agent IDs, call duration, timestamp, call type, caller's phone number, and tags indicating the call's nature. To store this data in Tinybird, you first need to create a data source. Here's how you define a data source for the voice call transcripts:

```json
DESCRIPTION >
    Stores voice call transcripts with metadata for sentiment analysis

SCHEMA >
    `call_id` String `json:$.call_id`,
    `transcript` String `json:$.transcript`,
    `customer_id` String `json:$.customer_id`,
    `agent_id` String `json:$.agent_id`,
    `duration_seconds` Int32 `json:$.duration_seconds`,
    `timestamp` DateTime `json:$.timestamp`,
    `call_type` String `json:$.call_type`,
    `caller_phone` String `json:$.caller_phone`,
    `tags` Array(String) `json:$.tags[:]`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(timestamp)"
ENGINE_SORTING_KEY "call_id, timestamp"
```

The schema is designed to optimize query performance with an appropriate sorting key and partitioning strategy. For data ingestion, Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request. This real-time nature and low latency make it ideal for live data feeds:

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

Other ingestion methods include using the Kafka connector for event/streaming data, which benefits from Kafka's robustness and scalability, and the [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api) or S3 connector for batch/file data. ## Transforming data and publishing APIs

Tinybird's [pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes) enable batch and real-time data transformations. They also help create API endpoints to expose transformed data. ### Sentiment Analysis Endpoint

Here's the complete code for the sentiment analysis endpoint pipe:

```bash
DESCRIPTION >
    Analyzes voice call transcripts for sentiment using simple keyword matching

NODE analyze_sentiment_node
SQL >
    %
    SELECT 
        call_id,
        transcript,
        customer_id,
        agent_id,
        timestamp,
        multiIf(
            position(lowerUTF8(transcript), 'happy') > 0 OR 
            position(lowerUTF8(transcript), 'great') > 0 OR 
            position(lowerUTF8(transcript), 'excellent') > 0 OR 
            position(lowerUTF8(transcript), 'thank you') > 0 OR 
            position(lowerUTF8(transcript), 'appreciate') > 0, 'positive',
            
            position(lowerUTF8(transcript), 'unhappy') > 0 OR 
            position(lowerUTF8(transcript), 'angry') > 0 OR 
            position(lowerUTF8(transcript), 'terrible') > 0 OR 
            position(lowerUTF8(transcript), 'upset') > 0 OR 
            position(lowerUTF8(transcript), 'frustrated') > 0, 'negative',
            
            'neutral'
        ) AS sentiment,
        duration_seconds
    FROM voice_call_transcripts
    WHERE 1=1
    {% if defined(call_id) %}
        AND call_id = {{String(call_id, '')}}
    {% end %}
    {% if defined(customer_id) %}
        AND customer_id = {{String(customer_id, '')}}
    {% end %}
    {% if defined(agent_id) %}
        AND agent_id = {{String(agent_id, '')}}
    {% end %}
    {% if defined(start_date) %}
        AND timestamp >= {{DateTime(start_date, '2023-01-01 00:00:00')}}
    {% end %}
    {% if defined(end_date) %}
        AND timestamp <= {{DateTime(end_date, '2023-12-31 23:59:59')}}
    {% end %}
    LIMIT {{Int32(limit, 100)}}

TYPE endpoint
```

This SQL logic matches keywords in transcripts to classify calls into sentiments. Query parameters make this API flexible, allowing for filtering by call ID, customer ID, agent ID, and date range. Example API call:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/analyze_sentiment.json?token=$TB_ADMIN_TOKEN&call_id=call_12345"
```

Similar logic is applied to the `agent_performance` and `sentiment_summary` endpoints, which provide insights into agent performance and sentiment trends, respectively. ## Deploying to production

Deploy your project to Tinybird Cloud using the Tinybird CLI:

```bash
tb --cloud deploy
```

This command creates production-ready, scalable API endpoints. Tinybird treats all resources as code, which means you can integrate this deployment process into your CI/CD pipeline for seamless updates. For securing your APIs, Tinybird uses token-based authentication. Here's how to call a deployed endpoint:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/analyze_sentiment.json?token=$TB_ADMIN_TOKEN&call_id=call_12345"
```


## Conclusion

Throughout this tutorial, you've learned how to build an API for analyzing sentiment in voice call transcripts using Tinybird. By creating [data sources](https://www.tinybird.co/docs/forward/get-data-in/data-sources), transforming data with pipes, and deploying to production, you've implemented a solution that can significantly enhance call center analytics. The technical benefits of using Tinybird for this use case include real-time data processing, scalability, and the ability to manage resources as code, which is crucial for agile development practices. [Sign up for Tinybird](https://cloud.tinybird.co/signup) to build and deploy your first real-time data APIs in a few minutes. Tinybird is free to start, with no time limit and no credit card required.