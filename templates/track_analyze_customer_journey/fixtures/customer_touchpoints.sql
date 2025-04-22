SELECT
    concat('cust_', toString(rand() % 1000)) AS customer_id,
    concat('sess_', toString(rand() % 10000)) AS session_id,
    now() - toIntervalDay(rand() % 30) - toIntervalHour(rand() % 24) - toIntervalMinute(rand() % 60) AS timestamp,
    concat('touch_', toString(rand() % 500)) AS touchpoint_id,
    ['product_view', 'add_to_cart', 'checkout', 'purchase', 'email_open', 'ad_click'][1 + rand() % 6] AS touchpoint_type,
    ['web', 'mobile_app', 'email', 'social', 'search', 'direct'][1 + rand() % 6] AS channel,
    ['desktop', 'mobile', 'tablet', 'smart_tv'][1 + rand() % 4] AS device,
    concat('camp_', toString(rand() % 100)) AS campaign_id,
    rand() % 2 AS conversion,
    round(rand() % 1000 + rand(), 2) AS transaction_amount,
    ['google.com', 'facebook.com', 'instagram.com', 'twitter.com', 'direct', 'email'][1 + rand() % 6] AS referrer,
    concat('https://example.com/', ['products', 'checkout', 'cart', 'home', 'blog'][1 + rand() % 5], '/', toString(rand() % 100)) AS page_url,
    rand() % 600 + 5 AS time_spent,
    ['view', 'click', 'scroll', 'submit', 'purchase'][1 + rand() % 5] AS action,
    concat('{"user_agent":"Mozilla/5.0", "browser":"', ['Chrome', 'Firefox', 'Safari', 'Edge'][1 + rand() % 4], '", "os":"', ['Windows', 'MacOS', 'iOS', 'Android'][1 + rand() % 4], '"}') AS metadata
FROM numbers(10)