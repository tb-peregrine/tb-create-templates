SELECT
    concat('click_', toString(rand() % 100000)) AS click_id,
    concat('imp_', toString(rand() % 100000)) AS impression_id,
    concat('ad_', toString(rand() % 1000)) AS ad_id,
    concat('camp_', toString(rand() % 100)) AS campaign_id,
    ['facebook', 'google', 'twitter', 'instagram', 'tiktok'][(rand() % 5) + 1] AS platform,
    now() - toIntervalSecond(rand() % 86400) AS timestamp,
    concat('user_', toString(rand() % 5000)) AS user_id,
    ['US', 'UK', 'CA', 'AU', 'DE', 'FR', 'JP', 'BR', 'IN', 'MX'][(rand() % 10) + 1] AS country,
    ['mobile', 'desktop', 'tablet'][(rand() % 3) + 1] AS device_type
FROM numbers(10)