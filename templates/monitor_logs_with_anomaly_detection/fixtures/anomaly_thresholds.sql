SELECT
    ['cpu_usage', 'memory_usage', 'request_latency', 'error_rate', 'disk_space', 'network_traffic', 'connection_count', 'queue_size', 'throughput', 'availability'][rand() % 10 + 1] AS metric,
    ['api-gateway', 'authentication', 'database', 'web-server', 'cache', 'payment-processor', 'notification', 'analytics', 'search', 'storage'][rand() % 10 + 1] AS service,
    round(rand() * 100, 2) AS threshold_value,
    ['absolute', 'percentage', 'standard_deviation', 'moving_average', 'rolling_window'][rand() % 5 + 1] AS threshold_type,
    now() - toIntervalHour(rand() % 720) AS updated_at
FROM numbers(10)