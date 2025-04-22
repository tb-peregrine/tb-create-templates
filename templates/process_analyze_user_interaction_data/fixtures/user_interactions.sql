SELECT
    concat('evt_', lower(hex(randomString(8)))) AS event_id,
    concat('user_', toString(1000 + rand() % 9000)) AS user_id,
    now() - toIntervalSecond(rand() % (86400 * 30)) AS timestamp,
    ['page_view', 'click', 'scroll', 'form_submit', 'video_play', 'button_click'][1 + rand() % 6] AS event_type,
    ['/home', '/products', '/about', '/contact', '/blog', '/checkout', '/cart'][1 + rand() % 7] AS page,
    concat('sess_', lower(hex(randomString(6)))) AS session_id,
    round(5 + rand() % 300 + rand(), 2) AS duration_seconds,
    round(rand() % 100 / 10, 1) AS engagement_score,
    ['desktop', 'mobile', 'tablet'][1 + rand() % 3] AS device_type,
    ['Chrome', 'Firefox', 'Safari', 'Edge', 'Opera'][1 + rand() % 5] AS browser,
    ['US', 'UK', 'Canada', 'Germany', 'France', 'Japan', 'Australia', 'Brazil', 'India'][1 + rand() % 9] AS country,
    ['google.com', 'facebook.com', 'twitter.com', 'instagram.com', 'direct', 'email', 'linkedin.com'][1 + rand() % 7] AS referrer
FROM numbers(10)