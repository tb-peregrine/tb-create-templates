SELECT
    now() - toIntervalSecond(rand() % 86400) AS timestamp,
    ['api-gateway', 'auth-service', 'user-service', 'payment-service', 'notification-service'][1 + rand() % 5] AS service_name,
    ['/auth', '/users', '/payments', '/notifications', '/health', '/metrics', '/login', '/register', '/profile', '/settings'][1 + rand() % 10] AS endpoint,
    50 + rand() % 500 AS response_time_ms,
    [200, 201, 204, 400, 401, 403, 404, 500, 502, 503][1 + rand() % 10] AS status_code,
    rand() % 10 AS error_count,
    10 + rand() % 100 AS request_count
FROM numbers(10)