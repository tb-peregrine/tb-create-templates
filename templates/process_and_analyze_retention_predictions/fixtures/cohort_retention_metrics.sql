SELECT
    today() - rand() % 180 AS cohort_date,
    ['mobile_android', 'mobile_ios', 'web', 'desktop', 'email'][rand() % 5 + 1] AS segment,
    1000 + rand() % 5000 AS cohort_size,
    800 + rand() % 3000 AS day_1_retained,
    600 + rand() % 2500 AS day_7_retained,
    500 + rand() % 2000 AS day_14_retained,
    400 + rand() % 1500 AS day_30_retained,
    300 + rand() % 1000 AS day_60_retained,
    200 + rand() % 800 AS day_90_retained,
    round(0.7 + rand() % 20 / 100, 2) AS day_1_rate,
    round(0.5 + rand() % 25 / 100, 2) AS day_7_rate,
    round(0.4 + rand() % 20 / 100, 2) AS day_14_rate,
    round(0.3 + rand() % 20 / 100, 2) AS day_30_rate,
    round(0.2 + rand() % 20 / 100, 2) AS day_60_rate,
    round(0.1 + rand() % 20 / 100, 2) AS day_90_rate
FROM numbers(10)