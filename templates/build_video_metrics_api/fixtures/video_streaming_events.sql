SELECT 
    concat('evt_', hex(randomString(6))) AS event_id,
    now() - toIntervalSecond(rand() % 86400) AS timestamp,
    concat('user_', toString(rand() % 10000)) AS user_id,
    concat('vid_', toString(rand() % 5000)) AS video_id,
    ['play', 'pause', 'seek', 'buffer', 'error', 'quality_change', 'complete'][rand() % 7 + 1] AS event_type,
    round(rand() % 600 + 1, 2) AS duration,
    rand() % 10 AS buffer_count,
    ['240p', '360p', '480p', '720p', '1080p', '4K'][rand() % 6 + 1] AS quality_level,
    ['mobile', 'tablet', 'desktop', 'smart_tv', 'console'][rand() % 5 + 1] AS device_type,
    ['US', 'UK', 'CA', 'DE', 'FR', 'JP', 'BR', 'IN', 'AU', 'MX'][rand() % 10 + 1] AS country,
    concat('sess_', hex(randomString(4))) AS session_id,
    round(rand() % 3600, 2) AS position,
    multiIf(
        rand() % 5 = 0, 'network_error',
        rand() % 5 = 1, 'timeout',
        rand() % 5 = 2, 'media_error',
        rand() % 5 = 3, 'player_error',
        '') AS error_type,
    ['Cloudfront', 'Akamai', 'Fastly', 'Cloudflare', 'Limelight'][rand() % 5 + 1] AS cdn
FROM numbers(10)