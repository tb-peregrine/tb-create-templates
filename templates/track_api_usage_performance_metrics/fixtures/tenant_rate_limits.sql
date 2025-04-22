SELECT
    concat('tenant_', toString(rand() % 100)) AS tenant_id,
    ['/api/v1/users', '/api/v1/products', '/api/v1/orders', '/api/v1/analytics', '/api/v1/auth'][(rand() % 5) + 1] AS endpoint,
    100 + rand() % 900 AS requests_per_minute,
    1000 + rand() % 9000 AS requests_per_hour,
    10000 + rand() % 90000 AS requests_per_day,
    now() - toIntervalDay(rand() % 30) AS created_at,
    now() - toIntervalHour(rand() % 24) AS updated_at
FROM numbers(10)