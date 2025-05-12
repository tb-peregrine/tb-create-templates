SELECT
    concat('ord_', toString(rand() % 100000)) AS order_id,
    concat('cust_', toString(rand() % 10000)) AS customer_id,
    concat('rest_', toString(rand() % 1000)) AS restaurant_id,
    concat('drv_', toString(rand() % 500)) AS driver_id,
    now() - toIntervalDay(rand() % 30) - toIntervalHour(rand() % 24) AS timestamp,
    ['pending', 'in_progress', 'delivered', 'cancelled'][rand() % 4 + 1] AS status,
    round(50 + rand() % 150 + rand(), 2) AS total_amount,
    round(2 + rand() % 8, 2) AS delivery_fee,
    round(rand() % 15, 2) AS tip_amount,
    15 + rand() % 45 AS delivery_time_minutes,
    arrayMap(x -> concat('item_', toString(x)), range(1, rand() % 5 + 2)) AS items,
    ['New York', 'Los Angeles', 'Chicago', 'Miami', 'Seattle'][rand() % 5 + 1] AS city,
    ['credit_card', 'debit_card', 'cash', 'digital_wallet'][rand() % 4 + 1] AS payment_method
FROM numbers(10)