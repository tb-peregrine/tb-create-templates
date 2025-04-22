SELECT
    concat('evt_', toString(rand() % 100000)) AS event_id,
    concat('cust_', toString(rand() % 5000)) AS customer_id,
    ['page_view', 'purchase', 'add_to_cart', 'product_view', 'checkout'][rand() % 5 + 1] AS event_type,
    now() - toIntervalMinute(rand() % 10080) AS event_timestamp,
    concat('sess_', toString(rand() % 10000)) AS session_id,
    concat('https://example.com/', ['products', 'categories', 'checkout', 'cart', 'home'][rand() % 5 + 1], '/', toString(rand() % 100)) AS page_url,
    concat('prod_', toString(rand() % 500)) AS product_id,
    concat('cat_', toString(rand() % 20)) AS category_id,
    round(10 + rand() % 990, 2) AS price,
    1 + rand() % 5 AS quantity,
    ['desktop', 'mobile', 'tablet'][rand() % 3 + 1] AS device_type,
    ['US', 'UK', 'CA', 'DE', 'FR', 'JP', 'AU'][rand() % 7 + 1] AS country,
    ['google.com', 'facebook.com', 'twitter.com', 'instagram.com', 'direct'][rand() % 5 + 1] AS referrer,
    ['Mozilla/5.0', 'Chrome/91.0', 'Safari/605.1', 'Edge/91.0', 'Firefox/89.0'][rand() % 5 + 1] AS user_agent
FROM numbers(10)