SELECT
    concat('P', toString(100000 + rand() % 900000)) AS product_id,
    concat(
        multiIf(
            rand() % 5 = 0, 'Premium ',
            rand() % 5 = 1, 'Basic ',
            rand() % 5 = 2, 'Ultra ',
            rand() % 5 = 3, 'Standard ',
            'Deluxe '
        ),
        multiIf(
            rand() % 10 = 0, 'Laptop',
            rand() % 10 = 1, 'Smartphone',
            rand() % 10 = 2, 'Tablet',
            rand() % 10 = 3, 'Monitor',
            rand() % 10 = 4, 'Keyboard',
            rand() % 10 = 5, 'Mouse',
            rand() % 10 = 6, 'Headphones',
            rand() % 10 = 7, 'Speaker',
            rand() % 10 = 8, 'Camera',
            'Charger'
        )
    ) AS product_name,
    multiIf(
        rand() % 5 = 0, 'Electronics',
        rand() % 5 = 1, 'Accessories',
        rand() % 5 = 2, 'Audio',
        rand() % 5 = 3, 'Photography',
        'Mobile'
    ) AS category,
    round(10 + rand() % 990, 2) AS unit_price
FROM numbers(10)