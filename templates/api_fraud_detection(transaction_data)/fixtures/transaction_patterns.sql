SELECT
    concat('PATTERN_', toString(10000 + rand() % 90000)) AS pattern_id,
    ['PURCHASE', 'TRANSFER', 'WITHDRAWAL', 'DEPOSIT', 'REFUND'][rand() % 5 + 1] AS pattern_type,
    case rand() % 3
        when 0 then '{"velocity": "high", "amount": "unusual", "location": "suspicious"}'
        when 1 then '{"frequency": "abnormal", "device": "new", "timing": "night"}'
        else '{"transactions": "multiple", "beneficiary": "unknown", "amount": "large"}'
    end AS pattern_features,
    round(rand() % 100 / 100, 2) AS confidence_score,
    rand() % 2 AS is_fraud,
    now() - toIntervalDay(rand() % 30) - toIntervalHour(rand() % 24) AS created_at,
    now() - toIntervalDay(rand() % 15) - toIntervalHour(rand() % 12) AS updated_at
FROM numbers(10)