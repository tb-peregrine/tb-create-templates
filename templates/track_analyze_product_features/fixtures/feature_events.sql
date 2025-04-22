SELECT
    now() - rand() % 604800 AS timestamp,
    concat('user_', toString(100000 + rand() % 900000)) AS user_id,
    concat('feat_', toString(1 + rand() % 50)) AS feature_id,
    ['Search', 'Filters', 'Dashboard', 'Reports', 'Analytics', 'Settings', 'Profile', 'Notifications', 'Sharing', 'Export'][1 + rand() % 10] AS feature_name,
    concat('sess_', hex(randomString(8))) AS session_id,
    ['view', 'click', 'hover', 'drag', 'submit', 'open', 'close', 'edit', 'delete', 'create'][1 + rand() % 10] AS action,
    round(1 + rand() % 300 + rand(), 2) AS duration_seconds,
    ['success', 'error', 'timeout', 'cancelled', 'completed'][1 + rand() % 5] AS status,
    ['No issues', 'User aborted', 'Network error', 'Feature completed successfully', 'System timeout'][1 + rand() % 5] AS details,
    ['web', 'ios', 'android', 'desktop', 'api'][1 + rand() % 5] AS platform,
    concat(toString(1 + rand() % 5), '.', toString(rand() % 10), '.', toString(rand() % 10)) AS version
FROM numbers(10)