SELECT
    concat('user_', toString(100000 + rand() % 900000)) AS user_id,
    today() - toIntervalDay(rand() % 365) AS cohort_date,
    ['Organic', 'Social Media', 'Referral', 'Email', 'Paid Search'][(rand() % 5) + 1] AS acquisition_source,
    ['New', 'Returning', 'Inactive', 'Power User', 'Casual'][(rand() % 5) + 1] AS user_segment,
    ['Free', 'Basic', 'Premium', 'Enterprise', 'Trial'][(rand() % 5) + 1] AS initial_subscription_plan
FROM numbers(10)