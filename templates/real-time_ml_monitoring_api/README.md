# ML Model Performance Monitoring API

## Tinybird

### Overview
This Tinybird project provides a real-time API for monitoring machine learning model performance. It tracks model predictions, calculates performance metrics, and detects model drift to help data scientists and ML engineers ensure their models are performing as expected in production.

### Data Sources

#### ml_model_predictions
Stores machine learning model predictions and actual outcomes for performance monitoring.

**Sample Data Ingestion:**
```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=ml_model_predictions" \
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

### Endpoints

#### model_performance_metrics
Calculates key performance metrics for ML models including RMSE (Root Mean Square Error), MAE (Mean Absolute Error), and prediction count over a specified time period.

**Sample Usage:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/model_performance_metrics.json?token=$TB_ADMIN_TOKEN&model_id=price_prediction_model&model_version=v1.2.3&environment=production&time_window=48"
```

**Parameters:**
- `model_id` (optional): Filter by model ID (default: 'default_model')
- `model_version` (optional): Filter by model version (default: 'latest')
- `environment` (optional): Filter by environment (default: 'production')
- `time_window` (optional): Number of hours to look back (default: 24)

#### model_drift_detection
Detects potential model drift by comparing recent performance metrics with historical averages, helping identify when a model's performance is degrading.

**Sample Usage:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/model_drift_detection.json?token=$TB_ADMIN_TOKEN&model_id=price_prediction_model&environment=production&recent_window_hours=6&historical_window_hours=168"
```

**Parameters:**
- `model_id` (optional): Filter by model ID (default: 'default_model')
- `environment` (optional): Filter by environment (default: 'production')
- `recent_window_hours` (optional): Hours for recent window analysis (default: 6)
- `historical_window_hours` (optional): Hours for historical window analysis (default: 168)

#### prediction_details
Retrieves detailed prediction information for a specific model and time period, allowing for deeper investigation into model performance.

**Sample Usage:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/prediction_details.json?token=$TB_ADMIN_TOKEN&model_id=price_prediction_model&start_date=2023-05-10%2000:00:00&end_date=2023-05-15%2023:59:59&limit=50"
```

**Parameters:**
- `model_id` (optional): Filter by model ID (default: 'default_model')
- `model_version` (optional): Filter by model version (default: 'latest')
- `environment` (optional): Filter by environment (default: 'production')
- `start_date` (optional): Start date and time for filtering (format: YYYY-MM-DD HH:MM:SS)
- `end_date` (optional): End date and time for filtering (format: YYYY-MM-DD HH:MM:SS)
- `limit` (optional): Max number of records to return (default: 100)
