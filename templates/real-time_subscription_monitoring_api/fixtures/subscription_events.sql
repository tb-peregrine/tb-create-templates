SELECT
    concat('sub_', toString(rand() % 10000)) AS subscription_id,
    concat('cust_', toString(rand() % 1000)) AS customer_id,
    concat('plan_', toString(1 + rand() % 5)) AS plan_id,
    ['created', 'renewed', 'cancelled', 'upgraded', 'downgraded'][1 + rand() % 5] AS event_type,
    toDateTime('2023-01-01 00:00:00') + toIntervalDay(rand() % 365) + toIntervalHour(rand() % 24) AS timestamp,
    round(9.99 + (rand() % 100), 2) AS amount,
    ['USD', 'EUR', 'GBP', 'CAD', 'AUD'][1 + rand() % 5] AS currency,
    toDateTime('2023-01-01 00:00:00') + toIntervalDay(365 + rand() % 365) AS next_renewal_date,
    ['active', 'cancelled', 'pending', 'failed'][1 + rand() % 4] AS status
FROM numbers(10)