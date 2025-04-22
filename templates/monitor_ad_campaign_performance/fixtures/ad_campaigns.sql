SELECT
    concat('cmp_', toString(rand() % 10000)) AS campaign_id,
    concat('Campaign ', toString(1 + rand() % 100)) AS name,
    round(1000 + rand() % 9000, 2) AS budget,
    now() - toIntervalDay(rand() % 90) AS start_date,
    now() + toIntervalDay(30 + rand() % 180) AS end_date,
    ['active', 'paused', 'completed', 'scheduled'][1 + rand() % 4] AS status,
    ['Facebook', 'Google', 'Instagram', 'LinkedIn', 'Twitter', 'TikTok'][1 + rand() % 6] AS platform
FROM numbers(10)