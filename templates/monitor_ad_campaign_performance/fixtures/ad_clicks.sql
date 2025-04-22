SELECT
    concat('clk_', lower(hex(randomString(8)))) AS click_id,
    concat('imp_', lower(hex(randomString(8)))) AS impression_id,
    concat('camp_', toString(rand() % 10 + 1)) AS campaign_id,
    concat('ad_', toString(rand() % 50 + 1)) AS ad_id,
    concat('user_', toString(rand() % 1000 + 1)) AS user_id,
    now() - toIntervalSecond(rand() % 2592000) AS timestamp,
    ['web', 'mobile_app', 'social_media'][(rand() % 3) + 1] AS platform,
    ['desktop', 'mobile', 'tablet', 'smart_tv'][(rand() % 4) + 1] AS device,
    ['US', 'UK', 'CA', 'FR', 'DE', 'JP', 'AU', 'BR', 'IN', 'ES'][(rand() % 10) + 1] AS country
FROM numbers(10)