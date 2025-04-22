SELECT
    now() - rand() % 86400 AS timestamp,
    concat(toString(rand() % 256), '.', toString(rand() % 256), '.', toString(rand() % 256), '.', toString(rand() % 256)) AS source_ip,
    concat(toString(rand() % 256), '.', toString(rand() % 256), '.', toString(rand() % 256), '.', toString(rand() % 256)) AS destination_ip,
    rand() % 65535 AS source_port,
    rand() % 65535 AS destination_port,
    ['TCP', 'UDP', 'ICMP', 'HTTP', 'HTTPS'][rand() % 5 + 1] AS protocol,
    rand() % 10000000 AS bytes_sent,
    rand() % 10000000 AS bytes_received,
    rand() % 10000 AS packets_sent,
    rand() % 10000 AS packets_received,
    rand() % 60000 AS connection_duration_ms,
    [200, 404, 500, 403, 301][rand() % 5 + 1] AS status_code,
    concat('device_', toString(rand() % 100)) AS device_id,
    rand() % 2 AS is_internal
FROM numbers(10)