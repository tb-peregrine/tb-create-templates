SELECT
    concat('evt_', lower(hex(randomString(8)))) AS event_id,
    now() - rand() % 86400 AS timestamp,
    concat('prod_', toString(1 + rand() % 10)) AS product_id,
    ['Dashboard', 'Analytics', 'API Gateway', 'Data Processing', 'User Management'][1 + rand() % 5] AS product_name,
    ['page_load', 'api_call', 'click', 'search', 'login', 'logout', 'error'][1 + rand() % 7] AS event_type,
    concat('user_', toString(1 + rand() % 1000)) AS user_id,
    50 + rand() % 5000 AS duration_ms,
    multiIf(rand() % 10 < 2, toString(400 + rand() % 100), rand() % 10 < 3, toString(500 + rand() % 100), '') AS error_code,
    100 + rand() % 2000 AS page_load_time_ms,
    20 + rand() % 500 AS api_latency_ms,
    rand() % 10 < 2 ? 1 : 0 AS is_error,
    ['web', 'mobile_app', 'api', 'backend'][1 + rand() % 4] AS source,
    ['desktop', 'mobile', 'tablet', 'iot'][1 + rand() % 4] AS device_type,
    ['US', 'UK', 'CA', 'DE', 'FR', 'JP', 'AU', 'BR', 'IN', 'MX'][1 + rand() % 10] AS country
FROM numbers(10)