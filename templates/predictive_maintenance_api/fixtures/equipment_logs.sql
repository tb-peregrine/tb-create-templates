SELECT
    concat('EQ-', toString(100 + rand() % 900)) AS equipment_id,
    now() - toIntervalDay(rand() % 30) - toIntervalHour(rand() % 24) AS timestamp,
    65 + (rand() / 4294967295) * 35 AS temperature,
    0.1 + (rand() / 4294967295) * 1.9 AS vibration,
    80 + (rand() / 4294967295) * 40 AS pressure,
    30 + (rand() / 4294967295) * 50 AS noise_level,
    ['NORMAL', 'WARNING', 'CRITICAL', 'MAINTENANCE'][1 + rand() % 4] AS status,
    rand() % 2 AS maintenance_due
FROM numbers(10)