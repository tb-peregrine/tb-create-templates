SELECT
    concat('evt_', lower(hex(randomString(8)))) AS event_id,
    concat('user_', toString(rand() % 10000)) AS user_id,
    now() - toIntervalSecond(rand() % (86400 * 30)) AS timestamp,
    ['organic_search', 'paid_search', 'social', 'email', 'direct', 'referral', 'display', 'affiliate'][rand() % 8 + 1] AS channel,
    ['summer_sale', 'black_friday', 'new_user', 'retargeting', 'holiday_special', 'product_launch'][rand() % 6 + 1] AS campaign,
    ['purchase', 'signup', 'download', 'subscription', 'lead', 'page_view'][rand() % 6 + 1] AS conversion_type,
    round(rand() % 1000 + rand(), 2) AS revenue,
    ['desktop', 'mobile', 'tablet'][rand() % 3 + 1] AS device,
    ['US', 'UK', 'CA', 'DE', 'FR', 'JP', 'AU', 'IN', 'BR', 'MX'][rand() % 10 + 1] AS country,
    ['google', 'facebook', 'instagram', 'twitter', 'email', 'bing', 'direct', 'partner'][rand() % 8 + 1] AS utm_source,
    ['cpc', 'organic', 'email', 'social', 'display', 'referral', 'direct'][rand() % 7 + 1] AS utm_medium,
    ['spring_promo', 'summer_sale', 'fall_deals', 'winter_special', 'new_product'][rand() % 5 + 1] AS utm_campaign,
    ['banner', 'text_ad', 'video', 'image', 'carousel'][rand() % 5 + 1] AS utm_content,
    ['brand', 'product', 'discount', 'sale', 'free'][rand() % 5 + 1] AS utm_term
FROM numbers(10)