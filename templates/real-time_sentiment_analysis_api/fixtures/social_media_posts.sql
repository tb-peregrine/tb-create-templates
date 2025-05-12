SELECT
    concat('post_', toString(rand() % 100000)) AS post_id,
    ['Twitter', 'Facebook', 'Instagram', 'LinkedIn', 'TikTok'][(rand() % 5) + 1] AS platform,
    ['Just had an amazing day!', 'Can\'t believe what happened today', 'New product launch is going great', 'Feeling disappointed with customer service', 'This is the best thing ever', 'Not happy with recent changes', 'So excited for the weekend!', 'Having technical difficulties today', 'Beautiful sunset to end the day', 'Just announced our quarterly results'][rand() % 10 + 1] AS content,
    concat('user_', toString(rand() % 10000)) AS user_id,
    now() - rand() % (86400 * 30) AS timestamp,
    rand() % 1000 AS likes,
    rand() % 200 AS shares,
    (rand() % 100) / 50 - 1 AS sentiment_score,
    arrayMap(x -> ['news', 'tech', 'politics', 'sports', 'entertainment', 'business', 'health', 'science', 'travel', 'food'][(rand() % 10) + 1], range(1, (rand() % 4) + 1)) AS tags
FROM numbers(10)