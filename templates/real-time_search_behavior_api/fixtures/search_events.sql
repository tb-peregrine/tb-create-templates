SELECT
    concat('user_', toString(rand() % 1000)) AS user_id,
    concat('sess_', toString(rand() % 5000)) AS session_id,
    now() - toIntervalSecond(rand() % 86400) AS timestamp,
    ['product search', 'how to order', 'discount code', 'return policy', 'track order', 'account settings', 'payment methods', 'shipping options', 'product reviews', 'contact support'][rand() % 10 + 1] AS query,
    rand() % 100 AS results_count,
    rand() % 2 AS clicked_result,
    ['mobile', 'desktop', 'tablet'][rand() % 3 + 1] AS device_type,
    ['USA', 'Canada', 'UK', 'Germany', 'France', 'Australia', 'Japan', 'Brazil', 'Mexico', 'India'][rand() % 10 + 1] AS country
FROM numbers(10)