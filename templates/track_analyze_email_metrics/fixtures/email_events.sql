SELECT
    concat('ev_', lower(hex(randomString(8)))) AS event_id,
    concat('camp_', toString(rand() % 10 + 1)) AS campaign_id,
    concat('rec_', toString(rand() % 1000 + 1)) AS recipient_id,
    concat('user', toString(rand() % 100), '@', ['gmail.com', 'yahoo.com', 'hotmail.com', 'outlook.com', 'company.com'][(rand() % 5) + 1]) AS email,
    ['sent', 'opened', 'clicked', 'bounced', 'unsubscribed'][(rand() % 5) + 1] AS event_type,
    now() - rand() % (86400 * 30) AS event_timestamp,
    concat(toString(rand() % 256), '.', toString(rand() % 256), '.', toString(rand() % 256), '.', toString(rand() % 256)) AS ip_address,
    ['Mozilla/5.0 (Windows NT 10.0; Win64; x64)', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)', 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X)', 'Mozilla/5.0 (Linux; Android 11)'][(rand() % 4) + 1] AS user_agent,
    concat('https://example.com/', ['promo', 'newsletter', 'offer', 'update'][(rand() % 4) + 1], '/', toString(rand() % 100)) AS link_url,
    ['desktop', 'mobile', 'tablet'][(rand() % 3) + 1] AS device_type,
    ['USA', 'UK', 'Canada', 'Germany', 'France', 'Japan', 'Australia', 'Brazil', 'India', 'Mexico'][(rand() % 10) + 1] AS country,
    ['New York', 'London', 'Toronto', 'Berlin', 'Paris', 'Tokyo', 'Sydney', 'Sao Paulo', 'Mumbai', 'Mexico City'][(rand() % 10) + 1] AS city
FROM numbers(10)