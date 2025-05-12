SELECT
    concat('ev_', toString(rand() % 100000)) AS event_id,
    now() - toIntervalSecond(rand() % 604800) AS timestamp,
    ['sent', 'opened', 'clicked', 'bounced', 'unsubscribed'][(rand() % 5) + 1] AS event_type,
    concat('camp_', toString(rand() % 10)) AS campaign_id,
    concat('email_', toString(rand() % 1000)) AS email_id,
    concat('user_', toString(rand() % 100)) AS recipient_id,
    concat('user', toString(rand() % 100), '@example.com') AS recipient_email,
    multiIf(
        rand() % 5 = 2, 'https://example.com/promo',
        rand() % 5 = 3, 'https://example.com/landing',
        rand() % 5 = 4, 'https://example.com/unsubscribe',
        '') AS link_url,
    concat('{"source":"', ['newsletter', 'promotion', 'announcement'][rand() % 3 + 1], '"}') AS metadata,
    ['Mozilla/5.0 (iPhone)', 'Mozilla/5.0 (Android)', 'Mozilla/5.0 (Windows)', 'Mozilla/5.0 (Macintosh)'][rand() % 4 + 1] AS user_agent
FROM numbers(10)