SELECT
    concat('ev_', toString(rand() % 100000)) AS event_id,
    ['page_view', 'button_click', 'sign_up', 'purchase', 'app_open'][1 + rand() % 5] AS event_type,
    concat('user_', toString(rand() % 1000)) AS user_id,
    concat('sess_', toString(rand() % 5000)) AS session_id,
    now() - toIntervalSecond(rand() % 86400) AS timestamp,
    ['web', 'ios', 'android'][1 + rand() % 3] AS platform,
    concat(toString(rand() % 3 + 1), '.', toString(rand() % 10), '.', toString(rand() % 10)) AS app_version,
    ['desktop', 'mobile', 'tablet'][1 + rand() % 3] AS device_type,
    ['Windows', 'MacOS', 'iOS', 'Android', 'Linux'][1 + rand() % 5] AS os,
    ['US', 'UK', 'DE', 'FR', 'JP', 'IN', 'BR', 'CA'][1 + rand() % 8] AS country,
    concat('{"referrer":"', ['direct', 'google', 'facebook', 'twitter'][1 + rand() % 4], '","value":', toString(rand() % 1000), '}') AS properties
FROM numbers(10)