
SELECT
    concat('conv_', toString(rand() % 1000000)) AS conversion_id,
    concat('user_', toString(rand() % 50000)) AS user_id,
    ['purchase', 'sign_up', 'subscription', 'download', 'registration'][(rand() % 5) + 1] AS conversion_type,
    round(10 + rand() % 990, 2) AS conversion_value,
    now() - toIntervalDay(rand() % 90) - toIntervalHour(rand() % 24) AS timestamp,
    concat('camp_', toString(rand() % 100)) AS campaign_id,
    ['email', 'social_media', 'search', 'referral', 'direct', 'display'][(rand() % 6) + 1] AS channel
FROM numbers(10)
    