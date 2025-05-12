SELECT
    concat('lot_', toString(1 + rand() % 20)) AS parking_lot_id,
    ['Downtown', 'Airport', 'Shopping Mall', 'Hospital', 'Train Station', 'University', 'Beach', 'City Center', 'Sports Arena', 'Convention Center'][1 + rand() % 10] AS location,
    100 + rand() % 400 AS total_spaces,
    rand() % 150 AS available_spaces,
    rand() % 250 AS occupied_spaces,
    now() - toIntervalSecond(rand() % 86400) AS timestamp
FROM numbers(10)