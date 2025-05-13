# Build a Real-Time API for Monitoring Machine Learning Model Performance with Tinybird

Machine learning models are at the heart of many modern applications, driving everything from recommendation systems to price prediction engines. However, ensuring these models perform as expected in production environments is a constant challenge. Model drift, inaccurate predictions, and changing data distributions can all degrade model performance over time. To address these challenges, we'll walk through building a real-time API for monitoring machine learning model performance using Tinybird. Tinybird is a data analytics backend for software developers. You use Tinybird to build real-time analytics APIs without needing to set up or manage the underlying infrastructure. Tinybird offers a local-first development workflows, git-based deployments, resource definitions as code, and features for AI-native developers. By leveraging Tinybird's data sources and [pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV), we can efficiently track model predictions, calculate performance metrics, and detect model drift to ensure optimal model performance. 

## Understanding the data

Imagine your data looks like this:

```json
{"timestamp": "2025-04-26 17:55:44", "model_id": "model_5", "prediction_id": "pred_2704", "features": "{\"feature1\":10,\"feature2\":41,\"feature3\":21}", "predicted_value": 17456627040, "actual_value": 17456627040, "model_version": "v5.4", "environment": "production"}
{"timestamp": "2025-04-24 13:55:44", "model_id": "model_2", "prediction_id": "pred_1316", "features": "{\"feature1\":72,\"feature2\":34,\"feature3\":5}", "predicted_value": 32959113160, "actual_value": 32959113160, "model_version": "v2.6", "environment": "staging"}
```

This data represents predictions made by machine learning models, including the timestamp of the prediction, the model ID, prediction ID, a JSON string of features used for the prediction, the predicted value, the actual outcome, the model version, and the environment (e.g., production, staging). To store this data in Tinybird, we create a data source with the following schema:

```json
DESCRIPTION >
    Stores machine learning model predictions and actual outcomes for performance monitoring

SCHEMA >
    `timestamp` DateTime `json:$.timestamp`,
    `model_id` String `json:$.model_id`,
    `prediction_id` String `json:$.prediction_id`,
    `features` String `json:$.features`,
    `predicted_value` Float64 `json:$.predicted_value`,
    `actual_value` Float64 `json:$.actual_value`,
    `model_version` String `json:$.model_version`,
    `environment` String `json:$.environment`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(timestamp)"
ENGINE_SORTING_KEY "timestamp, model_id, prediction_id"
```

This schema design, with a sorting key on `timestamp`, `model_id`, and `prediction_id`, optimizes query performance for time-based analyses and model-specific investigations. To ingest data into this source, Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request. Here's an example of how to use it:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=ml_model_predictions&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "timestamp": "2023-05-15 14:30:00",
       "model_id": "price_prediction_model",
       "prediction_id": "pred_123456",
       "features": "{\"feature1\": 0.5, \"feature2\": 10.2}",
       "predicted_value": 42.5,
       "actual_value": 45.1,
       "model_version": "v1.2.3",
       "environment": "production"
     }'
```

Other ingestion methods include the Kafka connector for streaming data and the [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) or S3 connector for batch/file data. 

## Transforming data and publishing APIs

Tinybird facilitates data transformation and API publication through the concept of pipes. Pipes can perform batch transformations, real-time transformations ([Materialized views](https://www.tinybird.co/docs/forward/work-with-data/optimize/materialized-views?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV)), and create API endpoints. Let's dive into the endpoints we are going to build. 

### Model Performance Metrics

This endpoint calculates key performance metrics such as RMSE (Root Mean Square Error), MAE (Mean Absolute Error), and prediction count over a specified time period. ```sql
DESCRIPTION >
    Calculates performance metrics for ML models including RMSE, MAE, and prediction count

