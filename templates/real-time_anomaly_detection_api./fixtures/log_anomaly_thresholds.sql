SELECT
    concat('service_', toString(1 + rand() % 10)) AS service,
    ['debug', 'info', 'warning', 'error', 'critical'][1 + rand() % 5] AS severity,
    round(rand() * 100, 2) AS threshold_per_minute,
    rand() % 2 AS active,
    now() - toIntervalSecond(rand() % 86400) AS updated_at
FROM numbers(10)