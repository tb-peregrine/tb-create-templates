SELECT
    concat('prod_', toString(rand() % 10000)) AS product_id,
    concat('Product ', toString(rand() % 1000)) AS product_name,
    ['Electronics', 'Clothing', 'Home', 'Beauty', 'Sports', 'Books', 'Food', 'Toys'][rand() % 8 + 1] AS category,
    concat('merchant_', toString(rand() % 100)) AS merchant_id,
    round(10 + rand() % 990, 2) AS old_price,
    round(10 + rand() % 990, 2) AS new_price,
    round(new_price - old_price, 2) AS price_change,
    round((new_price - old_price) / old_price * 100, 2) AS price_change_percentage,
    ['USD', 'EUR', 'GBP', 'CAD', 'AUD'][rand() % 5 + 1] AS currency,
    now() - toIntervalDay(rand() % 30) AS change_timestamp,
    now() AS event_timestamp
FROM numbers(10)