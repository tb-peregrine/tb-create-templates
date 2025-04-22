SELECT
    concat('user_', toString(rand() % 10000)) AS user_id,
    now() - toIntervalDay(rand() % 60) - toIntervalHour(rand() % 24) - toIntervalMinute(rand() % 60) AS signup_timestamp,
    ['organic_search', 'social_media', 'email', 'direct', 'referral', 'paid_search'][1 + rand() % 6] AS acquisition_channel,
    ['summer_promo', 'black_friday', 'new_product', 'brand_awareness', 'retargeting'][1 + rand() % 5] AS campaign,
    ['mobile', 'desktop', 'tablet'][1 + rand() % 3] AS device_type,
    ['US', 'UK', 'Canada', 'Germany', 'France', 'Japan', 'Australia', 'Brazil', 'India'][1 + rand() % 9] AS country,
    ['google.com', 'facebook.com', 'twitter.com', 'instagram.com', 'linkedin.com', 'youtube.com', 'direct'][1 + rand() % 7] AS referrer,
    ['google', 'facebook', 'twitter', 'instagram', 'linkedin', 'newsletter', 'partner'][1 + rand() % 7] AS utm_source,
    ['cpc', 'email', 'social', 'display', 'affiliate', 'organic'][1 + rand() % 6] AS utm_medium,
    ['spring_sale', 'summer_promo', 'new_features', 'brand', 'product_launch'][1 + rand() % 5] AS utm_campaign,
    rand() % 2 AS conversion
FROM numbers(10)