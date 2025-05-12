SELECT
    concat('P', toString(1000 + rand() % 9000)) AS patient_id,
    concat('DEV', toString(100 + rand() % 900)) AS device_id,
    now() - rand() % 86400 AS timestamp,
    60 + rand() % 60 AS heart_rate,
    110 + rand() % 60 AS systolic_bp,
    60 + rand() % 30 AS diastolic_bp,
    36.0 + (rand() % 30) / 10 AS temperature,
    90 + (rand() % 10) AS oxygen_level,
    ['ICU', 'Cardiology', 'Emergency', 'Pediatrics', 'Surgery'][1 + rand() % 5] AS department,
    rand() % 2 AS is_critical
FROM numbers(10)