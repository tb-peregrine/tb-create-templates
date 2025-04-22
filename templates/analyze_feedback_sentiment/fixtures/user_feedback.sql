SELECT
    concat('fb_', toString(rand() % 10000)) AS feedback_id,
    concat('user_', toString(rand() % 5000)) AS user_id,
    randomPrintableASCII(50 + rand() % 150) AS feedback_text,
    1 + rand() % 5 AS rating,
    now() - toIntervalSecond(rand() % (86400 * 30)) AS timestamp,
    concat('prod_', toString(rand() % 100)) AS product_id,
    ['email', 'website', 'app', 'phone', 'in-store'][1 + rand() % 5] AS channel
FROM numbers(10)