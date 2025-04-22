SELECT
    concat('user_', toString(rand() % 1000)) AS user_id,
    ['pageview', 'click', 'search', 'purchase', 'signup'][rand() % 5 + 1] AS event_type,
    now() - toIntervalSecond(rand() % (86400 * 30)) AS timestamp,
    concat('session_', toString(rand() % 5000)) AS session_id,
    ['/home', '/products', '/cart', '/checkout', '/profile', '/about'][rand() % 6 + 1] AS page,
    ['direct', 'google.com', 'facebook.com', 'twitter.com', 'instagram.com', 'email'][rand() % 6 + 1] AS referrer,
    ['desktop', 'mobile', 'tablet'][rand() % 3 + 1] AS device_type,
    ['US', 'UK', 'CA', 'FR', 'DE', 'JP', 'AU', 'BR', 'IN', 'ES'][rand() % 10 + 1] AS country,
    round(rand() * 300, 2) AS duration,
    rand() % 20 AS clicks
FROM numbers(10)