SELECT
    concat('device_', toString(rand() % 100)) AS device_id,
    ['temperature', 'humidity', 'pressure', 'light', 'motion'][rand() % 5 + 1] AS sensor_type,
    round(rand() * 100, 2) AS reading,
    ['°C', '%', 'hPa', 'lux', 'boolean'][rand() % 5 + 1] AS reading_unit,
    round(rand() * 100, 1) AS battery_level,
    ['living_room', 'bedroom', 'kitchen', 'bathroom', 'garage'][rand() % 5 + 1] AS location,
    now() - toIntervalSecond(rand() % 86400) AS timestamp
FROM numbers(10)