SELECT
    concat('evt_', toString(rand() % 1000000)) AS event_id,
    concat('user_', toString(rand() % 10000)) AS user_id,
    ['app_open', 'app_close', 'button_click', 'purchase', 'login', 'logout', 'screen_view', 'notification_received', 'error'][(rand() % 9) + 1] AS event_type,
    now() - toIntervalSecond(rand() % 86400) AS event_time,
    concat(toString(rand() % 5 + 1), '.', toString(rand() % 10), '.', toString(rand() % 10)) AS app_version,
    ['iPhone', 'Android', 'iPad', 'Android Tablet', 'Desktop'][(rand() % 5) + 1] AS device_type,
    concat(toString(rand() % 15 + 1), '.', toString(rand() % 10)) AS os_version,
    ['US', 'UK', 'CA', 'DE', 'FR', 'JP', 'AU', 'BR', 'IN', 'MX'][(rand() % 10) + 1] AS country,
    concat('{"screen":"', ['home', 'profile', 'settings', 'search', 'product'][(rand() % 5) + 1], '","value":', toString(rand() % 1000), '}') AS properties,
    concat('sess_', toString(rand() % 50000)) AS session_id
FROM numbers(10)