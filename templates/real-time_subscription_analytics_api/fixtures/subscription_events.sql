SELECT
    concat('evt_', lower(hex(randomString(8)))) AS event_id,
    concat('usr_', toString(rand() % 1000)) AS user_id,
    concat('sub_', toString(rand() % 2000)) AS subscription_id,
    ['created', 'renewed', 'cancelled', 'upgraded', 'downgraded'][(rand() % 5) + 1] AS event_type,
    concat('plan_', toString(rand() % 10)) AS plan_id,
    ['Basic', 'Premium', 'Pro', 'Enterprise', 'Starter'][(rand() % 5) + 1] AS plan_name,
    round(10 + rand() % 990, 2) AS amount,
    ['USD', 'EUR', 'GBP', 'JPY', 'CAD'][(rand() % 5) + 1] AS currency,
    ['monthly', 'quarterly', 'yearly'][(rand() % 3) + 1] AS billing_period,
    now() - toIntervalDay(rand() % 90) AS timestamp,
    concat('{"source":"', ['web', 'mobile', 'api'][(rand() % 3) + 1], '","notes":"', ['Initial subscription', 'Promotion applied', 'Customer requested', 'Automatic renewal', 'System generated'][(rand() % 5) + 1], '"}') AS metadata
FROM numbers(10)