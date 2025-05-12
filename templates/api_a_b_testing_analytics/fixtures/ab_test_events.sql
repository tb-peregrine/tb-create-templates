SELECT
    now() - toIntervalSecond(rand() % (60*60*24*30)) AS timestamp,
    concat('user_', toString(rand() % 1000)) AS user_id,
    concat('test_', toString(rand() % 10)) AS test_id,
    ['control', 'variant_a', 'variant_b'][(rand() % 3) + 1] AS variant,
    ['impression', 'click', 'purchase'][(rand() % 3) + 1] AS event_type,
    rand() % 2 AS conversion,
    round(rand() % 10000 / 100, 2) AS revenue,
    concat('session_', toString(rand() % 5000)) AS session_id,
    ['mobile', 'desktop', 'tablet'][(rand() % 3) + 1] AS device,
    ['US', 'UK', 'CA', 'DE', 'FR', 'JP', 'AU'][(rand() % 7) + 1] AS country
FROM numbers(10)