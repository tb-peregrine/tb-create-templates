SELECT
    concat('rec_', toString(rand() % 10000)) AS recipient_id,
    concat('user', toString(rand() % 1000), '@', ['gmail.com', 'yahoo.com', 'outlook.com', 'hotmail.com', 'example.com'][(rand() % 5) + 1]) AS email,
    ['John', 'Jane', 'Michael', 'Emma', 'David', 'Sarah', 'Thomas', 'Lisa', 'Robert', 'Mary'][(rand() % 10) + 1] AS first_name,
    ['Smith', 'Johnson', 'Brown', 'Davis', 'Wilson', 'Miller', 'Jones', 'Garcia', 'Martinez', 'Lee'][(rand() % 10) + 1] AS last_name,
    now() - toIntervalDay(rand() % 365) AS created_at,
    now() - toIntervalDay(rand() % 30) AS updated_at,
    ['active', 'inactive', 'unsubscribed', 'bounced', 'pending'][(rand() % 5) + 1] AS status,
    concat('seg_', toString(rand() % 20)) AS segment_id,
    concat('{"preferences":{"frequency":"', ['daily', 'weekly', 'monthly'][(rand() % 3) + 1], '","topics":["', ['news', 'updates', 'promotions', 'events'][(rand() % 4) + 1], '"]}}') AS metadata
FROM numbers(10)