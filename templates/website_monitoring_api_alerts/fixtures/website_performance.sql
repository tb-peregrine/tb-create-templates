SELECT
    now() - toIntervalSecond(rand() % 86400) AS timestamp,
    concat('site_', toString(1 + rand() % 5)) AS website_id,
    concat('https://example.com/', ['home', 'products', 'about', 'contact', 'blog'][(rand() % 5) + 1], if(rand() % 3 = 0, concat('/', ['details', 'category', 'item'][(rand() % 3) + 1]), '')) AS page_url,
    200 + rand() % 3000 AS page_load_time_ms,
    50 + rand() % 500 AS server_response_time_ms,
    100 + rand() % 1000 AS dom_interactive_time_ms,
    5 + rand() % 50 AS request_count,
    rand() % 5 AS error_count,
    concat('user_', toString(rand() % 1000)) AS user_id,
    ['desktop', 'mobile', 'tablet'][(rand() % 3) + 1] AS device_type,
    ['Chrome', 'Firefox', 'Safari', 'Edge'][(rand() % 4) + 1] AS browser,
    ['US', 'UK', 'CA', 'DE', 'FR', 'JP', 'AU'][(rand() % 7) + 1] AS country,
    multiIf(rand() % 10 = 0, 500, rand() % 20 = 0, 404, rand() % 30 = 0, 403, 200) AS status_code
FROM numbers(10)