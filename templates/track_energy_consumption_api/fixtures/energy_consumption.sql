SELECT
    now() - rand() % (86400 * 30) AS timestamp,
    concat('device_', toString(1 + rand() % 10)) AS device_id,
    round(10 + rand() % 50 + rand(), 2) AS energy_consumed,
    ['Kitchen', 'Living Room', 'Bedroom', 'Bathroom', 'Office'][(rand() % 5) + 1] AS location
FROM numbers(10)