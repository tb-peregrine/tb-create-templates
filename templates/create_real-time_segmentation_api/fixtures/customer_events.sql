SELECT
    concat('evt_', toString(rand() % 100000)) AS event_id,
    concat('cust_', toString(rand() % 1000)) AS customer_id,
    ['purchase', 'login', 'page_view', 'add_to_cart', 'checkout'][(rand() % 5) + 1] AS event_type,
    round(rand() % 1000 + rand(), 2) AS event_value,
    concat('prod_', toString(rand() % 500)) AS product_id,
    ['electronics', 'clothing', 'home', 'beauty', 'food', 'sports'][(rand() % 6) + 1] AS category,
    now() - toIntervalDay(rand() % 30) - toIntervalHour(rand() % 24) AS timestamp
FROM numbers(10)