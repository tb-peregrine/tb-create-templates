SELECT
    concat('ref_', toString(rand() % 100000)) AS referral_id,
    concat('user_', toString(rand() % 10000)) AS referrer_id,
    concat('user_', toString(10000 + rand() % 10000)) AS new_user_id,
    concat(substring(replaceRegexpAll(upper(hex(randomString(4))), '(.)', '\\1'), 1, 8)) AS referral_code,
    ['email', 'social_media', 'direct_link', 'app_invite', 'sms'][1 + rand() % 5] AS referral_channel,
    now() - toIntervalDay(rand() % 90) AS referral_date,
    rand() % 2 AS converted,
    now() - toIntervalDay(rand() % 60) AS conversion_date,
    rand() % 2 AS reward_given,
    ['credit', 'discount', 'free_month', 'points', 'gift_card'][1 + rand() % 5] AS reward_type,
    round(5 + rand() % 45 + rand(), 2) AS reward_amount
FROM numbers(10)