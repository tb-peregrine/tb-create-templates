SELECT
    concat('dev_', toString(rand() % 1000)) AS device_id,
    ['thermostat', 'light', 'motion_sensor', 'door_sensor', 'window_sensor'][rand() % 5 + 1] AS device_type,
    ['living_room', 'kitchen', 'bedroom', 'bathroom', 'garage', 'hallway'][rand() % 6 + 1] AS room,
    ['activated', 'deactivated', 'status_change', 'alert', 'measurement'][rand() % 5 + 1] AS event_type,
    ['on', 'off', 'open', 'closed', 'detected', 'normal'][rand() % 6 + 1] AS status,
    round(rand() * 100, 2) AS value,
    round(rand() * 100, 2) AS battery_level,
    now() - toIntervalSecond(rand() % 86400) AS timestamp
FROM numbers(10)