SELECT
    concat('sub_', lower(hex(randomString(8)))) AS subscription_id,
    concat('user_', toString(rand() % 1000)) AS user_id,
    concat('plan_', toString(1 + rand() % 5)) AS plan_id,
    ['Basic', 'Premium', 'Pro', 'Enterprise', 'Custom'][1 + rand() % 5] AS plan_name,
    ['active', 'canceled', 'trialing', 'past_due', 'unpaid'][1 + rand() % 5] AS status,
    round(9.99 + rand() % 90, 2) AS amount,
    ['USD', 'EUR', 'GBP', 'CAD', 'AUD'][1 + rand() % 5] AS currency,
    ['monthly', 'quarterly', 'yearly'][1 + rand() % 3] AS billing_period,
    now() - toIntervalDay(rand() % 365) AS start_date,
    now() + toIntervalDay(rand() % 365) AS end_date,
    now() + toIntervalDay(rand() % 30) AS trial_end_date,
    rand() % 2 AS cancel_at_period_end,
    now() - toIntervalDay(rand() % 365) AS created_at,
    now() - toIntervalDay(rand() % 30) AS updated_at
FROM numbers(10)