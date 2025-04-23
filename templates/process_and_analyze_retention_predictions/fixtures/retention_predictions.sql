SELECT
    concat('user_', toString(rand() % 100000)) AS user_id,
    today() - toIntervalDay(rand() % 90) AS prediction_date,
    round(rand() / 4 + 0.75, 3) AS predicted_retention_7d,
    round(rand() / 3 + 0.6, 3) AS predicted_retention_30d,
    round(rand() / 2 + 0.4, 3) AS predicted_retention_90d,
    concat('v', toString(1 + rand() % 3), '.', toString(rand() % 10)) AS prediction_model_version
FROM numbers(10)