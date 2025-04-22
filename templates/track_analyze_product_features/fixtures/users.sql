SELECT
    concat('user_', toString(rand() % 10000)) AS user_id,
    now() - toIntervalDay(rand() % 365) AS first_seen_at,
    now() - toIntervalDay(rand() % 30) AS last_seen_at,
    concat('acc_', toString(rand() % 1000)) AS account_id,
    ['admin', 'regular', 'guest'][(rand() % 3) + 1] AS user_type,
    ['free', 'starter', 'pro', 'enterprise'][(rand() % 4) + 1] AS plan,
    ['USA', 'UK', 'Canada', 'Germany', 'France', 'India', 'Australia', 'Japan'][(rand() % 8) + 1] AS country,
    ['Technology', 'Finance', 'Healthcare', 'Education', 'Retail', 'Manufacturing', 'Media'][(rand() % 7) + 1] AS industry,
    5 + (rand() % 995) AS team_size
FROM numbers(10)