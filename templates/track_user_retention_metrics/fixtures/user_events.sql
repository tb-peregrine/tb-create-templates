SELECT
    concat('ev_', toString(rand() % 100000)) AS event_id,
    concat('user_', toString(rand() % 1000)) AS user_id,
    ['page_view', 'click', 'purchase', 'login', 'logout', 'signup'][(rand() % 6) + 1] AS event_type,
    now() - rand() % 604800 AS timestamp,
    concat('sess_', toString(rand() % 50000)) AS session_id,
    ['web', 'ios', 'android', 'desktop'][(rand() % 4) + 1] AS platform,
    ['US', 'UK', 'CA', 'DE', 'FR', 'JP', 'AU', 'BR', 'IN', 'MX'][(rand() % 10) + 1] AS country
FROM numbers(10)