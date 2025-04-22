SELECT
    today() - rand() % 30 AS date,
    concat('prod_', toString(1 + rand() % 100)) AS product_id,
    10 + rand() % 90 AS feedback_count,
    rand() % 50 AS positive_count,
    rand() % 30 AS neutral_count,
    rand() % 20 AS negative_count,
    round(0.5 + rand() % 40 / 10, 1) AS avg_sentiment_score
FROM numbers(10)