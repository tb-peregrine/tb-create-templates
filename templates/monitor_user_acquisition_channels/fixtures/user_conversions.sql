SELECT
    concat('user_', toString(rand() % 10000)) AS user_id,
    now() - rand() % (86400 * 60) AS conversion_date,
    ['purchase', 'signup', 'subscription', 'renewal', 'upsell'][(rand() % 5) + 1] AS conversion_type,
    round(rand() * 1000, 2) AS revenue,
    ['US', 'UK', 'CA', 'DE', 'FR', 'JP', 'AU', 'BR', 'IN', 'MX'][(rand() % 10) + 1] AS country
FROM numbers(10)