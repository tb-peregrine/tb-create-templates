SELECT
    now() - toIntervalSecond(rand() % (60*60*24*30)) AS event_time,
    ['purchase', 'view', 'add_to_cart', 'remove_from_cart', 'checkout'][1 + rand() % 5] AS event_type,
    concat('user_', toString(rand() % 1000)) AS user_id,
    concat('prod_', toString(rand() % 500)) AS product_id,
    ['Electronics', 'Clothing', 'Home & Garden', 'Sports', 'Books', 'Beauty', 'Toys'][1 + rand() % 7] AS category,
    round(10 + rand() % 990, 2) AS price,
    1 + rand() % 5 AS quantity,
    concat('session_', toString(rand() % 2000)) AS session_id,
    ['US', 'UK', 'Canada', 'Germany', 'France', 'Japan', 'Australia', 'Brazil', 'China'][1 + rand() % 9] AS country
FROM numbers(10)