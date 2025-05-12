SELECT
    concat('P', toString(rand() % 1000 + 1000)) AS product_id,
    concat('WH', toString(rand() % 10 + 1)) AS warehouse_id,
    rand() % 1000 AS quantity,
    now() - toIntervalDay(rand() % 30) - toIntervalHour(rand() % 24) AS timestamp,
    ['add', 'remove', 'adjust', 'transfer'][rand() % 4 + 1] AS operation,
    concat('B', toString(rand() % 10000 + 10000)) AS batch_id,
    round(10 + rand() % 990, 2) AS unit_price
FROM numbers(10)