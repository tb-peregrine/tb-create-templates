SELECT
    now() - rand() % 86400 AS timestamp,
    concat('server-', toString(1 + rand() % 10)) AS server_id,
    ['INFO', 'WARN', 'ERROR', 'DEBUG', 'CRITICAL'][(rand() % 5) + 1] AS level,
    ['User login successful', 'Failed authentication attempt', 'Database connection timeout', 'API request processed', 'Resource limit reached', 'Cache miss', 'Scheduled maintenance started', 'Memory usage high', 'Network latency detected', 'Background job completed'][(rand() % 10) + 1] AS message,
    ['auth', 'api', 'database', 'frontend', 'cache', 'scheduler'][(rand() % 6) + 1] AS service,
    round(rand() % 100, 2) AS resource_usage,
    50 + rand() % 500 AS response_time,
    [200, 201, 204, 400, 401, 403, 404, 500, 502, 503][(rand() % 10) + 1] AS status_code,
    concat('user-', toString(rand() % 1000)) AS user_id,
    concat('req-', lower(hex(randomString(8)))) AS request_id
FROM numbers(10)