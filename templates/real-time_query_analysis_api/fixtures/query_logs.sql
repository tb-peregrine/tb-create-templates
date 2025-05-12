SELECT
    concat('qid_', toString(rand() % 10000)) AS query_id,
    ['analytics', 'production', 'staging', 'testing', 'development'][(rand() % 5) + 1] AS database,
    concat('SELECT * FROM table', toString(rand() % 10), ' WHERE column', toString(rand() % 5), ' = ', toString(rand() % 100)) AS query_text,
    ['SELECT', 'INSERT', 'UPDATE', 'DELETE', 'CREATE', 'DROP', 'ALTER'][(rand() % 7) + 1] AS query_type,
    concat('user', toString(rand() % 20)) AS user,
    now() - toIntervalSecond(rand() % 86400) AS start_time,
    now() - toIntervalSecond(rand() % 86400 - 100) AS end_time,
    100 + rand() % 5000 AS duration_ms,
    rand() % 1000000 AS rows_read,
    rand() % 1000000000 AS bytes_read,
    rand() % 500000000 AS memory_usage,
    ['success', 'success', 'success', 'error', 'timeout'][(rand() % 5) + 1] AS status,
    multiIf(
        status = 'error', concat('Error: ', ['Syntax error', 'Access denied', 'Resource limit exceeded', 'Timeout exceeded'][(rand() % 4) + 1]),
        status = 'timeout', 'Query execution time limit exceeded',
        ''
    ) AS error_message,
    concat('192.168.', toString(rand() % 255), '.', toString(rand() % 255)) AS client_ip
FROM numbers(10)