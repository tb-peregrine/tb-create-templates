SELECT
    concat('imp_', toString(rand() % 100000)) AS impression_id,
    concat('ad_', toString(rand() % 1000)) AS ad_id,
    concat('camp_', toString(rand() % 100)) AS campaign_id,
    ['Web', 'Mobile App', 'Social Media', 'Email', 'Search'][rand() % 5 + 1] AS platform,
    now() - toIntervalSecond(rand() % 86400) AS timestamp,
    concat('user_', toString(rand() % 5000)) AS user_id,
    ['USA', 'UK', 'Canada', 'Germany', 'France', 'Japan', 'Australia', 'Brazil', 'India', 'Mexico'][rand() % 10 + 1] AS country,
    ['Desktop', 'Mobile', 'Tablet', 'Smart TV', 'Console'][rand() % 5 + 1] AS device_type
FROM numbers(10)