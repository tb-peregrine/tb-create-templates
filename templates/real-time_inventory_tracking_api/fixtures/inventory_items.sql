SELECT
    concat('item_', toString(rand() % 10000)) AS item_id,
    concat('Product ', toString(rand() % 500)) AS item_name,
    ['Electronics', 'Clothing', 'Food', 'Books', 'Home Goods'][(rand() % 5) + 1] AS category,
    rand() % 1000 AS quantity,
    ['Warehouse A', 'Warehouse B', 'Store 1', 'Store 2', 'Online'][(rand() % 5) + 1] AS location,
    now() - toIntervalDay(rand() % 30) AS last_updated,
    10 + rand() % 50 AS low_stock_threshold,
    round(10 + rand() % 990, 2) AS unit_price
FROM numbers(10)