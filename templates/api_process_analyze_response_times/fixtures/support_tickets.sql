SELECT
    concat('TCKT-', toString(rand() % 100000)) AS ticket_id,
    concat('CUST-', toString(rand() % 5000)) AS customer_id,
    concat('AGT-', toString(rand() % 100)) AS agent_id,
    ['low', 'medium', 'high', 'critical'][(rand() % 4) + 1] AS priority,
    ['billing', 'technical', 'account', 'product', 'general'][(rand() % 5) + 1] AS category,
    ['open', 'in_progress', 'resolved', 'closed'][(rand() % 4) + 1] AS status,
    now() - toIntervalSecond(rand() % (86400 * 30)) AS created_at,
    now() - toIntervalSecond(rand() % (86400 * 29)) AS first_response_at,
    now() - toIntervalSecond(rand() % (86400 * 25)) AS resolved_at,
    60 + (rand() % 3600) AS response_time_seconds,
    3600 + (rand() % (86400 * 3)) AS resolution_time_seconds
FROM numbers(10)