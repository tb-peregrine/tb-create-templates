# Build a Real-Time Analytics API for Large Language Model (LLM) Performance Metrics

In the realm of machine learning and particularly with Large Language Models (LLMs) such as GPT-3, GPT-4, and others, monitoring usage and performance in real-time is crucial. It involves tracking various metrics, including token consumption, costs, latency, success rates, and error occurrences. Implementing an efficient and scalable solution to gather, process, and expose these metrics through an API can significantly enhance the operational oversight and optimization of LLMs. Tinybird is a data analytics backend for software developers. You use Tinybird to build real-time analytics APIs without needing to set up or manage the underlying infrastructure. Tinybird offers a local-first development workflow, git-based deployments, resource definitions as code, and features for AI-native developers. In this tutorial, we leverage Tinybird's capabilities to create datasources, transform data using [pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes), and publish real-time APIs to monitor LLM usage and performance. ## Understanding the data

Imagine your data looks like this:

```json
{"event_time": "2025-05-09 05:16:02", "model_name": "gpt-4", "prompt_tokens": 776, "completion_tokens": 276, "total_tokens": 1052, "cost": 0.1328, "latency": 2738839277.5, "success": 1, "error_message": ""}
```

This sample event represents a request to an LLM, tracking the name of the model, the number of tokens for the prompt and completion, total tokens used, cost incurred, latency of the request, whether it was successful, and an error message if applicable. To store this data, we create a Tinybird datasource using the following schema definition in a `.datasource` file:

```json
DESCRIPTION >
    LLM usage and performance metrics

SCHEMA >
    `event_time` DateTime `json:$.event_time`,
    `model_name` String `json:$.model_name`,
    `prompt_tokens` UInt32 `json:$.prompt_tokens`,
    `completion_tokens` UInt32 `json:$.completion_tokens`,
    `total_tokens` UInt32 `json:$.total_tokens`,
    `cost` Float32 `json:$.cost`,
    `latency` Float32 `json:$.latency`,
    `success` UInt8 `json:$.success`,
    `error_message` String `json:$.error_message`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(event_time)"
ENGINE_SORTING_KEY "event_time, model_name"
```

In this schema, we carefully chose the column types to optimize for storage and query speed, particularly for time-series data. The sorting key helps in faster retrieval based on `event_time` and `model_name`, which are likely to be common query parameters. To ingest data into this datasource, Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api) is a perfect fit for streaming JSON/NDJSON events directly from applications. Here's how you would use it:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=llm_events" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "event_time": "2023-07-15 12:34:56",
       "model_name": "gpt-4",
       "prompt_tokens": 150,
       "completion_tokens": 50,
       "total_tokens": 200,
       "cost": 0.023,
       "latency": 1.45,
       "success": 1,
       "error_message": ""
     }'
```

For different ingestion needs, Tinybird also supports Kafka connectors for event/streaming data, and the [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api) or S3 connectors for batch/file data. ## Transforming data and publishing APIs

Tinybird transforms and aggregates data through pipes, which can then be used to create real-time API [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints). Let's start with an endpoint to aggregate LLM usage by model. ### llm_usage_by_model.pipe

```sql
DESCRIPTION >
    Real-time API for LLM usage by model

NODE llm_usage_by_model_node
SQL >
    SELECT
        model_name,
        sum(prompt_tokens) AS total_prompt_tokens,
        sum(completion_tokens) AS total_completion_tokens,
        sum(total_tokens) AS total_tokens,
        sum(cost) AS total_cost
    FROM llm_events
    GROUP BY model_name

TYPE endpoint
```

This pipe aggregates token usage and costs by model name, providing a clear view of resource consumption across different LLMs. Here, the SQL logic is straightforward, grouping data by `model_name` and calculating sums for relevant metrics. To call this API after deployment:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/llm_usage_by_model.json?token=$TB_ADMIN_TOKEN"
```


### llm_performance.pipe

```sql
DESCRIPTION >
    Real-time API for LLM performance metrics

NODE llm_performance_node
SQL >
    SELECT
        model_name,
        avg(latency) AS avg_latency,
        avg(success) AS success_rate
    FROM llm_events
    GROUP BY model_name

TYPE endpoint
```

This endpoint showcases the average latency and success rate per model, critical for assessing the performance of each LLM. The `avg()` function computes the mean values of latency and success, again grouped by model name. To interact with this API:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/llm_performance.json?token=$TB_ADMIN_TOKEN"
```


## Deploying to production

Deploying your project to Tinybird Cloud is as simple as running:

```bash
tb --cloud deploy
```

This command deploys all your datasources and pipes, making your real-time APIs accessible and scalable. Tinybird manages your resources as code, facilitating integration with CI/CD pipelines and ensuring your data infrastructure is version-controlled and reproducible. To secure your APIs, Tinybird employs token-based authentication. Here's how to call your deployed endpoint:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/your_pipe_name.json?token=$TB_ADMIN_TOKEN"
```


## Conclusion

Through this tutorial, you've seen how to set up datasources to store LLM event data, transform that data into insightful metrics using pipes, and publish these metrics as real-time APIs using Tinybird. This approach offers scalability, real-time processing, and the flexibility to monitor and analyze LLM performance and usage efficiently. [Sign up for Tinybird](https://cloud.tinybird.co/signup) to build and deploy your first real-time data APIs in a few minutes. Tinybird is free to start, with no time limit and no credit card required, enabling you to immediately begin implementing the solutions outlined in this tutorial.