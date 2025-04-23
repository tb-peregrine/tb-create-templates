SELECT
    concat('evt_', toString(rand() % 1000000)) AS event_id,
    concat('user_', toString(rand() % 10000)) AS user_id,
    ['page_view', 'click', 'form_submit', 'purchase', 'login', 'logout', 'add_to_cart'][(rand() % 7) + 1] AS event_type,
    now() - toIntervalSecond(rand() % 2592000) AS timestamp,
    concat('sess_', toString(rand() % 50000)) AS session_id,
    ['/home', '/products', '/cart', '/checkout', '/login', '/account', '/contact'][(rand() % 7) + 1] AS page,
    ['direct', 'google.com', 'facebook.com', 'twitter.com', 'instagram.com', 'email'][(rand() % 6) + 1] AS referrer,
    ['mobile', 'desktop', 'tablet'][(rand() % 3) + 1] AS device,
    ['Windows', 'macOS', 'iOS', 'Android', 'Linux'][(rand() % 5) + 1] AS os,
    ['Chrome', 'Firefox', 'Safari', 'Edge', 'Opera'][(rand() % 5) + 1] AS browser,
    ['US', 'UK', 'Canada', 'Germany', 'France', 'Japan', 'Australia', 'Brazil'][(rand() % 8) + 1] AS country,
    ['New York', 'London', 'Toronto', 'Berlin', 'Paris', 'Tokyo', 'Sydney', 'Sao Paulo'][(rand() % 8) + 1] AS city,
    concat('{"duration":', toString(rand() % 300), ',"value":', toString(toFloat64(rand() % 10000) / 100), '}') AS properties
FROM numbers(10)