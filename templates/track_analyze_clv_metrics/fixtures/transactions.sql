SELECT
    concat('TRX-', toString(rand() % 1000000)) AS transaction_id,
    concat('CUST-', toString(rand() % 10000)) AS customer_id,
    now() - toIntervalDay(rand() % 365) - toIntervalHour(rand() % 24) AS transaction_date,
    round(10 + rand() % 990 + rand(), 2) AS amount,
    ['Electronics', 'Clothing', 'Food', 'Home', 'Beauty', 'Sports', 'Books', 'Toys'][1 + rand() % 8] AS product_category,
    ['Purchase', 'Subscription', 'Renewal', 'Upgrade'][1 + rand() % 4] AS transaction_type,
    ['Credit Card', 'Debit Card', 'PayPal', 'Bank Transfer', 'Cash'][1 + rand() % 5] AS payment_method,
    rand() % 10 = 0 ? 1 : 0 AS is_refund
FROM numbers(10)