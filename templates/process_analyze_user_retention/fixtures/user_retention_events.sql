SELECT
    concat('user_', toString(rand() % 1000)) AS user_id,
    now() - toIntervalDay(rand() % 30) - toIntervalHour(rand() % 24) AS event_date,
    now() - toIntervalDay(rand() % 90) - toIntervalHour(rand() % 24) AS first_seen_date,
    ['signup', 'login', 'purchase', 'page_view', 'logout'][(rand() % 5) + 1] AS event_type,
    ['ios', 'android', 'web', 'desktop'][(rand() % 4) + 1] AS platform,
    ['US', 'UK', 'CA', 'FR', 'DE', 'JP', 'BR', 'IN', 'AU', 'MX'][(rand() % 10) + 1] AS country,
    concat('session_', toString(rand() % 5000)) AS session_id
FROM numbers(10)