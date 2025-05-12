SELECT
    concat('evt_', toString(rand() % 100000)) AS event_id,
    concat('user_', toString(rand() % 1000)) AS user_id,
    concat('session_', toString(rand() % 5000)) AS session_id,
    ['click', 'page_view', 'form_submit', 'button_click', 'search'][rand() % 5 + 1] AS event_type,
    ['login', 'signup', 'purchase', 'add_to_cart', 'checkout', 'search', 'profile_view'][rand() % 7 + 1] AS event_name,
    ['/home', '/products', '/cart', '/checkout', '/profile', '/search', '/settings'][rand() % 7 + 1] AS page,
    ['navigation', 'cart', 'user_profile', 'product_listing', 'search_bar', 'payment_form'][rand() % 6 + 1] AS feature,
    concat('{"action":"', ['view', 'click', 'submit', 'hover', 'scroll'][rand() % 5 + 1], '","duration":', toString(rand() % 300), '}') AS properties,
    now() - toIntervalSecond(rand() % 86400) AS timestamp
FROM numbers(10)