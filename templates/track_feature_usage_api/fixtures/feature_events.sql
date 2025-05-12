SELECT
    concat('evt_', lower(hex(randomString(8)))) AS event_id,
    concat('user_', toString(rand() % 1000)) AS user_id,
    concat('feature_', toString(1 + rand() % 20)) AS feature_id,
    concat(toString(1 + rand() % 5), '.', toString(rand() % 10), '.', toString(rand() % 10)) AS product_version,
    ['view', 'click', 'create', 'update', 'delete'][1 + rand() % 5] AS event_type,
    now() - toIntervalHour(rand() % 168) AS timestamp,
    concat('session_', lower(hex(randomString(6)))) AS session_id,
    concat('{"device":"', ['mobile', 'desktop', 'tablet'][1 + rand() % 3], '","os":"', ['windows', 'mac', 'linux', 'ios', 'android'][1 + rand() % 5], '","browser":"', ['chrome', 'firefox', 'safari', 'edge'][1 + rand() % 4], '"}') AS metadata
FROM numbers(10)