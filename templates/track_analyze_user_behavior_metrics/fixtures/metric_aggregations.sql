SELECT
    concat('segment_', toString(1 + rand() % 5)) AS segment_id,
    ['New Users', 'Power Users', 'Churned Users', 'Trial Users', 'Enterprise'][rand() % 5 + 1] AS segment_name,
    ['dau', 'mau', 'session_duration', 'conversion_rate', 'retention_rate', 'bounce_rate', 'revenue', 'arpu'][rand() % 8 + 1] AS metric_name,
    round(rand() * 100, 2) AS metric_value,
    now() - toIntervalDay(rand() % 30) - toIntervalHour(rand() % 24) AS time_period,
    ['daily', 'weekly', 'monthly', 'quarterly'][rand() % 4 + 1] AS granularity,
    now() - toIntervalHour(rand() % 8) - toIntervalMinute(rand() % 60) AS updated_at
FROM numbers(10)