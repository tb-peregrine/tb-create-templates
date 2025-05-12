SELECT
    now() - toIntervalSecond(rand() % 86400) AS event_time,
    ['email', 'social', 'search', 'display', 'direct'][(rand() % 5) + 1] AS channel,
    ['summer_sale', 'black_friday', 'holiday_special', 'new_product', 'loyalty_program'][(rand() % 5) + 1] AS campaign,
    concat('user_', toString(rand() % 1000)) AS user_id,
    ['impression', 'click', 'conversion', 'purchase', 'signup'][(rand() % 5) + 1] AS event_type
FROM numbers(10)