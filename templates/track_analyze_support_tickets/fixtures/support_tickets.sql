SELECT
    concat('TKT-', toString(rand() % 100000)) AS ticket_id,
    concat('CUST-', toString(rand() % 10000)) AS customer_id,
    concat('AGT-', toString(rand() % 100)) AS agent_id,
    ['Billing', 'Technical', 'Account', 'Product', 'General'][(rand() % 5) + 1] AS category,
    ['Low', 'Medium', 'High', 'Critical'][(rand() % 4) + 1] AS priority,
    ['Open', 'In Progress', 'Pending', 'Resolved', 'Closed'][(rand() % 5) + 1] AS status,
    now() - toIntervalDay(rand() % 30) AS created_at,
    now() - toIntervalDay(rand() % 29) AS first_response_at,
    now() - toIntervalDay(rand() % 25) AS resolved_at,
    1 + (rand() % 10) AS satisfaction_score,
    arrayMap(x -> ['bug', 'feature', 'refund', 'login', 'payment', 'subscription', 'error', 'account'][(rand() % 8) + 1], range(1, 1 + rand() % 3)) AS tags
FROM numbers(10)