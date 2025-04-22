SELECT
    concat('q_', toString(rand() % 100000)) AS query_id,
    ['how to make pasta', 'best smartphones 2023', 'weather forecast today', 'nearest coffee shop', 'python tutorial for beginners', 'how to train a dog', 'best books to read', 'headphones under $100', 'vacation destinations europe', 'how to lose weight fast'][rand() % 10] AS query_text,
    ['navigational', 'informational', 'transactional', 'commercial', 'local'][rand() % 5] AS intent_category,
    round(0.5 + rand() / 2, 2) AS intent_confidence,
    arrayMap(x -> ['search', 'find', 'how', 'best', 'where', 'what', 'buy', 'price', 'near', 'tutorial', 'guide'][x], range(1, 1 + rand() % 5)) AS intent_keywords,
    now() - toIntervalDay(rand() % 30) - toIntervalHour(rand() % 24) AS timestamp
FROM numbers(10)