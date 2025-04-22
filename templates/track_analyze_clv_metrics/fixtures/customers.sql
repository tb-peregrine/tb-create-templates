SELECT
    concat('cust_', toString(rand() % 10000)) AS customer_id,
    concat('User ', toString(rand() % 1000)) AS name,
    concat('user', toString(rand() % 1000), '@example.com') AS email,
    now() - toIntervalDay(rand() % 365) AS signup_date,
    ['US', 'UK', 'Canada', 'Germany', 'France', 'Spain', 'Italy', 'Japan', 'Australia', 'Brazil'][1 + (rand() % 10)] AS country,
    ['Premium', 'Standard', 'Basic', 'Enterprise', 'Trial'][1 + (rand() % 5)] AS customer_segment,
    ['Organic Search', 'Paid Search', 'Social Media', 'Email Campaign', 'Referral', 'Direct'][1 + (rand() % 6)] AS acquisition_source,
    rand() % 2 AS active,
    now() - toIntervalDay(rand() % 400) AS created_at
FROM numbers(10)