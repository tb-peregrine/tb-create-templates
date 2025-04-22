SELECT
    concat('website_', toString(rand() % 1000)) AS website_id,
    500 + rand() % 9500 AS page_load_threshold_ms,
    100 + rand() % 4900 AS response_time_threshold_ms,
    5 + rand() % 95 AS error_threshold_count,
    now() - toIntervalDay(rand() % 365) AS created_at,
    now() - toIntervalDay(rand() % 30) AS updated_at
FROM numbers(10)