SELECT
    concat('evt_', toString(rand() % 1000)) AS event_id,
    concat('usr_', toString(rand() % 500)) AS user_id,
    ['confirmed', 'attended', 'canceled', 'no-show'][1 + rand() % 4] AS attendance_status,
    now() - toIntervalSecond(rand() % 86400) AS check_in_time,
    ['conference', 'workshop', 'webinar', 'meetup', 'concert'][1 + rand() % 5] AS event_type,
    ['Grand Hall', 'Conference Room A', 'Zoom', 'Main Auditorium', 'Studio 5'][1 + rand() % 5] AS venue,
    now() - toIntervalSecond(rand() % 172800) AS timestamp
FROM numbers(10)