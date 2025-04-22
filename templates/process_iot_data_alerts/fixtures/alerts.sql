SELECT
    concat('alert_', toString(rand() % 10000)) AS alert_id,
    concat('device_', toString(rand() % 100)) AS device_id,
    ['temperature', 'humidity', 'pressure', 'voltage', 'current'][rand() % 5 + 1] AS sensor_type,
    round(10 + rand() % 90 + rand(), 2) AS value,
    round(50 + rand() % 30 + rand(), 2) AS threshold_value,
    ['above_threshold', 'below_threshold', 'critical'][rand() % 3 + 1] AS alert_type,
    now() - toIntervalSecond(rand() % 86400) AS timestamp,
    ['pending', 'acknowledged', 'resolved'][rand() % 3 + 1] AS status
FROM numbers(10)