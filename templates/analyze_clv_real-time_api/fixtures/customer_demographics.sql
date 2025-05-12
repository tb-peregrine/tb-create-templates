SELECT
    concat('cust_', toString(rand() % 10000)) AS customer_id,
    18 + rand() % 70 AS age,
    ['New York', 'Los Angeles', 'Chicago', 'Houston', 'Phoenix', 'Philadelphia', 'San Antonio', 'San Diego', 'Dallas', 'San Jose'][(rand() % 10) + 1] AS location
FROM numbers(10)