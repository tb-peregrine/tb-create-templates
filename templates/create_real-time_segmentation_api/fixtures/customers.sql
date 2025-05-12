SELECT
    concat('cust_', toString(rand() % 10000)) AS customer_id,
    arrayElement(['John Smith', 'Mary Johnson', 'Robert Davis', 'Jennifer Wilson', 'Michael Brown', 'Elizabeth Jones', 'William Miller', 'Patricia Moore', 'David Anderson', 'Linda Taylor'], rand() % 10 + 1) AS name,
    concat(lower(arrayElement(['john', 'mary', 'robert', 'jennifer', 'michael', 'elizabeth', 'william', 'patricia', 'david', 'linda'], rand() % 10 + 1)), '@', arrayElement(['gmail.com', 'yahoo.com', 'hotmail.com', 'outlook.com', 'icloud.com'], rand() % 5 + 1)) AS email,
    18 + rand() % 70 AS age,
    arrayElement(['Male', 'Female', 'Non-binary', 'Prefer not to say'], rand() % 4 + 1) AS gender,
    arrayElement(['New York', 'Los Angeles', 'Chicago', 'Houston', 'Phoenix', 'Philadelphia', 'San Antonio', 'San Diego', 'Dallas', 'San Jose'], rand() % 10 + 1) AS location,
    now() - toIntervalDay(rand() % 1000) AS signup_date,
    round(rand() % 5000 + rand(), 2) AS lifetime_value,
    now() - toIntervalHour(rand() % 8760) AS timestamp
FROM numbers(10)