SELECT
    concat('txn_', toString(rand() % 100000)) AS transaction_id,
    concat('cust_', toString(rand() % 10000)) AS customer_id,
    now() - toIntervalDay(rand() % 365) - toIntervalHour(rand() % 24) AS order_date,
    concat('prod_', toString(rand() % 1000)) AS product_id,
    concat('Product ', toString(rand() % 100)) AS product_name,
    ['Electronics', 'Clothing', 'Home & Garden', 'Sports', 'Books', 'Food', 'Toys', 'Beauty', 'Health', 'Automotive'][1 + rand() % 10] AS category,
    1 + rand() % 10 AS quantity,
    5 + (rand() % 100) + (rand() % 100) / 100 AS unit_price,
    toFloat64(quantity) * toFloat64(unit_price) AS total_amount,
    ['Credit Card', 'PayPal', 'Bank Transfer', 'Cash on Delivery', 'Apple Pay', 'Google Pay'][1 + rand() % 6] AS payment_method,
    ['USA', 'UK', 'Canada', 'Germany', 'France', 'Australia', 'Japan', 'India', 'Brazil', 'Mexico'][1 + rand() % 10] AS country,
    ['Desktop', 'Mobile', 'Tablet'][1 + rand() % 3] AS device,
    rand() % 10 > 1 ? 1 : 0 AS is_completed,
    now() - toIntervalMinute(rand() % 1440) AS timestamp
FROM numbers(10)