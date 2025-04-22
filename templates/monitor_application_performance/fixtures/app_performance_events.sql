SELECT
    now() - toIntervalSecond(rand() % 86400) AS timestamp,
    arrayElement(['app_123', 'app_456', 'app_789', 'app_101'], rand() % 4 + 1) AS app_id,
    arrayElement(['api-gateway', 'auth-service', 'payment-service', 'user-service', 'data-service'], rand() % 5 + 1) AS service_name,
    arrayElement(['/api/users', '/api/auth/login', '/api/payments', '/api/products', '/api/orders', '/health'], rand() % 6 + 1) AS endpoint,
    10 + rand() % 990 AS response_time_ms,
    arrayElement([200, 201, 204, 400, 401, 403, 404, 500], rand() % 8 + 1) AS status_code,
    CASE 
        WHEN rand() % 10 < 8 THEN ''
        ELSE arrayElement(['Connection timeout', 'Database error', 'Authentication failed', 'Resource not found', 'Internal server error'], rand() % 5 + 1)
    END AS error,
    round(rand() % 100, 2) AS cpu_usage_percent,
    round(50 + rand() % 950, 2) AS memory_usage_mb,
    concat('user_', toString(rand() % 1000)) AS user_id,
    arrayElement(['mobile', 'desktop', 'tablet'], rand() % 3 + 1) AS device_type,
    arrayElement(['us-east', 'us-west', 'eu-west', 'eu-central', 'asia-east'], rand() % 5 + 1) AS region,
    concat('v', toString(1 + rand() % 9), '.', toString(rand() % 10), '.', toString(rand() % 10)) AS version
FROM numbers(10)