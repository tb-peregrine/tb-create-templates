SELECT
    today() - rand() % 90 AS day,
    ['Product', 'Service', 'Support', 'Website', 'Billing'][rand() % 5 + 1] AS category,
    ['Web', 'Mobile App', 'Email', 'Call Center', 'Social Media'][rand() % 5 + 1] AS source,
    countState(rand() % 1000 + 1) AS feedback_count,
    sumState(rand() % 500) AS total_rating,
    avgState(rand() % 100 / 100.0) AS avg_sentiment
FROM numbers(10)