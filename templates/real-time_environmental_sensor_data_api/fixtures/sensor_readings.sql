SELECT
    concat('sensor_', toString(1 + rand() % 100)) AS sensor_id,
    ['Kitchen', 'Living Room', 'Bedroom', 'Bathroom', 'Garden', 'Basement', 'Attic', 'Garage', 'Office', 'Outdoor'][1 + rand() % 10] AS location,
    ['temperature', 'humidity', 'air_quality', 'pressure', 'light'][1 + rand() % 5] AS reading_type,
    round(10 + rand() % 90 + rand(), 2) AS reading_value,
    multiIf(
        reading_type = 'temperature', '°C',
        reading_type = 'humidity', '%',
        reading_type = 'air_quality', 'AQI',
        reading_type = 'pressure', 'hPa',
        reading_type = 'light', 'lux',
        'unknown'
    ) AS unit,
    now() - toIntervalSecond(rand() % 86400) AS timestamp,
    round(0.1 + rand() % 9 / 10, 2) AS battery_level
FROM numbers(10)