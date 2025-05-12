SELECT
    concat('step_', toString(number + 1)) AS step_id,
    concat('Step ', toString(number + 1)) AS step_name,
    concat('Description for step ', toString(number + 1), ': ', toString(randomString(20))) AS step_description,
    number + 1 AS step_order,
    rand() % 2 AS is_required
FROM numbers(10)