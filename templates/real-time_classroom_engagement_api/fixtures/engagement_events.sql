SELECT
    concat('evt_', lower(hex(randomString(8)))) AS event_id,
    concat('stu_', toString(rand() % 1000)) AS student_id,
    concat('cls_', toString(rand() % 100)) AS class_id,
    ['assignment_started', 'assignment_completed', 'question_answered', 'video_watched', 'resource_accessed'][(rand() % 5) + 1] AS event_type,
    now() - rand() % (86400 * 30) AS timestamp,
    10 + rand() % 1800 AS duration_seconds,
    concat('content_', toString(rand() % 500)) AS content_id,
    concat('{"difficulty":"', ['easy', 'medium', 'hard'][(rand() % 3) + 1], '","score":', toString(rand() % 100), ',"correct":', toString(rand() % 2), '}') AS metadata
FROM numbers(10)