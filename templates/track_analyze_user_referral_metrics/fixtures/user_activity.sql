SELECT
    concat('ev_', toString(rand() % 1000000)) AS event_id,
    concat('user_', toString(rand() % 10000)) AS user_id,
    ['signup', 'login', 'purchase', 'referral_sent', 'referral_accepted', 'profile_view'][1 + rand() % 6] AS event_type,
    now() - toIntervalDay(rand() % 30) - toIntervalHour(rand() % 24) AS event_date,
    rand() % 2 AS referral_related,
    concat('ref_', toString(rand() % 50000)) AS referral_id,
    ['web', 'ios', 'android', 'desktop'][1 + rand() % 4] AS platform,
    ['mobile', 'tablet', 'desktop', 'smart_tv'][1 + rand() % 4] AS device,
    ['US', 'UK', 'CA', 'DE', 'FR', 'JP', 'AU', 'BR', 'IN', 'MX'][1 + rand() % 10] AS country,
    concat('sess_', toString(rand() % 1000000)) AS session_id
FROM numbers(10)