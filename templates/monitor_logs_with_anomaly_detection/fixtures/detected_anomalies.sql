SELECT
    now() - toIntervalSecond(rand() % 604800) AS detected_at,
    concat('srv-', toString(rand() % 100)) AS server_id,
    ['nginx', 'mysql', 'redis', 'postgresql', 'mongodb'][(rand() % 5) + 1] AS service,
    ['cpu_usage', 'memory_usage', 'disk_space', 'response_time', 'error_rate'][(rand() % 5) + 1] AS metric,
    round(rand() % 100 + rand(), 2) AS value,
    round(rand() % 50 + 50, 2) AS threshold,
    ['High CPU usage detected', 'Memory usage exceeding threshold', 'Disk space running low', 'Slow response times', 'Unusual error rate spike'][(rand() % 5) + 1] AS message,
    ['critical', 'warning', 'resolved'][(rand() % 3) + 1] AS status
FROM numbers(10)