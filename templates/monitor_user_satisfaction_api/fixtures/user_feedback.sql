SELECT
    concat('fb_', toString(rand() % 100000)) AS feedback_id,
    concat('user_', toString(rand() % 10000)) AS user_id,
    concat('prod_', toString(rand() % 500)) AS product_id,
    1 + rand() % 5 AS rating,
    multiIf(
        rand() % 6 = 0, 'Great product, highly recommend!',
        rand() % 6 = 1, 'Works well but could be improved.',
        rand() % 6 = 2, 'Exactly what I needed.',
        rand() % 6 = 3, 'Disappointed with the quality.',
        rand() % 6 = 4, 'Excellent customer service.',
        'Average experience, nothing special.'
    ) AS comment,
    round(rand() / 1.0, 2) AS sentiment_score,
    ['Electronics', 'Clothing', 'Home', 'Beauty', 'Food', 'Sports', 'Books'][(rand() % 7) + 1] AS category,
    ['Web', 'Mobile App', 'In-store', 'Email', 'Phone'][(rand() % 5) + 1] AS platform,
    now() - toIntervalDay(rand() % 90) - toIntervalHour(rand() % 24) - toIntervalMinute(rand() % 60) AS created_at,
    arrayMap(x -> ['quality', 'price', 'shipping', 'customer_service', 'usability', 'performance', 'design'][(rand() % 7) + 1], range(1, 1 + rand() % 3)) AS tags
FROM numbers(10)