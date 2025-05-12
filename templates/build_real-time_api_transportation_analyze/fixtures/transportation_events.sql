SELECT
    concat('evt_', toString(rand() % 1000000)) AS event_id,
    now() - (rand() % 86400) AS timestamp,
    concat('veh_', toString(rand() % 500)) AS vehicle_id,
    ['bus', 'train', 'tram', 'subway', 'ferry'][rand() % 5 + 1] AS vehicle_type,
    concat('route_', toString(rand() % 100)) AS route_id,
    concat('Line ', toString(rand() % 50)) AS route_name,
    5 + rand() % 80 AS passenger_count,
    concat('stop_', toString(rand() % 200)) AS stop_id,
    40.0 + (rand() % 1000) / 1000.0 AS location_lat,
    -73.0 - (rand() % 1000) / 1000.0 AS location_lng
FROM numbers(10)