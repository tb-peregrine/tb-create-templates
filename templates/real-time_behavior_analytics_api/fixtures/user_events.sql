SELECT
    concat('ev_', toString(rand() % 100000)) AS event_id,
    concat('user_', toString(rand() % 1000)) AS user_id,
    concat('session_', toString(rand() % 5000)) AS session_id,
    ['page_view', 'click', 'scroll', 'form_submit', 'button_click'][1 + rand() % 5] AS event_type,
    concat('https://example.com/', ['home', 'products', 'about', 'contact', 'blog'][1 + rand() % 5]) AS page_url,
    ['https://google.com', 'https://facebook.com', 'https://twitter.com', 'https://instagram.com', 'direct'][1 + rand() % 5] AS referrer,
    ['desktop', 'mobile', 'tablet'][1 + rand() % 3] AS device_type,
    ['Chrome', 'Firefox', 'Safari', 'Edge'][1 + rand() % 4] AS browser,
    ['USA', 'UK', 'Canada', 'Germany', 'France', 'Japan', 'Australia', 'Brazil', 'India', 'Spain'][1 + rand() % 10] AS country,
    ['New York', 'London', 'Toronto', 'Berlin', 'Paris', 'Tokyo', 'Sydney', 'Rio', 'Mumbai', 'Madrid'][1 + rand() % 10] AS city,
    concat('{"button_id":"btn_', toString(rand() % 100), '","page_section":"', ['header', 'footer', 'main', 'sidebar'][1 + rand() % 4], '"}') AS properties,
    now() - toIntervalSecond(rand() % 86400) AS timestamp
FROM numbers(10)