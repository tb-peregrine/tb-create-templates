SELECT
    concat('user_', toString(rand() % 10000)) AS user_id,
    now() - toIntervalDay(rand() % 365) AS sign_up_date,
    ['free', 'premium', 'enterprise'][1 + rand() % 3] AS user_type,
    ['active', 'inactive', 'suspended', 'pending'][1 + rand() % 4] AS account_status,
    ['basic', 'standard', 'professional', 'enterprise', 'custom'][1 + rand() % 5] AS subscription_plan,
    ['US', 'UK', 'Canada', 'Germany', 'France', 'Australia', 'Japan', 'Brazil', 'India', 'Spain'][1 + rand() % 10] AS country,
    concat('org_', toString(rand() % 100)) AS organization_id,
    concat('Organization ', toString(rand() % 100)) AS organization_name,
    now() - toIntervalDay(rand() % 30) - toIntervalHour(rand() % 24) AS last_login
FROM numbers(10)