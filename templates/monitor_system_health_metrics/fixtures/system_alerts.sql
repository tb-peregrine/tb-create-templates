SELECT
    concat('alert_', toString(rand() % 10000)) AS alert_id,
    now() - rand() % 86400 AS timestamp,
    concat('host_', toString(rand() % 100)) AS host_id,
    concat('server-', toString(rand() % 100)) AS host_name,
    ['cpu', 'memory', 'disk', 'network', 'service'][rand() % 5 + 1] AS alert_type,
    ['cpu_usage', 'memory_usage', 'disk_space', 'network_latency', 'service_response_time'][rand() % 5 + 1] AS metric_name,
    round(rand() * 100, 2) AS metric_value,
    round(rand() * 80 + 10, 2) AS threshold,
    ['critical', 'high', 'medium', 'low'][rand() % 4 + 1] AS severity,
    concat('Alert: ', ['CPU usage', 'Memory usage', 'Disk space', 'Network latency', 'Service response time'][rand() % 5 + 1], ' exceeded threshold') AS message,
    ['open', 'acknowledged', 'resolved'][rand() % 3 + 1] AS status,
    multiIf(
        rand() % 3 + 1 = 3, 
        now() - rand() % 43200, 
        null
    ) AS resolved_at
FROM numbers(10)