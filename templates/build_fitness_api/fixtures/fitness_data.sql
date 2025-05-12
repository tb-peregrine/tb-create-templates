SELECT
    concat('user_', toString(1 + rand() % 100)) AS user_id,
    concat('device_', toString(1 + rand() % 20)) AS device_id,
    now() - toIntervalHour(rand() % 720) AS timestamp,
    rand() % 10000 AS steps,
    60 + rand() % 100 AS heart_rate,
    round(100 + rand() % 900 / 10, 1) AS calories_burned,
    round(rand() % 15000 / 10, 1) AS distance_meters,
    rand() % 480 AS sleep_minutes,
    rand() % 120 AS active_minutes
FROM numbers(10)