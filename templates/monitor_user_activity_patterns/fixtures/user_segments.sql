SELECT
    concat('user_', toString(rand() % 10000)) AS user_id,
    concat('seg_', toString(rand() % 100)) AS segment_id,
    ['High Value', 'Loyal', 'New', 'Churned', 'Occasional', 'Power User', 'At Risk', 'Dormant', 'Seasonal', 'Regular'][rand() % 10 + 1] AS segment_name,
    now() - toIntervalDay(rand() % 365) AS first_seen,
    now() - toIntervalDay(rand() % 30) AS last_seen,
    rand() % 90 AS recency_days,
    1 + rand() % 100 AS frequency,
    toFloat32(60 + rand() % 1800) AS avg_session_duration,
    ['Mobile', 'Desktop', 'Tablet', 'TV'][rand() % 4 + 1] AS preferred_device,
    ['US', 'UK', 'Canada', 'Germany', 'France', 'Japan', 'Australia', 'Brazil', 'India', 'Spain'][rand() % 10 + 1] AS top_country,
    toFloat32(rand() / 100) AS engagement_score,
    now() - toIntervalMinute(rand() % 10080) AS last_updated
FROM numbers(10)