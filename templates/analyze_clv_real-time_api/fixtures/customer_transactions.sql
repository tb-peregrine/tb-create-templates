SELECT
    concat('CUST_', toString(rand() % 1000)) AS customer_id,
    now() - toIntervalDay(rand() % 365) - toIntervalHour(rand() % 24) - toIntervalMinute(rand() % 60) AS transaction_date,
    round(10 + rand() % 990 + rand(), 2) AS transaction_amount
FROM numbers(10)