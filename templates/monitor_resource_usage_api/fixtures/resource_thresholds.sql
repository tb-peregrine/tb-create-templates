SELECT
    concat('host-', toString(rand() % 1000)) AS host_id,
    ['production', 'staging', 'development', 'testing'][1 + rand() % 4] AS host_group,
    60 + (rand() % 30) AS cpu_threshold,
    70 + (rand() % 20) AS memory_threshold,
    75 + (rand() % 15) AS disk_threshold,
    3 + (rand() % 7) AS load_threshold,
    rand() % 2 AS alert_enabled,
    5 * (1 + rand() % 12) AS alert_cooldown_minutes,
    now() - toIntervalDay(rand() % 30) AS created_at,
    now() - toIntervalDay(rand() % 10) AS updated_at
FROM numbers(10)