SELECT
    toString(arrayElement(['temperature', 'humidity', 'pressure', 'light', 'motion', 'proximity', 'water_level', 'air_quality', 'voltage', 'current'], 1 + rand() % 10)) AS sensor_type,
    round(rand() * 10, 2) AS min_threshold,
    round(10 + rand() * 90, 2) AS max_threshold,
    now() - toIntervalDay(rand() % 365) AS created_at,
    now() - toIntervalHour(rand() % 24) AS updated_at
FROM numbers(10)