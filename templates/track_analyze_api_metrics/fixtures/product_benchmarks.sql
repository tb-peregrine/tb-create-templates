SELECT
    arrayElement(['Electronics', 'Furniture', 'Clothing', 'Food', 'Sports'], rand() % 5 + 1) AS category,
    arrayElement(['Performance', 'Durability', 'Quality', 'Value', 'Customer Satisfaction'], rand() % 5 + 1) AS metric_name,
    round(rand() * 10, 2) AS benchmark_value,
    now() - toIntervalDay(rand() % 100) - toIntervalSecond(rand() % 86400) AS updated_at
FROM numbers(10)