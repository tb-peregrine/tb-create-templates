SELECT
    concat('evt_', toString(1000 + rand() % 9000)) AS event_id,
    concat('dev_', toString(100 + rand() % 900)) AS device_id,
    now() - toIntervalSecond(rand() % 86400) AS timestamp,
    37.5 + (rand() / 1000) AS location_lat,
    -122.2 + (rand() / 1000) AS location_lon,
    ['Downtown', 'North Bridge', 'East Highway', 'West Junction', 'South Avenue'][1 + rand() % 5] AS location_name,
    10 + rand() % 200 AS vehicle_count,
    20 + rand() % 80 AS average_speed_kph,
    1 + rand() % 5 AS congestion_level,
    ['Sunny', 'Cloudy', 'Rainy', 'Foggy', 'Snow'][1 + rand() % 5] AS weather_condition,
    ['Normal', 'Rush Hour', 'Accident', 'Construction', 'Special Event'][1 + rand() % 5] AS event_type
FROM numbers(10)