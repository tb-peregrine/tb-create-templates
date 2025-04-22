SELECT
    concat('txn_', toString(rand() % 100000)) AS transaction_id,
    concat('user_', toString(rand() % 5000)) AS user_id,
    concat('merch_', toString(rand() % 1000)) AS merchant_id,
    round(10 + rand() % 990 + rand(), 2) AS amount,
    ['USD', 'EUR', 'GBP', 'JPY', 'CAD'][(rand() % 5) + 1] AS currency,
    ['credit_card', 'debit_card', 'paypal', 'apple_pay', 'google_pay', 'bank_transfer'][(rand() % 6) + 1] AS payment_method,
    now() - toIntervalDay(rand() % 30) - toIntervalSecond(rand() % 86400) AS transaction_timestamp,
    concat(toString(rand() % 256), '.', toString(rand() % 256), '.', toString(rand() % 256), '.', toString(rand() % 256)) AS ip_address,
    concat('device_', toString(rand() % 3000)) AS device_id,
    ['New York', 'London', 'Tokyo', 'Berlin', 'Paris', 'Sydney', 'Toronto', 'Mumbai'][(rand() % 8) + 1] AS location,
    ['completed', 'pending', 'failed', 'reversed'][(rand() % 4) + 1] AS status,
    rand() % 10 > 8 ? 1 : 0 AS is_flagged
FROM numbers(10)