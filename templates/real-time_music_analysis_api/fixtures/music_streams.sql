SELECT
    concat('stream_', toString(rand() % 10000)) AS stream_id,
    concat('user_', toString(rand() % 1000)) AS user_id,
    concat('track_', toString(rand() % 5000)) AS track_id,
    concat('artist_', toString(rand() % 500)) AS artist_id,
    concat('album_', toString(rand() % 1000)) AS album_id,
    ['rock', 'pop', 'jazz', 'hip-hop', 'classical', 'electronic', 'country', 'reggae', 'blues', 'folk'][(rand() % 10) + 1] AS genre,
    now() - toIntervalDay(rand() % 30) - toIntervalHour(rand() % 24) AS stream_start_time,
    60 + rand() % 240 AS stream_duration_seconds,
    rand() % 2 AS completed,
    ['mobile', 'desktop', 'tablet', 'smart_speaker', 'tv'][(rand() % 5) + 1] AS device_type,
    ['US', 'UK', 'CA', 'JP', 'DE', 'FR', 'BR', 'AU', 'IN', 'MX'][(rand() % 10) + 1] AS country
FROM numbers(10)