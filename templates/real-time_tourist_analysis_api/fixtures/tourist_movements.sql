SELECT
    concat('tourist_', toString(rand() % 10000)) AS tourist_id,
    concat('loc_', toString(rand() % 500)) AS location_id,
    arrayElement(['Eiffel Tower', 'Louvre Museum', 'Colosseum', 'Sagrada Familia', 'Big Ben', 'Grand Canyon', 'Statue of Liberty', 'Great Wall', 'Sydney Opera House', 'Taj Mahal'], rand() % 10 + 1) AS location_name,
    (rand() % 180) - 90 + rand() AS latitude,
    (rand() % 360) - 180 + rand() AS longitude,
    arrayElement(['France', 'Italy', 'Spain', 'UK', 'USA', 'China', 'Australia', 'India', 'Japan', 'Brazil'], rand() % 10 + 1) AS country,
    arrayElement(['Paris', 'Rome', 'Barcelona', 'London', 'New York', 'Beijing', 'Sydney', 'Delhi', 'Tokyo', 'Rio de Janeiro'], rand() % 10 + 1) AS city,
    now() - toIntervalDay(rand() % 30) - toIntervalHour(rand() % 24) - toIntervalMinute(rand() % 60) AS timestamp,
    arrayElement(['Sightseeing', 'Museum Visit', 'Dining', 'Shopping', 'Hiking', 'Beach', 'Historical Tour'], rand() % 7 + 1) AS activity_type,
    15 + rand() % 240 AS duration_minutes,
    arrayElement(['USA', 'UK', 'Germany', 'China', 'Japan', 'Russia', 'Canada', 'Australia', 'Brazil', 'India'], rand() % 10 + 1) AS tourist_origin,
    arrayElement(['18-24', '25-34', '35-44', '45-54', '55-64', '65+'], rand() % 6 + 1) AS age_group
FROM numbers(10)