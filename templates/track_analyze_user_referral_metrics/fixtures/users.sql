SELECT
    concat('user_', toString(rand() % 10000)) AS user_id,
    concat('user', toString(rand() % 1000), '@example.com') AS email,
    now() - toIntervalDay(rand() % 365) AS signup_date,
    ['organic', 'google', 'facebook', 'twitter', 'referral'][(rand() % 5) + 1] AS acquisition_source,
    concat('REF', toString(rand() % 100000)) AS referral_code,
    concat('user_', toString(rand() % 10000)) AS referred_by,
    round(rand() % 1000 + rand(), 2) AS lifetime_value,
    rand() % 2 AS active,
    ['US', 'UK', 'CA', 'DE', 'FR', 'ES', 'JP', 'AU', 'BR', 'IN'][(rand() % 10) + 1] AS country,
    rand() % 20 AS referrals_sent,
    rand() % 10 AS referrals_converted
FROM numbers(10)