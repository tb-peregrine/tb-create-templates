SELECT
    concat('user_', toString(100000 + rand() % 900000)) AS user_id,
    round(60 + rand() % 540, 2) AS avg_session_duration,
    5 + rand() % 95 AS total_sessions,
    round(2 + rand() % 18, 1) AS avg_clicks_per_session,
    ['Home', 'Products', 'About', 'Blog', 'Contact', 'Dashboard', 'Profile', 'Settings'][(rand() % 8) + 1] AS most_visited_page,
    ['Desktop', 'Mobile', 'Tablet'][(rand() % 3) + 1] AS most_used_device,
    ['USA', 'UK', 'Canada', 'Germany', 'France', 'Brazil', 'Japan', 'Australia', 'India', 'Spain'][(rand() % 10) + 1] AS country,
    now() - toIntervalDay(rand() % 30) - toIntervalHour(rand() % 24) AS last_updated,
    rand() % 5 + 1 AS cluster_id
FROM numbers(10)