SELECT
    concat('cust_', toString(rand() % 10000)) AS customer_id,
    sumState(toFloat64(100 + rand() % 900)) AS total_spend,
    countState(toUInt64(1 + rand() % 50)) AS purchase_count,
    now() - toIntervalDay((rand() % 365) * 2) AS first_purchase_date,
    now() - toIntervalDay(rand() % 30) AS last_purchase_date,
    ['VIP', 'Regular', 'New', 'Inactive', 'High-Value'][(rand() % 5) + 1] AS customer_segment,
    ['USA', 'Canada', 'UK', 'Germany', 'France', 'Japan', 'Australia', 'Brazil', 'India', 'China'][(rand() % 10) + 1] AS country,
    ['Organic Search', 'Paid Search', 'Email', 'Social Media', 'Referral', 'Direct'][(rand() % 6) + 1] AS acquisition_source,
    now() - toIntervalHour(rand() % 24) AS updated_at
FROM numbers(10)