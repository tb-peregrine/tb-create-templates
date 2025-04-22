SELECT
    concat('evt_', toString(rand() % 1000000)) AS event_id,
    concat('user_', toString(rand() % 10000)) AS user_id,
    ['page_view', 'sign_up', 'add_to_cart', 'checkout', 'purchase'][(rand() % 5) + 1] AS event_name,
    now() - rand() % (86400 * 30) AS event_timestamp,
    concat('sess_', toString(rand() % 50000)) AS session_id,
    ['mobile', 'desktop', 'tablet'][(rand() % 3) + 1] AS device,
    ['Chrome', 'Firefox', 'Safari', 'Edge'][(rand() % 4) + 1] AS browser,
    ['US', 'UK', 'CA', 'DE', 'FR', 'JP', 'AU', 'BR', 'IN'][(rand() % 9) + 1] AS country,
    ['google.com', 'facebook.com', 'twitter.com', 'instagram.com', 'direct', 'email'][(rand() % 6) + 1] AS referrer,
    concat('{"page":"', ['home', 'products', 'cart', 'checkout', 'confirmation'][(rand() % 5) + 1], '","value":', toString(rand() % 200), '}') AS properties
FROM numbers(10)