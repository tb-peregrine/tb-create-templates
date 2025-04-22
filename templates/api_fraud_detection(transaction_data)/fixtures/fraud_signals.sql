SELECT
    concat('signal_', toString(rand() % 10000)) AS signal_id,
    ['ip_abuse', 'device_fraud', 'merchant_risk', 'suspicious_pattern', 'anomaly_detection'][rand() % 5 + 1] AS signal_type,
    concat(toString(rand() % 256), '.', toString(rand() % 256), '.', toString(rand() % 256), '.', toString(rand() % 256)) AS ip_address,
    concat('device_', toString(rand() % 5000)) AS device_id,
    concat('merchant_', toString(rand() % 1000)) AS merchant_id,
    round(rand() * 100, 2) AS risk_score,
    now() - toIntervalDay(rand() % 30) - toIntervalHour(rand() % 24) - toIntervalMinute(rand() % 60) AS updated_at,
    rand() % 2 AS is_active
FROM numbers(10)