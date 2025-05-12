SELECT
    concat('evt_', toString(rand() % 1000000)) AS event_id,
    concat('user_', toString(rand() % 10000)) AS user_id,
    concat('sess_', toString(rand() % 50000)) AS session_id,
    ['pageview', 'click', 'signup', 'login', 'purchase', 'logout', 'search'][rand() % 7 + 1] AS event_type,
    ['dashboard', 'profile', 'settings', 'billing', 'reports', 'home', 'products'][rand() % 7 + 1] AS feature,
    now() - toIntervalSecond(rand() % 86400) AS timestamp,
    ['desktop', 'mobile', 'tablet'][rand() % 3 + 1] AS device_type,
    ['Chrome', 'Firefox', 'Safari', 'Edge'][rand() % 4 + 1] AS browser,
    ['Windows', 'MacOS', 'Linux', 'iOS', 'Android'][rand() % 5 + 1] AS os,
    ['US', 'UK', 'Germany', 'France', 'Japan', 'Australia', 'Canada', 'Brazil'][rand() % 8 + 1] AS location,
    concat('{"subscription_tier":"', ['free', 'basic', 'premium', 'enterprise'][rand() % 4 + 1], '","duration":', toString(rand() % 600 + 10), '}') AS metadata
FROM numbers(10)