SELECT
    concat('item_', toString(rand() % 1000)) AS item_id,
    concat('Product ', toString(rand() % 100)) AS item_name,
    ['Electronics', 'Clothing', 'Food', 'Furniture', 'Books'][1 + rand() % 5] AS category,
    rand() % 1000 AS current_stock,
    10 + rand() % 50 AS min_stock_level,
    100 + rand() % 500 AS max_stock_level,
    round(10 + rand() % 990, 2) AS unit_price,
    concat('supplier_', toString(rand() % 20)) AS supplier_id,
    concat('wh_', toString(rand() % 5)) AS warehouse_id,
    now() - toIntervalDay(rand() % 30) AS last_updated
FROM numbers(10)