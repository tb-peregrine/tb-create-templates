SELECT
    today() - toIntervalDay(rand() % 30) AS date,
    concat('prod-', toString(rand() % 1000)) AS product_id,
    arrayElement(['Electronics', 'Clothing', 'Food', 'Health', 'Software'], rand() % 5 + 1) AS category,
    arrayElement(['Web', 'iOS', 'Android', 'Desktop', 'API'], rand() % 5 + 1) AS platform,
    50 + rand() % 500 AS feedback_count,
    round(1 + rand() % 40 / 10, 1) AS avg_rating,
    round((rand() % 200 - 100) / 100, 2) AS avg_sentiment,
    round(rand() % 100 / 100, 2) AS satisfaction_rate,
    30 + rand() % 300 AS positive_count,
    10 + rand() % 100 AS neutral_count,
    5 + rand() % 50 AS negative_count
FROM numbers(10)