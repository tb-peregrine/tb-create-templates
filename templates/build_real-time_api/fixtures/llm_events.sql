SELECT
    now() - rand() % 604800 AS event_time,
    ['gpt-3.5-turbo', 'gpt-4', 'claude-2', 'llama-2', 'mistral-7b'][rand() % 5 + 1] AS model_name,
    100 + rand() % 900 AS prompt_tokens,
    50 + rand() % 450 AS completion_tokens,
    (100 + rand() % 900) + (50 + rand() % 450) AS total_tokens,
    round(((100 + rand() % 900) * 0.0001) + ((50 + rand() % 450) * 0.0002), 4) AS cost,
    0.5 + rand() % 5 + rand() AS latency,
    rand() % 10 > 0 AS success,
    multiIf(
        rand() % 10 > 0, '',
        rand() % 3 = 0, 'Rate limit exceeded',
        rand() % 3 = 1, 'Context length exceeded',
        'Internal server error'
    ) AS error_message
FROM numbers(10)