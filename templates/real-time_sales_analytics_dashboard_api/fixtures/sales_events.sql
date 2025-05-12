SELECT
    concat('tx-', toString(rand() % 100000)) AS transaction_id,
    concat('prod-', toString(rand() % 1000)) AS product_id,
    arrayElement(['Laptop', 'Smartphone', 'Headphones', 'Monitor', 'Keyboard', 'Mouse', 'Tablet', 'Speaker', 'Camera', 'Charger'], rand() % 10 + 1) AS product_name,
    arrayElement(['Electronics', 'Accessories', 'Peripherals', 'Audio', 'Computing', 'Mobile'], rand() % 6 + 1) AS category,
    50 + rand() % 950 AS price,
    1 + rand() % 5 AS quantity,
    (50 + rand() % 950) * (1 + rand() % 5) AS total_amount,
    concat('cust-', toString(rand() % 5000)) AS customer_id,
    concat('store-', toString(rand() % 50)) AS store_id,
    arrayElement(['New York', 'Los Angeles', 'Chicago', 'Houston', 'Phoenix', 'Philadelphia', 'San Antonio', 'San Diego', 'Dallas', 'San Jose'], rand() % 10 + 1) AS store_location,
    now() - toIntervalDay(rand() % 30) - toIntervalHour(rand() % 24) - toIntervalMinute(rand() % 60) AS timestamp
FROM numbers(10)