SELECT
    concat('PKG-', toString(1000 + rand() % 9000)) AS package_id,
    now() - toIntervalDay(rand() % 30) - toIntervalHour(rand() % 24) AS event_timestamp,
    ['Picked up', 'In transit', 'Out for delivery', 'Delivered', 'Delayed', 'Returned to sender'][1 + rand() % 6] AS status,
    ['New York, NY', 'Los Angeles, CA', 'Chicago, IL', 'Houston, TX', 'Miami, FL', 'Seattle, WA', 'Boston, MA', 'Denver, CO'][1 + rand() % 8] AS location,
    ['FedEx', 'UPS', 'USPS', 'DHL', 'Amazon Logistics'][1 + rand() % 5] AS carrier,
    ['Package received at facility', 'Package in transit to next facility', 'Vehicle departed with package', 'Package delivered to recipient', 'Delivery attempted - recipient not available', 'Weather delay', 'No additional notes'][1 + rand() % 7] AS notes,
    concat('agent_', toString(100 + rand() % 900)) AS updated_by
FROM numbers(10)