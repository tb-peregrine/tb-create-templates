SELECT
    concat('evt_', toString(rand() % 100000)) AS event_id,
    concat('user_', toString(rand() % 1000)) AS user_id,
    concat('sess_', toString(rand() % 5000)) AS session_id,
    now() - toIntervalSecond(rand() % 86400) AS timestamp,
    ['page_view', 'click', 'form_submit', 'purchase', 'login', 'logout', 'add_to_cart'][rand() % 7 + 1] AS event_type,
    concat('https://example.com/', ['home', 'products', 'cart', 'checkout', 'profile', 'blog', 'contact'][rand() % 7 + 1]) AS page_url,
    concat(['Home', 'Products', 'Shopping Cart', 'Checkout', 'User Profile', 'Blog', 'Contact Us'][rand() % 7 + 1], ' | Example Store') AS page_title,
    ['https://google.com', 'https://facebook.com', 'https://twitter.com', 'https://instagram.com', 'https://example.com/home', ''][rand() % 6 + 1] AS referrer,
    ['desktop', 'mobile', 'tablet'][rand() % 3 + 1] AS device_type,
    ['Chrome', 'Firefox', 'Safari', 'Edge'][rand() % 4 + 1] AS browser,
    ['Windows', 'macOS', 'iOS', 'Android', 'Linux'][rand() % 5 + 1] AS os,
    ['US', 'UK', 'CA', 'DE', 'FR', 'JP', 'AU', 'BR', 'IN'][rand() % 9 + 1] AS country,
    concat(['Mozilla/5.0', 'AppleWebKit/537.36', 'Chrome/91.0', 'Safari/537.36', 'Edge/91.0'][rand() % 5 + 1], ' ', ['Windows NT 10.0', 'Macintosh', 'iPhone', 'Android 10'][rand() % 4 + 1]) AS user_agent,
    concat('{"product_id":"', toString(rand() % 1000), '","category":"', ['electronics', 'clothing', 'food', 'books', 'toys'][rand() % 5 + 1], '","value":', toString(rand() % 200), '}') AS properties
FROM numbers(10)
