SELECT
    concat('PROD-', toString(rand() % 10000)) AS product_id,
    concat('Product ', toString(rand() % 500 + 1)) AS product_name,
    ['Electronics', 'Clothing', 'Home & Kitchen', 'Books', 'Toys', 'Sports', 'Beauty', 'Grocery', 'Automotive', 'Office'][(rand() % 10) + 1] AS category,
    now() - toIntervalDay(rand() % 365) - toIntervalHour(rand() % 24) AS timestamp,
    round(rand() % 1000 + 10 + rand(), 2) AS sales_amount,
    rand() % 200 + 1 AS units_sold,
    rand() % 50 / 10.0 + 3.0 AS customer_satisfaction,
    rand() % 10000 + 50 AS page_views,
    rand() % 70 / 100.0 + 0.01 AS conversion_rate,
    rand() % 20 / 100.0 AS return_rate
FROM numbers(10)