SELECT
    concat('fb_', toString(rand() % 100000)) AS feedback_id,
    concat('user_', toString(rand() % 10000)) AS user_id,
    multiIf(
        rand() % 5 = 0, 'I really love this product! Would recommend to everyone.',
        rand() % 5 = 1, 'This was okay, but could use some improvements.',
        rand() % 5 = 2, 'Not satisfied with my purchase. Will not buy again.',
        rand() % 5 = 3, 'Great customer service but product quality is lacking.',
        'The features work well but the interface is confusing.'
    ) AS feedback_text,
    concat('prod_', toString(rand() % 1000)) AS product_id,
    multiIf(
        rand() % 5 = 0, 'Smartphone',
        rand() % 5 = 1, 'Laptop',
        rand() % 5 = 2, 'Headphones',
        rand() % 5 = 3, 'Smart Watch',
        'Tablet'
    ) AS product_name,
    multiIf(
        rand() % 4 = 0, 'Electronics',
        rand() % 4 = 1, 'Accessories',
        rand() % 4 = 2, 'Home Goods',
        'Wearables'
    ) AS category,
    1 + rand() % 5 AS rating,
    now() - toIntervalDay(rand() % 30) - toIntervalHour(rand() % 24) AS timestamp,
    multiIf(
        rand() % 3 = 0, 'Website',
        rand() % 3 = 1, 'Mobile App',
        'Customer Support'
    ) AS source,
    multiIf(
        rand() % 3 = 0, 'English',
        rand() % 3 = 1, 'Spanish',
        'French'
    ) AS language
FROM numbers(10)