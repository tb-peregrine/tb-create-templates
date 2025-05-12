SELECT
    concat('ev_', toString(rand() % 100000)) AS event_id,
    concat('user_', toString(rand() % 1000)) AS user_id,
    concat('sess_', toString(rand() % 5000)) AS session_id,
    ['page_view', 'click', 'scroll', 'form_submission', 'add_to_cart', 'purchase'][1 + rand() % 6] AS event_type,
    concat('https://example.com/', ['home', 'products', 'about', 'contact', 'blog', 'cart', 'checkout'][1 + rand() % 7]) AS page_url,
    concat(['Home', 'Products', 'About Us', 'Contact', 'Blog', 'Shopping Cart', 'Checkout'][1 + rand() % 7], ' Page') AS page_title,
    ['https://google.com', 'https://facebook.com', 'https://twitter.com', 'https://instagram.com', '', 'https://example.com/home'][1 + rand() % 6] AS referrer,
    now() - toIntervalMinute(rand() % 10080) AS timestamp,
    ['desktop', 'mobile', 'tablet'][1 + rand() % 3] AS device_type,
    ['Chrome', 'Firefox', 'Safari', 'Edge', 'Opera'][1 + rand() % 5] AS browser,
    concat('{"browser_version":"', toString(rand() % 15 + 1), '.0", "screen_size":"', toString(1024 + rand() % 1000), 'x', toString(768 + rand() % 500), '"}') AS properties
FROM numbers(10)