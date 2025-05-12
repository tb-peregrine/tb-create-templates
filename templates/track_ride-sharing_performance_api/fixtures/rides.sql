SELECT
    concat('ride_', toString(rand() % 100000)) AS ride_id,
    concat('driver_', toString(rand() % 1000)) AS driver_id,
    concat('user_', toString(rand() % 5000)) AS user_id,
    now() - toIntervalHour(rand() % 24) - toIntervalMinute(rand() % 60) AS pickup_time,
    now() - toIntervalMinute(rand() % 60) AS dropoff_time,
    ['Manhattan', 'Brooklyn', 'Queens', 'Bronx', 'Staten Island'][(rand() % 5) + 1] AS pickup_location,
    ['Manhattan', 'Brooklyn', 'Queens', 'Bronx', 'Staten Island'][(rand() % 5) + 1] AS dropoff_location,
    round(1 + rand() % 30 + rand(), 2) AS distance_km,
    5 + rand() % 55 AS duration_minutes,
    round(5 + rand() % 45 + rand(), 2) AS fare_amount,
    1 + rand() % 5 AS rating,
    ['completed', 'cancelled', 'in_progress'][(rand() % 3) + 1] AS status,
    ['iOS', 'Android', 'Web'][(rand() % 3) + 1] AS platform,
    ['New York', 'Chicago', 'Los Angeles', 'Miami', 'Seattle'][(rand() % 5) + 1] AS city,
    now() - toIntervalDay(rand() % 30) AS timestamp
FROM numbers(10)