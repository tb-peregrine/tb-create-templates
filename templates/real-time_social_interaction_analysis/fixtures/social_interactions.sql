SELECT
    concat('int_', toString(rand() % 100000)) AS interaction_id,
    concat('user_', toString(rand() % 5000)) AS user_id,
    ['post', 'comment', 'like', 'share'][(rand() % 4) + 1] AS interaction_type,
    concat('content_', toString(rand() % 10000)) AS content_id,
    ['Twitter', 'Facebook', 'Instagram', 'LinkedIn', 'TikTok'][(rand() % 5) + 1] AS platform,
    now() - toIntervalDay(rand() % 30) - toIntervalHour(rand() % 24) AS timestamp,
    concat('This is a sample text content for interaction #', toString(rand() % 1000)) AS text_content,
    rand() % 1000 AS engagement_count,
    arrayMap(x -> concat('tag', toString(x)), range(1, (rand() % 5) + 1)) AS tags
FROM numbers(10)