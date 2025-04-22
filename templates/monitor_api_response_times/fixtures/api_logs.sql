SELECT
    now() - rand() % (3600 * 24 * 30) AS timestamp,
    concat('api_', toString(1 + rand() % 5)) AS api_id,
    ['/users', '/products', '/orders', '/payments', '/auth'][1 + rand() % 5] AS endpoint,
    ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'][1 + rand() % 5] AS method,
    multiIf(
        rand() % 10 = 0, 500 + rand() % 100,
        rand() % 20 = 0, 400 + rand() % 100,
        rand() % 50 = 0, 300 + rand() % 100,
        200 + rand() % 100
    ) AS status_code,
    10 + rand() % 2000 AS response_time_ms,
    concat('user_', toString(rand() % 1000)) AS user_id,
    ['us-east-1', 'us-west-2', 'eu-west-1', 'ap-southeast-1', 'sa-east-1'][1 + rand() % 5] AS region,
    multiIf(
        rand() % 10 = 0, 0,
        rand() % 20 = 0, 0,
        1
    ) AS success
FROM numbers(10)