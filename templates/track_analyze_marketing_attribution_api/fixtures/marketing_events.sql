SELECT
    concat('evt_', toString(rand() % 100000)) AS event_id,
    concat('user_', toString(rand() % 10000)) AS user_id,
    concat('cmp_', toString(rand() % 100)) AS campaign_id,
    ['email', 'social', 'search', 'display', 'affiliate'][rand() % 5 + 1] AS channel,
    ['view', 'click', 'form_submit', 'purchase', 'share'][rand() % 5 + 1] AS action,
    now() - toIntervalDay(rand() % 30) - toIntervalHour(rand() % 24) - toIntervalMinute(rand() % 60) AS timestamp,
    ['google', 'facebook', 'twitter', 'instagram', 'linkedin'][rand() % 5 + 1] AS utm_source,
    ['cpc', 'organic', 'email', 'referral', 'social'][rand() % 5 + 1] AS utm_medium,
    ['summer_sale', 'new_product', 'holiday_special', 'brand_awareness', 'retargeting'][rand() % 5 + 1] AS utm_campaign,
    ['mobile', 'desktop', 'tablet'][rand() % 3 + 1] AS device_type,
    ['US', 'UK', 'CA', 'DE', 'FR', 'JP', 'AU', 'BR', 'IN'][rand() % 9 + 1] AS country,
    ['direct', 'google.com', 'facebook.com', 'twitter.com', 'linkedin.com'][rand() % 5 + 1] AS referrer,
    round(rand() * 200, 2) AS conversion_value
FROM numbers(10)