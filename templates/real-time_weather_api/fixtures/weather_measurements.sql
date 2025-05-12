SELECT
    concat('STATION_', toString(rand() % 1000)) AS station_id,
    ['New York', 'Los Angeles', 'Chicago', 'Houston', 'Phoenix', 'London', 'Paris', 'Berlin', 'Tokyo', 'Sydney'][rand() % 10 + 1] AS location,
    (rand() % 180) - 90 + rand() AS latitude,
    (rand() % 360) - 180 + rand() AS longitude,
    (rand() % 50) - 20 + rand() AS temperature,
    rand() % 101 AS humidity,
    980 + rand() % 50 AS pressure,
    rand() % 100 AS wind_speed,
    rand() % 360 AS wind_direction,
    rand() % 50 AS precipitation,
    now() - toIntervalSecond(rand() % 86400) AS timestamp,
    ['USA', 'UK', 'France', 'Germany', 'Japan', 'Australia', 'Canada', 'Brazil', 'China', 'India'][rand() % 10 + 1] AS country,
    ['North', 'South', 'East', 'West', 'Central', 'Northwest', 'Northeast', 'Southwest', 'Southeast'][rand() % 9 + 1] AS region
FROM numbers(10)