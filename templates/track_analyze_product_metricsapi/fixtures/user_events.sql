SELECT
    concat('ev_', toString(rand() % 100000)) AS event_id,
    concat('user_', toString(rand() % 5000)) AS user_id,
    ['page_view', 'feature_click', 'login', 'logout', 'search', 'purchase', 'share', 'download'][(rand() % 8) + 1] AS event_type,
    concat('feature_', toString(rand() % 50)) AS feature_id,
    now() - toIntervalSecond(rand() % 2592000) AS timestamp,
    ['mobile', 'desktop', 'tablet', 'tv', 'wearable'][(rand() % 5) + 1] AS device_type,
    ['Windows', 'macOS', 'iOS', 'Android', 'Linux', 'ChromeOS'][(rand() % 6) + 1] AS os,
    ['Chrome', 'Firefox', 'Safari', 'Edge', 'Opera'][(rand() % 5) + 1] AS browser,
    concat('session_', toString(rand() % 10000)) AS session_id,
    concat('{"duration":', toString(rand() % 3600), ',"success":', cast((rand() % 2) = 1 AS String), ',"interaction_count":', toString(rand() % 50), '}') AS metadata
FROM numbers(10)