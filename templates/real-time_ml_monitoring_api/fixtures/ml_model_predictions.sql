SELECT
    now() - toIntervalHour(rand() % 720) AS timestamp,
    concat('model_', toString(1 + rand() % 5)) AS model_id,
    concat('pred_', toString(rand() % 10000)) AS prediction_id,
    concat('{"feature1":', toString(rand(1) % 100), ',"feature2":', toString(rand(2) % 50), ',"feature3":', toString(rand(3) % 25), '}') AS features,
    round(rand() * 10, 2) AS predicted_value,
    round(rand() * 10, 2) AS actual_value,
    concat('v', toString(1 + rand() % 5), '.', toString(rand() % 10)) AS model_version,
    ['production', 'staging', 'development'][(rand() % 3) + 1] AS environment
FROM numbers(10)