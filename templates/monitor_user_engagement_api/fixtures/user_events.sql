SELECT
    concat('evt-', lower(hex(randomString(8)))) AS event_id,
    concat('user-', toString(rand() % 1000)) AS user_id,
    ['page_view', 'click', 'scroll', 'form_submit', 'video_play', 'video_pause'][1 + rand() % 6] AS event_type,
    now() - toIntervalSecond(rand() % 86400) AS timestamp,
    concat('sess-', lower(hex(randomString(6)))) AS session_id,
    ['/home', '/products', '/about', '/contact', '/blog', '/checkout'][1 + rand() % 6] AS page,
    10 + rand() % 300 AS duration,
    ['desktop', 'mobile', 'tablet'][1 + rand() % 3] AS device_type,
    ['US', 'UK', 'CA', 'FR', 'DE', 'JP', 'AU', 'BR', 'IN', 'ES'][1 + rand() % 10] AS country,
    ['Windows', 'MacOS', 'Linux', 'iOS', 'Android'][1 + rand() % 5] AS os,
    ['Chrome', 'Firefox', 'Safari', 'Edge', 'Opera'][1 + rand() % 5] AS browser
FROM numbers(10)