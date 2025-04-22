SELECT
    concat('user_', toString(rand() % 1000)) AS user_id,
    concat('prod_', toString(rand() % 50)) AS product_id,
    ['view', 'click', 'purchase', 'share', 'favorite'][(rand() % 5) + 1] AS action,
    now() - toIntervalDay(rand() % 30) - toIntervalHour(rand() % 24) AS timestamp,
    ['search', 'filter', 'sort', 'compare', 'checkout', 'save'][(rand() % 6) + 1] AS feature_used,
    60 + rand() % 3600 AS session_duration,
    ['mobile', 'desktop', 'tablet', 'app'][(rand() % 4) + 1] AS device_type,
    concat(toString(rand() % 3 + 1), '.', toString(rand() % 10), '.', toString(rand() % 10)) AS version,
    ['US', 'UK', 'CA', 'DE', 'FR', 'JP', 'AU', 'BR', 'IN'][(rand() % 9) + 1] AS country,
    ['direct', 'google', 'facebook', 'twitter', 'email', 'affiliate'][(rand() % 6) + 1] AS referrer
FROM numbers(10)