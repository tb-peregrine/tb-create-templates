SELECT
    concat('imp_', toString(rand() % 1000000)) AS impression_id,
    concat('camp_', toString(rand() % 100)) AS campaign_id,
    concat('ad_', toString(rand() % 500)) AS ad_id,
    concat('user_', toString(rand() % 10000)) AS user_id,
    now() - toIntervalSecond(rand() % 2592000) AS timestamp,
    ['mobile', 'web', 'app'][rand() % 3 + 1] AS platform,
    ['smartphone', 'tablet', 'desktop', 'tv'][rand() % 4 + 1] AS device,
    ['US', 'UK', 'CA', 'DE', 'FR', 'JP', 'AU', 'BR', 'IN', 'MX'][rand() % 10 + 1] AS country,
    round(rand() % 10 + rand(), 2) AS cost
FROM numbers(10)