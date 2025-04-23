SELECT
    concat('fb_', toString(rand() % 10000)) AS feedback_id,
    concat('cust_', toString(rand() % 5000)) AS customer_id,
    concat('prod_', toString(rand() % 1000)) AS product_id,
    ['Electronics', 'Clothing', 'Home Goods', 'Food', 'Beauty', 'Sports', 'Books', 'Toys'][rand() % 8 + 1] AS category,
    1 + rand() % 5 AS rating,
    ['Great product!', 'Not what I expected.', 'Excellent quality for the price.', 'Would recommend to others.', 'Arrived damaged, disappointed.', 'Perfect fit for my needs.', 'Could be better.', 'Amazing customer service!', 'Will buy again.', 'Shipping was too slow.'][rand() % 10 + 1] AS comment,
    round((rand() % 100) / 100, 2) AS sentiment_score,
    now() - toIntervalDay(rand() % 365) - toIntervalHour(rand() % 24) AS created_at,
    ['Website', 'Mobile App', 'Email Survey', 'Call Center', 'In-Store'][rand() % 5 + 1] AS source
FROM numbers(10)