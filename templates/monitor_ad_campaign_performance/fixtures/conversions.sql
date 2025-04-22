SELECT
    concat('conv_', toString(rand() % 100000)) AS conversion_id,
    concat('click_', toString(rand() % 100000)) AS click_id,
    concat('camp_', toString(rand() % 1000)) AS campaign_id,
    concat('user_', toString(rand() % 10000)) AS user_id,
    ['purchase', 'signup', 'download', 'subscription', 'lead'][rand() % 5 + 1] AS conversion_type,
    round(rand() % 1000 + rand(), 2) AS revenue,
    now() - toIntervalDay(rand() % 30) - toIntervalHour(rand() % 24) AS timestamp,
    ['web', 'mobile_app', 'social'][rand() % 3 + 1] AS platform,
    ['desktop', 'mobile', 'tablet', 'smart_tv'][rand() % 4 + 1] AS device,
    ['US', 'UK', 'CA', 'DE', 'FR', 'JP', 'BR', 'IN', 'AU'][rand() % 9 + 1] AS country
FROM numbers(10)