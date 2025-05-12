# Build a Real-Time Survey Response Analytics API with Tinybird

In the realm of data analytics, swiftly processing and analyzing survey data can provide crucial insights into user feedback and trends. Developers often face the challenge of creating scalable, real-time APIs to handle this data efficiently. This tutorial will guide you through building a real-time API for survey response analytics using Tinybird. Tinybird is a data analytics backend for software developers. You use Tinybird to build real-time analytics APIs without needing to set up or manage the underlying infrastructure. Tinybird offers a local-first development workflows, git-based deployments, resource definitions as code, and features for AI-native developers. By leveraging Tinybird's data sources and [pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes), you can ingest survey data, transform it, and expose it through flexible, scalable APIs. ## Understanding the data

Imagine your data looks like this:

```json
{
  "response_id": "resp_1353",
  "survey_id": "surv_53",
  "user_id": "user_1353",
  "timestamp": "2025-05-09 17:22:22",
  "questions": ["question_1", "question_2"],
  "answers": ["answer_1", "answer_2"],
  "rating": 4,
  "feedback": "Very satisfied with the product!",
  "tags": []
}
```

This dataset represents individual responses to surveys, capturing details like the survey and user IDs, the timestamp of the response, questions asked, given answers, a numerical rating, textual feedback, and any associated tags. To store this data in Tinybird, you first create a data source with a schema matching the JSON structure of your survey responses. Here's how the `.datasource` file for `survey_responses` might look:

```json
{
  "DESCRIPTION": "Raw survey responses data",
  "SCHEMA": [
    {"name": "response_id", "type": "String", "json_path": "$.response_id"},
    {"name": "survey_id", "type": "String", "json_path": "$.survey_id"},
    {"name": "user_id", "type": "String", "json_path": "$.user_id"},
    {"name": "timestamp", "type": "DateTime", "json_path": "$.timestamp"},
    {"name": "questions", "type": "Array(String)", "json_path": "$.questions[:]"},
    {"name": "answers", "type": "Array(String)", "json_path": "$.answers[:]"},
    {"name": "rating", "type": "Int32", "json_path": "$.rating"},
    {"name": "feedback", "type": "String", "json_path": "$.feedback"},
    {"name": "tags", "type": "Array(String)", "json_path": "$.tags[:]" }
  ],
  "ENGINE": "MergeTree",
  "ENGINE_PARTITION_KEY": "toYYYYMM(timestamp)",
  "ENGINE_SORTING_KEY": "survey_id, timestamp, user_id"
}
```

When designing your schema, consider the types of queries you'll run. Sorting keys, for example, can significantly impact query performance, especially for time-series data. ### Data Ingestion

Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request. This real-time nature and low latency make it ideal for ingesting survey responses as they are collected:

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

For event or streaming data, consider the Kafka connector for its reliability and scalability. For batch or file data, the [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api) and S3 connector provide efficient bulk ingestion methods. ## Transforming data and publishing APIs

With the data ingested into Tinybird, the next step is to transform this data and publish APIs using pipes. Pipes in Tinybird allow for both batch and real-time data transformations, as well as the creation of API [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints). ### Endpoint: get_survey_stats

```sql
SELECT
    survey_id,
    count() AS total_responses,
    avg(rating) AS avg_rating,
    min(rating) AS min_rating,
    max(rating) AS max_rating,
    countIf(rating >= 4) AS positive_responses,
    countIf(rating <= 2) AS negative_responses
FROM survey_responses
WHERE 1=1
{% if defined(survey_id) %}
AND survey_id = {{String(survey_id, '')}}
{% end %}
{% if defined(from_date) %}
AND timestamp >= {{DateTime(from_date, '2023-01-01 00:00:00')}}
{% end %}
{% if defined(to_date) %}
AND timestamp <= {{DateTime(to_date, '2023-12-31 23:59:59')}}
{% end %}
GROUP BY survey_id
ORDER BY total_responses DESC

TYPE endpoint
```

This pipe aggregates survey statistics, providing a flexible API for fetching metrics like average ratings and response counts. Query parameters make the API adaptable to various client needs. ### Deploying to production

Deploying your Tinybird project to production is straightforward with the `tb --cloud deploy` command. This command packages your [data sources](https://www.tinybird.co/docs/forward/get-data-in/data-sources) and pipes, deploying them to Tinybird Cloud to create scalable, production-ready endpoints. Tinybird manages resources as code, facilitating integration with CI/CD pipelines for automated deployments. Secure your APIs with token-based authentication to ensure only authorized users can access them. Example API call:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_survey_stats.json?token=$TB_ADMIN_TOKEN&survey_id=survey_456&from_date=2023-01-01 00:00:00&to_date=2023-12-31 23:59:59"
```


## Conclusion

Throughout this tutorial, we've walked through creating a real-time API for survey response analytics using Tinybird. From ingesting data with the Events API to transforming it with pipes and deploying scalable endpoints, Tinybird provides a comprehensive platform for building real-time analytics APIs. The technical benefits include efficient data ingestion, flexible transformations, and the ability to publish and scale APIs rapidly. [Sign up for Tinybird](https://cloud.tinybird.co/signup) to build and deploy your first real-time data APIs in a few minutes. With Tinybird's local-first development workflows and git-based deployments, you're equipped to handle real-time data analytics at scale, without the operational overhead.