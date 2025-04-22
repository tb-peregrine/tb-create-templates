SELECT
    concat('evt_', lower(hex(randomString(8)))) AS event_id,
    concat('usr_', toString(rand() % 1000)) AS user_id,
    ['view', 'click', 'share', 'like', 'comment', 'bookmark'][(rand() % 6) + 1] AS event_type,
    concat('cont_', toString(rand() % 500)) AS content_id,
    concat('rec_', toString(rand() % 200)) AS recommendation_id,
    now() - toIntervalSecond(rand() % 86400) AS timestamp,
    concat('sess_', lower(hex(randomString(6)))) AS session_id,
    ['mobile', 'desktop', 'tablet', 'tv'][(rand() % 4) + 1] AS device,
    ['web', 'ios', 'android', 'roku', 'firetv'][(rand() % 5) + 1] AS platform,
    10 + rand() % 300 AS duration,
    concat('{"source":"', ['search', 'feed', 'recommendation', 'direct'][(rand() % 4) + 1], '","category":"', ['news', 'sports', 'entertainment', 'technology', 'science'][(rand() % 5) + 1], '"}') AS metadata
FROM numbers(10)