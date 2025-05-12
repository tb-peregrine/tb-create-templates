SELECT
    now() - rand() % 86400 AS event_time,
    concat('VEH-', toString(rand() % 100)) AS vehicle_id,
    35.0 + (rand() / 1000000000) AS latitude,
    -85.0 - (rand() / 1000000000) AS longitude,
    5 + (rand() % 70) AS speed,
    ['idle', 'driving', 'delivering', 'returning'][1 + rand() % 4] AS status
FROM numbers(10)