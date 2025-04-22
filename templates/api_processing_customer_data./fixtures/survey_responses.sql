SELECT
    concat('resp_', toString(rand() % 100000)) AS response_id,
    concat('cust_', toString(rand() % 10000)) AS customer_id,
    now() - toIntervalDay(rand() % 365) - toIntervalHour(rand() % 24) - toIntervalMinute(rand() % 60) AS timestamp,
    toInt8(rand() % 11) AS nps_score,
    multiIf(
        rand() % 3 = 0, 'I love your product! It has transformed how I work.',
        rand() % 3 = 1, 'The product is okay but could use some improvements in usability.',
        'I am experiencing some issues with your service that need to be addressed.'
    ) AS feedback,
    ['email', 'website', 'in-app', 'phone', 'social_media'][1 + rand() % 5] AS channel,
    ['software', 'hardware', 'service', 'consulting', 'support'][1 + rand() % 5] AS product_type,
    toInt32(30 + rand() % 3000) AS customer_tenure_days,
    ['enterprise', 'mid-market', 'small business', 'individual'][1 + rand() % 4] AS customer_segment
FROM numbers(10)