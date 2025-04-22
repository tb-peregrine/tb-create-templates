SELECT
    now() - rand() % (86400 * 30) AS timestamp,
    concat('req-', lower(hex(randomString(8)))) AS request_id,
    concat('tenant-', toString(1 + rand() % 20)) AS tenant_id,
    concat('user-', toString(1 + rand() % 1000)) AS user_id,
    ['/api/v1/users', '/api/v1/products', '/api/v1/orders', '/api/v1/auth', '/api/v1/reports'][(rand() % 5) + 1] AS endpoint,
    ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'][(rand() % 5) + 1] AS method,
    multiIf(
        rand() % 100 < 90, 200 + (rand() % 4) * 100,
        rand() % 100 < 95, 400 + (rand() % 5),
        500 + (rand() % 5)
    ) AS status_code,
    10 + rand() % 990 AS response_time_ms,
    100 + rand() % 9900 AS request_size_bytes,
    200 + rand() % 19800 AS response_size_bytes,
    concat(toString(rand() % 256), '.', toString(rand() % 256), '.', toString(rand() % 256), '.', toString(rand() % 256)) AS ip_address,
    ['Mozilla/5.0', 'PostmanRuntime/7.29.0', 'curl/7.79.1', 'axios/0.27.2', 'Dalvik/2.1.0'][(rand() % 5) + 1] AS user_agent,
    multiIf(
        status_code < 400, '',
        status_code < 500, ['validation_error', 'authentication_error', 'authorization_error', 'not_found'][(rand() % 4) + 1],
        ['server_error', 'timeout_error', 'database_error'][(rand() % 3) + 1]
    ) AS error_type,
    multiIf(
        status_code < 400, '',
        status_code < 500, ['Invalid input parameters', 'Token expired', 'Access denied', 'Resource not found'][(rand() % 4) + 1],
        ['Internal server error', 'Request timeout', 'Database connection error'][(rand() % 3) + 1]
    ) AS error_message,
    ['us-east-1', 'us-west-2', 'eu-west-1', 'ap-south-1', 'ap-northeast-1'][(rand() % 5) + 1] AS region
FROM numbers(10)