SELECT
    concat('fb_', toString(rand() % 10000)) AS feedback_id,
    concat('cust_', toString(rand() % 1000)) AS customer_id,
    concat('prod_', toString(rand() % 100)) AS product_id,
    1 + rand() % 5 AS rating,
    arrayElement(['Great product!', 'Could be better', 'Excellent service', 'Not what I expected', 'Would buy again', 'Disappointed with quality', 'Amazing value', 'Shipping was too slow', 'Perfect for my needs', 'Will recommend to friends'], rand() % 10 + 1) AS feedback_text,
    arrayElement(['positive', 'negative', 'neutral'], rand() % 3 + 1) AS sentiment,
    arrayMap(x -> arrayElement(['quality', 'price', 'delivery', 'service', 'packaging', 'usability', 'durability', 'design', 'features', 'value'], x), range(1, rand() % 4 + 1)) AS tags,
    now() - toIntervalSecond(rand() % 2592000) AS timestamp
FROM numbers(10)