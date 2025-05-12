
# LLM Analytics API

A real-time analytics API for monitoring LLM usage and performance metrics.

## Tinybird

### Overview

This project provides a real-time API for tracking and analyzing Large Language Model (LLM) usage and performance metrics. It enables monitoring of token consumption, costs, latency, and error rates across different LLM models.

### Data Sources

#### llm_events

This datasource stores all LLM usage events including token counts, costs, latency measurements, and error information.

**Sample Ingestion**:

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

### Endpoints

#### llm_usage_by_model

This endpoint provides aggregated usage metrics by model, including token consumption and total costs.

**Sample Request**:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/llm_usage_by_model.json?token=$TB_ADMIN_TOKEN"
```

#### llm_errors

This endpoint provides error metrics, showing the count of each error type by model. You can optionally filter by a specific model.

**Sample Request**:

```bash
# Get all errors
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/llm_errors.json?token=$TB_ADMIN_TOKEN"

# Filter by specific model
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/llm_errors.json?token=$TB_ADMIN_TOKEN&model_name=gpt-4"
```

#### llm_performance

This endpoint provides performance metrics by model, including average latency and success rate.

**Sample Request**:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/llm_performance.json?token=$TB_ADMIN_TOKEN"
```
