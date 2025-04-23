SELECT
    concat('evt_', lower(hex(randomString(8)))) AS event_id,
    concat('user_', toString(1000 + rand() % 9000)) AS user_id,
    concat('prod_', toString(100 + rand() % 900)) AS product_id,
    ['page_view', 'button_click', 'form_submit', 'login', 'signup', 'checkout', 'search', 'download', 'upload', 'product_view'][rand() % 10 + 1] AS event_type,
    now() - rand() % (86400 * 30) AS event_timestamp,
    ['desktop', 'mobile', 'tablet', 'smart_tv', 'console'][rand() % 5 + 1] AS device_type,
    ['ios', 'android', 'web', 'macos', 'windows', 'linux'][rand() % 6 + 1] AS platform,
    concat(toString(rand() % 3 + 1), '.', toString(rand() % 10), '.', toString(rand() % 10)) AS version,
    concat('sess_', lower(hex(randomString(6)))) AS session_id,
    10 + rand() % 3600 AS duration_seconds,
    ['search', 'filtering', 'recommendation', 'checkout', 'account_settings', 'wishlist', 'reviews', 'sharing', 'notifications', 'messaging'][rand() % 10 + 1] AS feature_used,
    ['/', '/products', '/product/detail', '/cart', '/checkout', '/account', '/settings', '/login', '/signup', '/help'][rand() % 10 + 1] AS page_path,
    concat('{"referrer":"', ['direct', 'google', 'facebook', 'twitter', 'email', 'affiliate'][rand() % 6 + 1], '","browser":"', ['chrome', 'safari', 'firefox', 'edge', 'other'][rand() % 5 + 1], '"}') AS metadata
FROM numbers(10)