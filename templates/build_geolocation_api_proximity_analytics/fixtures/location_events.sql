SELECT
    concat('user_', toString(rand() % 1000)) AS user_id,
    (rand() % 180) - 90 + rand() / 1000 AS latitude,
    (rand() % 360) - 180 + rand() / 1000 AS longitude,
    5 + rand() % 95 AS accuracy,
    ['arrived', 'departed', 'nearby', 'entered_region', 'exited_region'][rand() % 5 + 1] AS event_type,
    concat('device_', toString(rand() % 500)) AS device_id,
    now() - toIntervalSecond(rand() % 86400 * 30) AS timestamp
FROM numbers(10)