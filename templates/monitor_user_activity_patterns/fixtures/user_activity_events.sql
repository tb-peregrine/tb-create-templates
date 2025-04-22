SELECT
    concat('evt_', toString(rand() % 100000)) AS event_id,
    concat('user_', toString(rand() % 1000)) AS user_id,
    concat('sess_', toString(rand() % 5000)) AS session_id,
    ['pageview', 'click', 'scroll', 'form_submit', 'login', 'logout', 'purchase', 'add_to_cart'][rand() % 8 + 1] AS event_type,
    ['Home Page View', 'Product Click', 'Scroll Depth', 'Contact Form Submit', 'User Login', 'User Logout', 'Complete Purchase', 'Add Item to Cart'][rand() % 8 + 1] AS event_name,
    concat('https://example.com/', ['home', 'products', 'about', 'contact', 'cart', 'checkout', 'profile', 'login'][rand() % 8 + 1]) AS page_url,
    concat('https://', ['google.com', 'facebook.com', 'twitter.com', 'instagram.com', 'example.com/home', 'direct', 'email', 'ad'][rand() % 8 + 1]) AS referrer_url,
    now() - toIntervalSecond(rand() % 86400) AS timestamp,
    concat(['Mozilla/5.0 (Windows NT 10.0)', 'Mozilla/5.0 (Macintosh; Intel Mac OS X)', 'Mozilla/5.0 (iPhone; CPU iPhone OS)', 'Mozilla/5.0 (Linux; Android)'][rand() % 4 + 1], ' ', ['Chrome/90.0', 'Safari/605.1', 'Firefox/89.0', 'Edge/91.0'][rand() % 4 + 1]) AS user_agent,
    concat(['192.168.', '10.0.', '172.16.', '8.8.'][rand() % 4 + 1], toString(rand() % 256), '.', toString(rand() % 256)) AS ip_address,
    ['desktop', 'mobile', 'tablet', 'smart tv'][rand() % 4 + 1] AS device_type,
    ['United States', 'United Kingdom', 'Canada', 'Australia', 'Germany', 'France', 'Japan', 'Brazil', 'India', 'China'][rand() % 10 + 1] AS country,
    ['New York', 'London', 'Toronto', 'Sydney', 'Berlin', 'Paris', 'Tokyo', 'Sao Paulo', 'Mumbai', 'Beijing'][rand() % 10 + 1] AS city,
    concat('{"duration":', toString(rand() % 300), ',"value":', toString(rand() % 1000 / 10), ',"items":', toString(rand() % 5), '}') AS properties
FROM numbers(10)