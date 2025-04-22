SELECT
    now() - rand() % (86400 * 30) AS timestamp,
    concat('app_', toString(1 + rand() % 5)) AS app_id,
    ['api-gateway', 'auth-service', 'payment-processor', 'notification-service', 'user-service'][1 + rand() % 5] AS service_name,
    ['production', 'staging', 'development', 'testing'][1 + rand() % 4] AS environment,
    ['ERROR', 'WARNING', 'CRITICAL', 'INFO', 'DEBUG'][1 + rand() % 5] AS severity,
    ['NullPointerException', 'DatabaseConnectionError', 'TimeoutException', 'AuthenticationFailure', 'ValidationError'][1 + rand() % 5] AS error_type,
    ['Connection refused', 'Invalid input parameters', 'Operation timed out', 'Authentication token expired', 'Resource not found'][1 + rand() % 5] AS error_message,
    concat('at com.example.', ['api', 'service', 'util', 'auth', 'db'][1 + rand() % 5], '.', ['Controller', 'Service', 'Repository', 'Handler', 'Manager'][1 + rand() % 5], '.method(', toString(10 + rand() % 500), ')') AS stack_trace,
    concat('user_', toString(1000 + rand() % 9000)) AS user_id,
    concat('req_', lower(hex(rand()))) AS request_id,
    concat('{"browser":"', ['Chrome', 'Firefox', 'Safari', 'Edge'][1 + rand() % 4], '","os":"', ['Windows', 'MacOS', 'Linux', 'iOS', 'Android'][1 + rand() % 5], '","version":"', toString(1 + rand() % 10), '.', toString(rand() % 10), '"}') AS metadata
FROM numbers(10)