SELECT
    concat('call_', toString(rand() % 10000)) AS call_id,
    multiIf(
        rand() % 3 = 0, 'Hello, I need help with my account. I cannot access my services.',
        rand() % 3 = 1, 'I am very frustrated that my bill increased without notification. This is unacceptable!',
        'Thank you for your assistance today. You have been very helpful in resolving my issue.'
    ) AS transcript,
    concat('cust_', toString(rand() % 5000)) AS customer_id,
    concat('agent_', toString(rand() % 100)) AS agent_id,
    60 + rand() % 540 AS duration_seconds,
    now() - toIntervalSecond(rand() % (86400 * 30)) AS timestamp,
    ['support', 'complaint', 'inquiry', 'technical', 'billing'][rand() % 5 + 1] AS call_type,
    concat('+1', toString(100000000 + rand() % 900000000)) AS caller_phone,
    arrayMap(x -> ['urgent', 'resolved', 'escalated', 'follow-up', 'satisfied', 'unsatisfied'][x], 
        arraySort(arrayMap(i -> 1 + rand() % 6, range(1, 1 + rand() % 3))))  AS tags
FROM numbers(10)