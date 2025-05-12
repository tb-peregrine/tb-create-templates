SELECT
    concat('txn-', toString(rand() % 10000)) AS transaction_id,
    concat('item-', toString(rand() % 500)) AS item_id,
    ['addition', 'removal', 'adjustment', 'transfer', 'return'][rand() % 5 + 1] AS transaction_type,
    (rand() % 100) - 20 AS quantity,
    now() - toIntervalDay(rand() % 60) - toIntervalHour(rand() % 24) AS timestamp,
    ['warehouse-a', 'warehouse-b', 'store-east', 'store-west', 'distribution-center'][rand() % 5 + 1] AS location,
    concat('user-', toString(rand() % 50)) AS user_id,
    ['Routine stock update', 'Damaged goods', 'New shipment arrived', 'Customer return', 'Inventory correction', 'Seasonal restocking'][rand() % 6 + 1] AS notes
FROM numbers(10)