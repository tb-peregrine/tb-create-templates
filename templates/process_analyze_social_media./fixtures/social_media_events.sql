SELECT
    concat('evt_', toString(randomPrintableASCII(8))) AS event_id,
    ['Facebook', 'Twitter', 'Instagram', 'LinkedIn', 'TikTok', 'YouTube'][1 + rand() % 6] AS platform,
    concat('user_', toString(rand() % 1000)) AS user_id,
    concat('content_', toString(rand() % 5000)) AS content_id,
    ['view', 'like', 'share', 'comment', 'click', 'follow'][1 + rand() % 6] AS event_type,
    now() - toIntervalDay(rand() % 30) - toIntervalHour(rand() % 24) AS event_timestamp,
    rand() % 100 AS engagement_value,
    ['mobile', 'desktop', 'tablet', 'smart_tv'][1 + rand() % 4] AS device_type,
    ['US', 'UK', 'CA', 'IN', 'DE', 'FR', 'BR', 'JP'][1 + rand() % 8] AS country,
    ['direct', 'search', 'social', 'email', 'referral'][1 + rand() % 5] AS referrer
FROM numbers(10)