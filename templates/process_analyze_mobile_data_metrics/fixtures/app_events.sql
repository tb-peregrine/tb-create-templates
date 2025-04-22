SELECT
    concat('evt_', lower(hex(randomString(8)))) AS event_id,
    concat('usr_', toString(1000 + rand() % 9000)) AS user_id,
    ['app_open', 'page_view', 'button_click', 'purchase', 'login', 'logout', 'search', 'notification_click', 'share', 'rating'][1 + rand() % 10] AS event_type,
    now() - toIntervalDay(rand() % 30) - toIntervalHour(rand() % 24) - toIntervalMinute(rand() % 60) AS timestamp,
    concat('sess_', lower(hex(randomString(6)))) AS session_id,
    ['iPhone', 'Android', 'iPad', 'Android Tablet'][1 + rand() % 4] AS device_type,
    concat(toString(rand() % 16), '.', toString(rand() % 10), '.', toString(rand() % 10)) AS os_version,
    concat('v', toString(1 + rand() % 5), '.', toString(rand() % 10), '.', toString(rand() % 10)) AS app_version,
    ['US', 'UK', 'Canada', 'Germany', 'France', 'Spain', 'Japan', 'Australia', 'Brazil', 'India'][1 + rand() % 10] AS country,
    ['New York', 'London', 'Toronto', 'Berlin', 'Paris', 'Madrid', 'Tokyo', 'Sydney', 'Rio', 'Mumbai'][1 + rand() % 10] AS city,
    ['Home', 'Profile', 'Settings', 'Product', 'Cart', 'Checkout', 'Search', 'Notifications', 'Messages', 'Categories'][1 + rand() % 10] AS screen_name,
    concat('{"duration":', toString(rand() % 300), ',"is_logged_in":', IF(rand() % 2 = 0, 'true', 'false'), ',"items":', toString(rand() % 10), '}') AS properties
FROM numbers(10)