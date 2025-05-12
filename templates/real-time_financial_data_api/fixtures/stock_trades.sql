SELECT
    now() - toIntervalSecond(rand() % 86400) AS timestamp,
    arrayElement(['AAPL', 'GOOGL', 'MSFT', 'AMZN', 'TSLA', 'META', 'NFLX', 'IBM', 'NVDA', 'INTC'], rand() % 10 + 1) AS symbol,
    round(100 + rand() % 900 + rand(), 2) AS price,
    10 + rand() % 1000 AS volume
FROM numbers(10)