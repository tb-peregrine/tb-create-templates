SELECT
    concat('fb_', toString(rand() % 10000)) AS feedback_id,
    1 + rand() % 10 AS topic_id,
    ['Product Quality', 'Customer Service', 'Shipping', 'Pricing', 'Website UX', 'Product Features', 'Returns', 'Billing', 'App Experience', 'Recommendations'][topic_id] AS topic_name,
    round(0.1 + rand() / 1.25, 3) AS topic_probability,
    now() - toIntervalDay(rand() % 30) - toIntervalHour(rand() % 24) AS processed_at
FROM numbers(10)