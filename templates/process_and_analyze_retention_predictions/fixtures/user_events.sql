SELECT
    concat('user_', toString(rand() % 1000)) AS user_id,
    ['signup', 'login', 'purchase', 'view_content', 'logout', 'search', 'add_to_cart'][rand() % 7 + 1] AS event_type,
    now() - rand() % (86400 * 30) AS timestamp,
    concat('session_', toString(rand() % 5000)) AS session_id,
    ['ios', 'android', 'web', 'desktop'][rand() % 4 + 1] AS platform,
    ['US', 'UK', 'CA', 'DE', 'FR', 'JP', 'BR', 'IN', 'AU', 'ES'][rand() % 10 + 1] AS country,
    ['mobile', 'tablet', 'desktop', 'tv'][rand() % 4 + 1] AS device_type,
    concat(toString(rand() % 5), '.', toString(rand() % 10), '.', toString(rand() % 10)) AS app_version
FROM numbers(10)