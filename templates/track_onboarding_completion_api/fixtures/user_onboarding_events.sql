SELECT
    concat('user_', toString(rand() % 1000)) AS user_id,
    concat('step_', toString(1 + rand() % 5)) AS step_id,
    ['Profile Creation', 'Email Verification', 'Tutorial Completion', 'Feature Tour', 'Preference Setup'][(rand() % 5) + 1] AS step_name,
    rand() % 2 AS completed,
    now() - toIntervalDay(rand() % 30) - toIntervalHour(rand() % 24) AS timestamp
FROM numbers(10)