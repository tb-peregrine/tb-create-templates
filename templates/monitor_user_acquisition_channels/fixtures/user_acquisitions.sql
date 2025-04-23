SELECT
    concat('user_', toString(rand() % 10000)) AS user_id,
    ['google', 'facebook', 'twitter', 'instagram', 'tiktok', 'linkedin', 'email', 'organic', 'referral', 'direct'][(rand() % 10) + 1] AS channel,
    ['summer_sale', 'black_friday', 'new_year', 'product_launch', 'retargeting', 'brand_awareness'][(rand() % 6) + 1] AS campaign,
    now() - toIntervalDay(rand() % 90) AS acquisition_date,
    round(10 + rand() % 990, 2) AS cost,
    ['US', 'CA', 'UK', 'DE', 'FR', 'JP', 'AU', 'BR', 'IN', 'MX'][(rand() % 10) + 1] AS country
FROM numbers(10)