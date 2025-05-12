SELECT
    now() - toIntervalSecond(rand() % 604800) AS timestamp,
    concat('machine_', toString(1 + rand() % 10)) AS machine_id,
    concat('prod_', toString(1 + rand() % 100)) AS product_id,
    concat('batch_', toString(1 + rand() % 50)) AS batch_id,
    ['dimension', 'weight', 'temperature', 'pressure', 'viscosity'][(rand() % 5) + 1] AS measurement_type,
    round(10 + rand() % 90 + rand(), 2) AS value,
    round(5 + rand() % 10, 2) AS lower_limit,
    round(90 + rand() % 20, 2) AS upper_limit,
    rand() % 2 AS is_pass,
    concat('op_', toString(1 + rand() % 20)) AS operator_id
FROM numbers(10)