SELECT
    concat('camp_', toString(rand() % 10000)) AS campaign_id,
    concat('Campaign ', toString(rand() % 100 + 1)) AS campaign_name,
    now() - toIntervalDay(rand() % 90) AS start_date,
    now() + toIntervalDay(rand() % 90) AS end_date,
    round(1000 + rand() % 50000, 2) AS budget,
    ['Young Adults', 'Seniors', 'Families', 'Students', 'Professionals'][(rand() % 5) + 1] AS target_audience,
    ['Email', 'Social Media', 'Search', 'Display', 'Video', 'Direct Mail'][(rand() % 6) + 1] AS channel,
    ['Brand Awareness', 'Lead Generation', 'Sales Conversion', 'Customer Retention', 'Product Launch'][(rand() % 5) + 1] AS goal
FROM numbers(10)