SELECT
    now() - toIntervalSecond(rand() % 86400) AS timestamp,
    concat('srv-', toString(1 + rand() % 50)) AS server_id,
    ['nginx', 'mysql', 'redis', 'app', 'auth', 'api', 'scheduler', 'worker'][1 + rand() % 8] AS service,
    ['INFO', 'WARNING', 'ERROR', 'CRITICAL', 'DEBUG'][1 + rand() % 5] AS severity,
    ['Connection established', 'Operation completed successfully', 'Request timeout', 'Authentication failed', 'Resource not found', 'Database connection error', 'Memory limit exceeded', 'Unexpected shutdown', 'Service restarted', 'Configuration updated'][1 + rand() % 10] AS message,
    ['E' || toString(1000 + rand() % 9000), '', '', '', ''][1 + rand() % 5] AS error_code,
    concat('res-', toString(1 + rand() % 1000)) AS resource_id,
    concat('{"user_id":"', toString(1 + rand() % 100), '","duration_ms":', toString(10 + rand() % 990), ',"status_code":', toString(200 + (rand() % 5) * 100), '}') AS metadata
FROM numbers(10)