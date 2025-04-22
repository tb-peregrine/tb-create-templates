SELECT
    concat('user_', toString(rand() % 1000)) AS user_id,
    concat('session_', toString(rand() % 5000)) AS session_id,
    concat('test_', toString(1 + rand() % 10)) AS test_id,
    ['control', 'variant_a', 'variant_b'][(rand() % 3) + 1] AS variant,
    ['pageview', 'click', 'conversion', 'scroll', 'exit'][(rand() % 5) + 1] AS event_type,
    ['product_view', 'add_to_cart', 'checkout', 'purchase', 'signup'][(rand() % 5) + 1] AS event_name,
    round(rand() * 100, 2) AS value,
    now() - toIntervalSecond(rand() % 86400) AS timestamp,
    concat('{"device":"', ['mobile', 'desktop', 'tablet'][(rand() % 3) + 1], '","country":"', ['US', 'UK', 'CA', 'DE', 'FR'][(rand() % 5) + 1], '"}') AS metadata
FROM numbers(10)