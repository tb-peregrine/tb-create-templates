SELECT
    concat('evt_', toString(rand() % 10000)) AS event_id,
    concat('user_', toString(rand() % 1000)) AS user_id,
    concat('content_', toString(rand() % 500)) AS content_id,
    ['view', 'like', 'share', 'comment'][1 + rand() % 4] AS event_type,
    now() - toIntervalSecond(rand() % 86400) AS event_time,
    ['video', 'article', 'image', 'audio'][1 + rand() % 4] AS content_type,
    ['news', 'entertainment', 'sports', 'technology', 'lifestyle'][1 + rand() % 5] AS content_category,
    concat('sess_', toString(rand() % 5000)) AS session_id,
    10 + rand() % 300 AS time_spent,
    ['direct', 'social_media', 'search_engine', 'email', 'referral'][1 + rand() % 5] AS referrer
FROM numbers(10)