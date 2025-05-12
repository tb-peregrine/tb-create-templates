SELECT
    concat('cust_', toString(rand() % 10000)) AS customer_id,
    now() - toIntervalDay(30 + rand() % 360) AS join_date,
    now() - toIntervalDay(rand() % 30) AS last_login_date,
    ['Basic', 'Premium', 'Pro', 'Enterprise'][1 + rand() % 4] AS subscription_plan,
    round(9.99 + (rand() % 100), 2) AS subscription_amount,
    ['Monthly', 'Quarterly', 'Annual'][1 + rand() % 3] AS billing_cycle,
    ['Paid', 'Pending', 'Overdue', 'Canceled'][1 + rand() % 4] AS payment_status,
    round(rand() % 10000, 2) AS total_spend,
    rand() % 200 AS number_of_logins,
    rand() % 10 AS customer_service_tickets,
    rand() % 5 + 1 AS ticket_satisfaction_score,
    rand() % 2 AS churn,
    if(rand() % 2 = 1, now() - toIntervalDay(rand() % 60), NULL) AS churn_date,
    ['North America', 'Europe', 'Asia', 'South America', 'Africa', 'Australia'][1 + rand() % 6] AS region,
    ['Web', 'iOS', 'Android', 'Desktop'][1 + rand() % 4] AS platform,
    now() - toIntervalDay(rand() % 90) AS timestamp
FROM numbers(10)