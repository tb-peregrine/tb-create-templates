SELECT
    concat('sess_', lower(hex(randomString(8)))) AS session_id,
    concat('user_', toString(rand() % 1000)) AS user_id,
    now() - toIntervalDay(rand() % 30) - toIntervalHour(rand() % 24) AS start_time,
    now() - toIntervalDay(rand() % 30) - toIntervalHour(rand() % 12) AS end_time,
    60 + rand() % 3600 AS duration_seconds,
    ['web', 'ios', 'android', 'desktop'][1 + rand() % 4] AS platform,
    ['mobile', 'tablet', 'laptop', 'desktop'][1 + rand() % 4] AS device_type,
    concat(toString(1 + rand() % 5), '.', toString(rand() % 10), '.', toString(rand() % 10)) AS version,
    5 + rand() % 100 AS session_events_count
FROM numbers(10)