SELECT
    concat('tx_', toString(rand() % 100000)) AS transaction_id,
    concat('user_', toString(rand() % 1000)) AS user_id,
    round(10 + rand() % 990 + rand(), 2) AS amount,
    ['groceries', 'dining', 'entertainment', 'shopping', 'utilities', 'travel', 'healthcare', 'education'][1 + rand() % 8] AS category,
    ['Walmart', 'Amazon', 'Target', 'Starbucks', 'Chipotle', 'Netflix', 'Uber', 'Spotify', 'Home Depot', 'CVS'][1 + rand() % 10] AS merchant,
    now() - toIntervalDay(rand() % 30) - toIntervalHour(rand() % 24) - toIntervalMinute(rand() % 60) AS timestamp,
    ['credit', 'debit', 'paypal', 'cash', 'mobile_payment'][1 + rand() % 5] AS payment_method,
    ['New York', 'Los Angeles', 'Chicago', 'Houston', 'Phoenix', 'San Francisco', 'Seattle', 'Miami', 'Boston', 'Atlanta'][1 + rand() % 10] AS location
FROM numbers(10)