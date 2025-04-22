SELECT
    concat('feedback_', toString(1000 + rand() % 9000)) AS feedback_id,
    round(rand(), 2) AS sentiment_score,
    ['positive', 'neutral', 'negative'][1 + floor(rand() * 3)] AS sentiment_label,
    now() - toIntervalHour(rand() % 720) AS processed_at
FROM numbers(10)