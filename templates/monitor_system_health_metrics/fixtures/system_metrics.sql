SELECT
    now() - rand() % 86400 AS timestamp,
    concat('host_', toString(rand() % 100)) AS host_id,
    concat('server-', toString(rand() % 100)) AS host_name,
    round(rand() % 100, 2) AS cpu_usage_percent,
    round(rand() % 100, 2) AS memory_usage_percent,
    round(rand() % 100, 2) AS disk_usage_percent,
    rand() % 10000000 AS network_in_bytes,
    rand() % 10000000 AS network_out_bytes,
    round(rand() % 10, 2) AS system_load_1m,
    round(rand() % 12, 2) AS system_load_5m,
    round(rand() % 15, 2) AS system_load_15m,
    rand() % 2 AS is_healthy
FROM numbers(10)