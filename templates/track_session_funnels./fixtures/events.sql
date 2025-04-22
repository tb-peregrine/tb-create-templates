SELECT
    concat('evt_', toString(rand() % 1000000)) AS event_id,
    concat('usr_', toString(rand() % 10000)) AS user_id,
    concat('sess_', toString(rand() % 50000)) AS session_id,
    ['pageview', 'click', 'scroll', 'form_submit', 'purchase', 'login', 'signup', 'add_to_cart'][(rand() % 8) + 1] AS event_type,
    ['Home Page View', 'Product Click', 'Page Scroll', 'Contact Form Submit', 'Purchase Complete', 'User Login', 'New Signup', 'Add Item to Cart'][(rand() % 8) + 1] AS event_name,
    now() - toIntervalSecond(rand() % 604800) AS timestamp,
    ['https://example.com/', 'https://example.com/products', 'https://example.com/checkout', 'https://example.com/profile', 'https://example.com/about'][(rand() % 5) + 1] AS page_url,
    ['direct', 'google.com', 'facebook.com', 'twitter.com', 'instagram.com', ''][(rand() % 6) + 1] AS referrer,
    ['mobile', 'desktop', 'tablet'][(rand() % 3) + 1] AS device,
    ['Chrome', 'Firefox', 'Safari', 'Edge', 'Opera'][(rand() % 5) + 1] AS browser,
    ['Windows', 'MacOS', 'iOS', 'Android', 'Linux'][(rand() % 5) + 1] AS os,
    ['US', 'UK', 'CA', 'DE', 'FR', 'JP', 'AU', 'BR', 'IN'][(rand() % 9) + 1] AS country,
    ['New York', 'London', 'Toronto', 'Berlin', 'Paris', 'Tokyo', 'Sydney', 'São Paulo', 'Mumbai'][(rand() % 9) + 1] AS city,
    concat('{"value":', toString(rand() % 1000), ', "items":', toString(rand() % 10), ', "duration":', toString(rand() % 300), '}') AS properties
FROM numbers(10)