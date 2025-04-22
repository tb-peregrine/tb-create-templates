SELECT
    concat('threshold_', toString(number + 1)) AS threshold_id,
    ['Very Low', 'Low', 'Medium', 'High', 'Very High'][1 + number % 5] AS threshold_name,
    (number % 5) * 0.2 AS min_score,
    (number % 5 + 1) * 0.2 AS max_score,
    ['#FF0000', '#FFA500', '#FFFF00', '#90EE90', '#008000'][1 + number % 5] AS color_code,
    ['Minimal user engagement', 'Basic user interaction', 'Average engagement level', 'Strong user involvement', 'Exceptional engagement metrics'][1 + number % 5] AS description,
    now() - toIntervalDay(rand() % 30) AS created_at,
    now() - toIntervalDay(rand() % 10) AS updated_at
FROM numbers(10)