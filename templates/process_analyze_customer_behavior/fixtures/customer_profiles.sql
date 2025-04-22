SELECT
    concat('cust_', toString(rand() % 10000)) AS customer_id,
    concat('user', toString(1000 + rand() % 9000), '@example.com') AS email,
    ['John', 'Emma', 'Michael', 'Sophia', 'William', 'Olivia', 'James', 'Ava', 'Robert', 'Isabella'][(rand() % 10) + 1] AS first_name,
    ['Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Miller', 'Davis', 'Garcia', 'Rodriguez', 'Wilson'][(rand() % 10) + 1] AS last_name,
    18 + rand() % 70 AS age,
    ['Male', 'Female', 'Non-binary'][(rand() % 3) + 1] AS gender,
    ['New York', 'London', 'Paris', 'Tokyo', 'Sydney', 'Berlin', 'Mumbai', 'Toronto', 'Madrid', 'Singapore'][(rand() % 10) + 1] AS city,
    ['USA', 'UK', 'France', 'Japan', 'Australia', 'Germany', 'India', 'Canada', 'Spain', 'Singapore'][(rand() % 10) + 1] AS country,
    today() - toIntervalDay(rand() % 1000) AS signup_date,
    now() - toIntervalDay(rand() % 30) - toIntervalHour(rand() % 24) - toIntervalMinute(rand() % 60) AS last_login,
    ['Premium', 'Standard', 'Basic', 'Enterprise', 'Trial'][(rand() % 5) + 1] AS customer_segment,
    round(rand() * 10000, 2) AS lifetime_value
FROM numbers(10)