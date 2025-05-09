SELECT
    concat('txn_', toString(rand() % 100000)) AS transaction_id,
    concat('item_', toString(1 + rand() % 100)) AS item_id,
    concat('wh_', toString(1 + rand() % 10)) AS warehouse_id,
    ['receiving', 'shipping', 'adjustment', 'transfer', 'inventory_count'][1 + rand() % 5] AS transaction_type,
    (rand() % 100) - 25 AS quantity,
    now() - rand() % (86400 * 30) AS transaction_date,
    concat('user_', toString(1 + rand() % 20)) AS user_id,
    concat('ref_', toString(rand() % 50000)) AS reference_id,
    ['New stock arrival', 'Customer order fulfilled', 'Inventory adjustment after count', 'Damaged goods', 'Returned items', 'Transfer between warehouses'][1 + rand() % 6] AS notes
FROM numbers(10)