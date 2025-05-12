SELECT
    concat('visit_', toString(rand() % 10000)) AS visit_id,
    concat('store_', toString(1 + rand() % 5)) AS store_id,
    now() - toIntervalSecond(rand() % 86400) AS timestamp,
    concat('visitor_', toString(rand() % 1000)) AS visitor_id,
    ['main door', 'side entrance', 'mall entrance', 'back door', 'patio entrance'][(rand() % 5) + 1] AS entry_point,
    ['main door', 'side entrance', 'mall entrance', 'back door', 'patio entrance'][(rand() % 5) + 1] AS exit_point,
    60 + rand() % 3600 AS dwell_time_seconds,
    arrayMap(x -> ['premium', 'returning', 'new', 'high_value', 'browsing', 'purchasing', 'with_children'][(rand() % 7) + 1], range(1, 1 + rand() % 3)) AS tags
FROM numbers(10)