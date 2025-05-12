SELECT
    concat('user_', toString(rand() % 1000)) AS user_id,
    concat('prod_', toString(rand() % 500)) AS product_id,
    ['view', 'click', 'purchase', 'favorite', 'review'][rand() % 5 + 1] AS interaction_type,
    now() - toIntervalSecond(rand() % 2592000) AS timestamp,
    concat('session_', toString(rand() % 5000)) AS session_id,
    round(rand() * 100, 2) AS value
FROM numbers(10)