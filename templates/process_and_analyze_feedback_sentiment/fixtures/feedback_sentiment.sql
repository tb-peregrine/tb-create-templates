SELECT
    concat('fb_', toString(1000 + rand() % 9000)) AS feedback_id,
    concat('user_', toString(100 + rand() % 900)) AS user_id,
    arrayElement(['Great product, loved it!', 'Not satisfied with the quality', 'This exceeded my expectations', 'Product was damaged on arrival', 'Average experience, could be better', 'Fantastic customer service', 'Very disappointed with my purchase', 'Good value for money', 'Would recommend to others', 'Shipping took too long'], rand() % 10 + 1) AS feedback_text,
    round(rand() % 100 / 100, 2) AS sentiment_score,
    arrayElement(['positive', 'negative', 'neutral'], if(rand() % 100 / 100 < 0.4, 1, if(rand() % 100 / 100 < 0.7, 2, 3))) AS sentiment_label,
    now() - toIntervalDay(rand() % 90) - toIntervalHour(rand() % 24) AS timestamp,
    concat('prod_', toString(10 + rand() % 90)) AS product_id
FROM numbers(10)