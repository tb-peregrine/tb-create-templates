SELECT
    concat('qid_', toString(rand() % 1000000)) AS query_id,
    concat('user_', toString(rand() % 10000)) AS user_id,
    ['how to make pasta', 'best smartphones 2023', 'hiking boots review', 'javascript tutorial', 'vacation destinations europe', 'car repair near me', 'weight loss tips', 'python for beginners', 'book recommendations sci-fi', 'healthy breakfast ideas'][rand() % 10] AS query_text,
    now() - toIntervalSecond(rand() % 2592000) AS timestamp,
    ['mobile', 'desktop', 'tablet', 'smart_tv', 'mobile_app'][rand() % 5] AS device_type,
    concat('sess_', toString(rand() % 100000)) AS session_id,
    5 + rand() % 95 AS results_count,
    arrayMap(x -> concat('result_', toString(x)), range(1, 1 + rand() % 5)) AS clicked_results,
    ['products', 'services', 'articles', 'videos', 'images', 'local', 'news'][rand() % 7] AS search_category,
    concat('{"price":"', toString(rand() % 1000), '","brand":"brand', toString(rand() % 10), '","sort":"', ['relevance', 'price_asc', 'price_desc', 'rating'][rand() % 4], '"}') AS search_filters,
    100 + rand() % 9900 AS search_duration_ms,
    ['New York', 'London', 'Tokyo', 'Paris', 'Berlin', 'Sydney', 'Toronto', 'Mumbai', 'São Paulo', 'Cairo'][rand() % 10] AS user_location
FROM numbers(10)