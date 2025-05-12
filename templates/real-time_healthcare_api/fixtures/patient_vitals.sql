SELECT
    concat('P', toString(10000 + rand() % 90000)) AS patient_id,
    now() - toIntervalDay(rand() % 30) - toIntervalHour(rand() % 24) AS timestamp,
    60 + rand() % 60 AS heart_rate,
    110 + rand() % 60 AS blood_pressure_systolic,
    60 + rand() % 40 AS blood_pressure_diastolic,
    90 + rand() % 10 AS oxygen_saturation,
    36.0 + rand() % 3 + rand() / 10 AS temperature
FROM numbers(10)