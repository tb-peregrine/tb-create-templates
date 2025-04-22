SELECT
    now() - toIntervalSecond(rand() % 86400) AS timestamp,
    concat('host-', toString(1 + rand() % 10)) AS host_id,
    concat('server-', toString(1 + rand() % 10)) AS host_name,
    round(rand() % 100, 2) AS cpu_usage_percent,
    round(rand() % 100, 2) AS memory_usage_percent,
    round(rand() % 100, 2) AS disk_usage_percent,
    round(50 + rand() % 950, 2) AS disk_free_gb,
    10000000 + rand() % 990000000 AS network_rx_bytes,
    10000000 + rand() % 990000000 AS network_tx_bytes,
    round(0.1 + rand() % 10, 2) AS system_load_1m,
    round(0.1 + rand() % 8, 2) AS system_load_5m,
    round(0.1 + rand() % 5, 2) AS system_load_15m
FROM numbers(10)