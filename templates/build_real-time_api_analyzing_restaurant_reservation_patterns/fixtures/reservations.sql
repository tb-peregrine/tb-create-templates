SELECT
    concat('res_', toString(rand() % 100000)) AS reservation_id,
    concat('rest_', toString(1 + rand() % 50)) AS restaurant_id,
    concat('cust_', toString(rand() % 10000)) AS customer_id,
    now() + toIntervalHour(rand() % 168) AS reservation_time,
    1 + rand() % 12 AS party_size,
    ['confirmed', 'pending', 'cancelled', 'seated', 'completed'][1 + rand() % 5] AS status,
    now() - toIntervalHour(rand() % 720) AS created_at,
    ['No special requests', 'Window seat please', 'Allergic to nuts', 'Birthday celebration', 'High chair needed', ''][1 + rand() % 6] AS special_requests,
    toString(1 + rand() % 30) AS table_number
FROM numbers(10)