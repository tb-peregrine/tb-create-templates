SELECT
    concat('SHIP-', toString(10000 + rand() % 90000)) AS shipment_id,
    concat('PROD-', toString(1000 + rand() % 9000)) AS product_id,
    ['New York', 'Los Angeles', 'Chicago', 'Houston', 'Miami', 'Seattle', 'Boston'][1 + rand() % 7] AS origin_location,
    ['San Francisco', 'Denver', 'Dallas', 'Atlanta', 'Phoenix', 'Portland', 'Detroit'][1 + rand() % 7] AS destination_location,
    10 + rand() % 991 AS quantity,
    now() - toIntervalDay(rand() % 60) AS shipment_timestamp,
    now() + toIntervalDay(rand() % 30) AS estimated_delivery_timestamp,
    now() + toIntervalDay(rand() % 40) AS actual_delivery_timestamp,
    ['Pending', 'In Transit', 'Delivered', 'Delayed', 'Cancelled'][1 + rand() % 5] AS status
FROM numbers(10)