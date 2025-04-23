SELECT
    concat('user_', toString(rand() % 1000)) AS user_id,
    concat('segment_', toString(rand() % 20)) AS segment_id,
    array('new_users', 'active_users', 'churned', 'high_value', 'low_engagement', 'trial', 'premium', 'basic', 'influencer', 'referral')[(rand() % 10) + 1] AS segment_name,
    now() - toIntervalDay(rand() % 365) AS created_at,
    now() - toIntervalDay(rand() % 30) AS updated_at,
    rand() % 2 AS active
FROM numbers(10)