SELECT
    concat('device_', toString(1 + rand() % 100)) AS device_id,
    ['temperature', 'humidity', 'pressure', 'light', 'co2'][1 + rand() % 5] AS sensor_type,
    round(10 + rand() % 90 + rand(), 2) AS value,
    ['°C', '%', 'hPa', 'lux', 'ppm'][1 + rand() % 5] AS unit,
    now() - toIntervalSecond(rand() % 86400) AS timestamp,
    ['kitchen', 'living_room', 'bedroom', 'bathroom', 'garage'][1 + rand() % 5] AS location
FROM numbers(10)