SELECT
    concat('int_', toString(rand() % 10000)) AS interaction_id,
    concat('cust_', toString(rand() % 1000)) AS customer_id,
    now() - toIntervalDay(rand() % 90) - toIntervalHour(rand() % 24) AS interaction_date,
    ['login', 'support', 'feature_usage', 'purchase', 'feedback'][1 + rand() % 5] AS interaction_type,
    ['web', 'mobile', 'email', 'phone', 'in_person'][1 + rand() % 5] AS channel,
    30 + rand() % 600 AS duration_seconds,
    1 + rand() % 10 AS satisfaction_score
FROM numbers(10)