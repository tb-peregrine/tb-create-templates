SELECT
    concat('evt_', toString(randomPrintableASCII(8))) AS event_id,
    concat('user_', toString(rand() % 1000)) AS user_id,
    ['app_open', 'workout_start', 'workout_end', 'achievement_unlocked', 'social_share'][rand() % 5 + 1] AS event_type,
    now() - toIntervalSecond(rand() % (86400 * 30)) AS timestamp,
    concat('1.', toString(rand() % 10), '.', toString(rand() % 10)) AS app_version,
    ['iPhone', 'Android', 'iPad', 'Galaxy Watch', 'Apple Watch'][rand() % 5 + 1] AS device_type,
    ['iOS', 'Android', 'watchOS', 'iPadOS'][rand() % 4 + 1] AS device_os,
    concat('sess_', toString(randomPrintableASCII(6))) AS session_id,
    rand() % 3600 AS duration_seconds,
    ['running', 'walking', 'cycling', 'swimming', 'weight_training', 'yoga', 'hiit'][rand() % 7 + 1] AS activity_type,
    rand() % 1000 AS calories_burned,
    round(rand() % 30 + rand(), 2) AS distance_km,
    60 + rand() % 100 AS heart_rate,
    37.7749 + (rand() / 1000) AS location_lat,
    -122.4194 + (rand() / 1000) AS location_lon
FROM numbers(10)