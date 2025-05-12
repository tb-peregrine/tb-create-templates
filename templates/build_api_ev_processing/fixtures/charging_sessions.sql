SELECT
    concat('sess_', toString(rand() % 10000)) AS session_id,
    concat('station_', toString(1 + rand() % 50)) AS station_id,
    concat('user_', toString(1 + rand() % 500)) AS user_id,
    now() - toIntervalHour(rand() % 240) AS start_time,
    now() - toIntervalHour(rand() % 48) AS end_time,
    round(5 + rand() % 45 + rand(), 2) AS energy_consumed,
    round(10 + rand() % 90 + rand(), 2) AS amount_paid,
    ['Fast DC', 'Standard AC', 'Ultra-Fast DC', 'Wireless'][1 + rand() % 4] AS charging_type,
    ['New York', 'Los Angeles', 'Chicago', 'Houston', 'Phoenix', 'San Diego', 'Dallas'][1 + rand() % 7] AS location,
    now() - toIntervalDay(rand() % 30) AS timestamp
FROM numbers(10)