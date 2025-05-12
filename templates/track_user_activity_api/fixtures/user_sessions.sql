SELECT
    concat('sess_', lower(hex(randomString(8)))) AS session_id,
    concat('user_', toString(rand() % 1000)) AS user_id,
    concat('tenant_', toString(rand() % 100)) AS tenant_id,
    ['pageview', 'click', 'form_submit', 'login', 'logout'][(rand() % 5) + 1] AS event_type,
    concat('{"action":"', ['view', 'search', 'purchase', 'navigate', 'download'][(rand() % 5) + 1], '","target":"', ['home', 'product', 'cart', 'profile', 'settings'][(rand() % 5) + 1], '"}') AS event_data,
    concat('https://example.com/', ['home', 'products', 'about', 'contact', 'dashboard', 'settings'][(rand() % 6) + 1]) AS page_url,
    concat('https://example.com/', ['home', 'products', 'search', 'external', 'social'][(rand() % 5) + 1]) AS referrer,
    ['desktop', 'mobile', 'tablet'][(rand() % 3) + 1] AS device_type,
    ['Chrome', 'Firefox', 'Safari', 'Edge'][(rand() % 4) + 1] AS browser,
    concat('192.168.', toString(rand() % 255), '.', toString(rand() % 255)) AS ip_address,
    now() - toIntervalDay(rand() % 30) AS created_at,
    now() - toIntervalDay(rand() % 15) AS updated_at
FROM numbers(10)