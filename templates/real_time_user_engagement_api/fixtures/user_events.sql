SELECT
    now() - rand() % (86400 * 30) AS timestamp,
    concat('user_', toString(rand() % 1000)) AS user_id,
    ['pageview', 'click', 'scroll', 'purchase', 'signup'][(rand() % 5) + 1] AS event_type,
    ['mobile', 'desktop', 'tablet'][(rand() % 3) + 1] AS device,
    ['ios', 'android', 'web', 'macos', 'windows'][(rand() % 5) + 1] AS platform,
    concat('session_', toString(rand() % 5000)) AS session_id,
    rand() % 600 AS duration,
    ['/home', '/products', '/checkout', '/about', '/contact'][(rand() % 5) + 1] AS page,
    ['USA', 'UK', 'Canada', 'Germany', 'France', 'Japan', 'Australia', 'Brazil'][(rand() % 8) + 1] AS country,
    ['North', 'South', 'East', 'West', 'Central'][(rand() % 5) + 1] AS region,
    ['New York', 'London', 'Toronto', 'Berlin', 'Paris', 'Tokyo', 'Sydney', 'Rio de Janeiro'][(rand() % 8) + 1] AS city
FROM numbers(10)