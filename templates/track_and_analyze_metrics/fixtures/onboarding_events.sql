SELECT
    concat('ev_', lower(hex(randomString(8)))) AS event_id,
    concat('user_', toString(rand() % 1000)) AS user_id,
    concat('step_', toString(1 + rand() % 5)) AS step_id,
    ['Account Creation', 'Profile Setup', 'Tutorial', 'Feature Tour', 'Settings Configuration'][(rand() % 5) + 1] AS step_name,
    ['completed', 'skipped', 'in_progress', 'failed', 'abandoned'][(rand() % 5) + 1] AS status,
    now() - toIntervalHour(rand() % 24) - toIntervalMinute(rand() % 60) AS timestamp,
    10 + rand() % 300 AS time_spent_seconds,
    concat('sess_', lower(hex(randomString(6)))) AS session_id,
    ['iOS', 'Android', 'Web', 'Desktop'][(rand() % 4) + 1] AS platform,
    concat('v1.', toString(rand() % 10), '.', toString(rand() % 10)) AS app_version,
    concat('{"device":"', ['iPhone', 'Pixel', 'Chrome', 'Firefox', 'Safari'][(rand() % 5) + 1], '","country":"', ['US', 'UK', 'CA', 'DE', 'JP', 'BR'][(rand() % 6) + 1], '"}') AS metadata
FROM numbers(10)