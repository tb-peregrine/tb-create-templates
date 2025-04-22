SELECT
    concat('user_', toString(rand() % 1000)) AS user_id,
    ['click', 'view', 'hover', 'scroll', 'submit'][rand() % 5 + 1] AS event_type,
    ['login', 'search', 'filter', 'add_to_cart', 'checkout', 'share', 'comment'][rand() % 7 + 1] AS event_name,
    concat('feature_', toString(rand() % 50)) AS feature_id,
    concat('session_', toString(rand() % 5000)) AS session_id,
    now() - toIntervalSecond(rand() % 604800) AS timestamp,
    ['iOS', 'Android', 'Web', 'Desktop'][rand() % 4 + 1] AS platform,
    ['mobile', 'tablet', 'desktop', 'smart_tv'][rand() % 4 + 1] AS device_type,
    concat(toString(rand() % 10), '.', toString(rand() % 10), '.', toString(rand() % 10)) AS version,
    rand() % 10000 AS duration_ms,
    concat('{"status":"', ['success', 'error', 'pending'][rand() % 3 + 1], '","value":', toString(rand() % 100), '}') AS properties
FROM numbers(10)