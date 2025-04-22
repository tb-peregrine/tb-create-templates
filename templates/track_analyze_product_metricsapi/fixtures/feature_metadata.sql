SELECT
    concat('f_', toString(rand() % 1000)) AS feature_id,
    concat('Feature ', toString(1 + rand() % 100)) AS feature_name,
    ['UI', 'Performance', 'Security', 'Analytics', 'Integration'][1 + rand() % 5] AS category,
    toDate('2023-01-01') + toIntervalDay(rand() % 365) AS release_date,
    concat('This feature ', ['improves', 'enhances', 'optimizes', 'streamlines'][1 + rand() % 4], ' the ', ['user experience', 'system performance', 'data processing', 'security measures'][1 + rand() % 4]) AS description,
    rand() % 2 AS is_beta
FROM numbers(10)