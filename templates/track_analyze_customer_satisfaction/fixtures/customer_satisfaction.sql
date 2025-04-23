SELECT
    concat('cust_', toString(rand() % 10000)) AS customer_id,
    1 + rand() % 10 AS rating,
    multiIf(
        rand() % 5 = 0, 'Very satisfied with the product quality!',
        rand() % 5 = 1, 'Delivery was slower than expected.',
        rand() % 5 = 2, 'Great customer service experience.',
        rand() % 5 = 3, 'Product did not meet my expectations.',
        'Would recommend to others.'
    ) AS feedback,
    ['Electronics', 'Clothing', 'Home Goods', 'Books', 'Food'][1 + rand() % 5] AS category,
    concat('prod_', toString(rand() % 1000)) AS product_id,
    ['Website', 'Mobile App', 'Store', 'Phone', 'Email'][1 + rand() % 5] AS channel,
    now() - toIntervalDay(rand() % 90) - toIntervalHour(rand() % 24) AS timestamp
FROM numbers(10)