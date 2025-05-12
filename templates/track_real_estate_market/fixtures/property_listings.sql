SELECT
    concat('L', toString(10000 + rand() % 90000)) AS listing_id,
    round(100000 + rand() % 900000 + rand() % 1000, 2) AS price,
    1 + rand() % 5 AS bedrooms,
    round(1 + rand() % 3 + rand() % 10 / 10, 1) AS bathrooms,
    800 + rand() % 3000 AS sqft,
    ['House', 'Apartment', 'Condo', 'Townhouse', 'Duplex'][(rand() % 5) + 1] AS property_type,
    ['New York', 'Los Angeles', 'Chicago', 'Houston', 'Phoenix', 'Philadelphia', 'San Antonio', 'San Diego', 'Dallas', 'San Jose'][(rand() % 10) + 1] AS city,
    ['NY', 'CA', 'IL', 'TX', 'AZ', 'PA', 'TX', 'CA', 'TX', 'CA'][(rand() % 10) + 1] AS state,
    concat(toString(10000 + rand() % 90000)) AS zip_code,
    now() - toIntervalDay(rand() % 180) AS listing_date,
    ['Active', 'Sold', 'Pending', 'Withdrawn'][(rand() % 4) + 1] AS status,
    rand() % 120 AS days_on_market
FROM numbers(10)