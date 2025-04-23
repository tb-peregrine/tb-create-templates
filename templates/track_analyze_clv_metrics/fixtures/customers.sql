SELECT
    concat('cust_', toString(rand() % 100000)) AS customer_id,
    now() - rand() % (365 * 86400) AS registration_date,
    ['USA', 'UK', 'Canada', 'Germany', 'France', 'Spain', 'Italy', 'Japan', 'Australia', 'Brazil'][1 + rand() % 10] AS country,
    ['New York', 'London', 'Toronto', 'Berlin', 'Paris', 'Madrid', 'Rome', 'Tokyo', 'Sydney', 'Sao Paulo'][1 + rand() % 10] AS city,
    18 + rand() % 70 AS age,
    ['Male', 'Female', 'Other'][1 + rand() % 3] AS gender,
    ['Organic Search', 'Paid Search', 'Social Media', 'Email', 'Referral', 'Direct'][1 + rand() % 6] AS acquisition_source,
    ['Premium', 'Standard', 'Basic', 'Trial'][1 + rand() % 4] AS segment,
    rand() % 2 AS is_active
FROM numbers(10)