SELECT
    concat('msg_', toString(rand() % 100000)) AS message_id,
    concat('user_', toString(rand() % 1000)) AS sender_id,
    concat('user_', toString(rand() % 1000)) AS recipient_id,
    concat('conv_', toString(rand() % 500)) AS conversation_id,
    ['text', 'image', 'video', 'audio', 'file'][(rand() % 5) + 1] AS message_type,
    concat('This is a sample message with id ', toString(rand() % 10000)) AS message_content,
    now() - toIntervalSecond(rand() % 2592000) AS timestamp,
    rand() % 2 AS read,
    arrayMap(x -> concat('attachment_', toString(x)), range(1, (rand() % 3) + 1)) AS attachments,
    10 + rand() % 200 AS character_count
FROM numbers(10)