NODE model_performance_metrics_node
SQL >
    SELECT 
        model_id,
        model_version,
        environment,
        count() as prediction_count,
        sqrt(avg(pow(predicted_value - actual_value, 2))) as rmse,
        avg(abs(predicted_value - actual_value)) as mae,
        min(timestamp) as period_start,
        max(timestamp) as period_end
    FROM ml_model_predictions
    WHERE 1=1
        AND model_id = '{{String(model_id, 'default_model')}}'
        AND model_version = '{{String(model_version, 'latest')}}'
        AND environment = '{{String(environment, 'production')}}'
        AND timestamp >= now() - interval '{{Int(time_window, 24)}}' hour
    GROUP BY model_id, model_version, environment

TYPE endpoint
```

This SQL logic groups predictions by `model_id`, `model_version`, and `environment` to compute the performance metrics. Query parameters like `model_id` and `time_window` make the API flexible, allowing users to filter the results based on their needs. Example API call:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/model_performance_metrics.json?token=%24TB_ADMIN_TOKEN&model_id=price_prediction_model&model_version=v1.2.3&environment=production&time_window=48&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV"
```


#

## Model Drift Detection

This endpoint detects potential model drift by comparing recent performance metrics with historical averages. ```sql
DESCRIPTION >
    Detects potential model drift by comparing recent performance metrics with historical averages

NODE model_drift_detection_node
SQL >
    WITH 
    recent_metrics AS (
        SELECT 
            model_id,
            model_version,
            environment,
            avg(abs(predicted_value - actual_value)) as recent_mae,
            count() as recent_count
        FROM ml_model_predictions
        WHERE timestamp >= now() - interval '{{Int(recent_window_hours, 6)}}' hour
            AND model_id = '{{String(model_id, 'default_model')}}'
            AND environment = '{{String(environment, 'production')}}'
        GROUP BY model_id, model_version, environment
    ),
    historical_metrics AS (
        SELECT 
            model_id,
            model_version,
            environment,
            avg(abs(predicted_value - actual_value)) as historical_mae,
            count() as historical_count
        FROM ml_model_predictions
        WHERE timestamp >= now() - interval '{{Int(historical_window_hours, 168)}}' hour
            AND timestamp < now() - interval '{{Int(recent_window_hours, 6)}}' hour
            AND model_id = '{{String(model_id, 'default_model')}}'
            AND environment = '{{String(environment, 'production')}}'
        GROUP BY model_id, model_version, environment
    )
    
    SELECT 
        r.model_id,
        r.model_version,
        r.environment,
        r.recent_mae,
        h.historical_mae,
        (r.recent_mae - h.historical_mae) / h.historical_mae as drift_percentage,
        r.recent_count,
        h.historical_count,
        now() as analysis_timestamp
    FROM recent_metrics r
    LEFT JOIN historical_metrics h 
    ON r.model_id = h.model_id 
        AND r.model_version = h.model_version 
        AND r.environment = h.environment
    WHERE h.historical_mae > 0
    ORDER BY abs(drift_percentage) DESC

TYPE endpoint
```

This pipe uses Common Table Expressions (CTEs) to calculate recent and historical MAE, facilitating drift detection by comparing these metrics. Example API call:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/model_drift_detection.json?token=%24TB_ADMIN_TOKEN&model_id=price_prediction_model&environment=production&recent_window_hours=6&historical_window_hours=168&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV"
```


## Deploying to production

To deploy these resources to the Tinybird Cloud, use:

```bash
tb --cloud deploy
```

This command creates production-ready, scalable API [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV). Tinybird manages resources as code, making it easy to integrate with CI/CD pipelines. Secure your APIs with token-based authentication. Example call to the deployed endpoint:

```bash
curl -X GET "https://api.tinybird.co/v0/pipes/model_performance_metrics.json?token=%3CYOUR_TOKEN&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV>&model_id=price_prediction_model&model_version=v1.2.3&environment=production&time_window=48"
```


## Conclusion

In this tutorial, we've built a real-time API for monitoring machine learning model performance using Tinybird. We covered how to ingest model prediction data, calculate performance metrics, detect model drift, and securely deploy APIs. Tinybird simplifies the process of building and managing real-time data APIs, making it an excellent tool for monitoring machine learning models in production. [Sign up for Tinybird](https://cloud.tinybird.co/signup?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) to build and deploy your first real-time data APIs in a few minutes.