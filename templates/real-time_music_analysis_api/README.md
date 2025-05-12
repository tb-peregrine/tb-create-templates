# Music Streaming Analytics API

## Tinybird

### Overview
This project provides a real-time API for analyzing music streaming behavior. It allows you to track and analyze user listening patterns, identify popular tracks, examine user activity, and monitor genre trends over time.

### Data Sources

#### music_streams
This datasource stores records of music streaming events capturing user listening behavior. Each record includes information about the stream, user, track, artist, album, genre, and other relevant metadata.

**Sample Data Ingestion:**
```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=music_streams" \
    -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
    -d '{
    "stream_id": "s123456",
    "user_id": "u789012", 
    "track_id": "t345678",
    "artist_id": "a123456",
    "album_id": "alb789012",
    "genre": "rock",
    "stream_start_time": "2023-03-15 14:30:00",
    "stream_duration_seconds": 240,
    "completed": 1,
    "device_type": "smartphone",
    "country": "US"
}'
```

### Endpoints

#### top_tracks
Returns the top tracks by number of streams within a given time period. You can filter by genre and country, and set a limit for the number of results.

**Sample Request:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/top_tracks.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&genre=rock&country=US&limit=5"
```

#### user_activity
Analyzes a specific user's streaming activity over time, including stream count, listening minutes, and diversity of tracks, artists, albums, and genres.

**Sample Request:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_activity.json?token=$TB_ADMIN_TOKEN&user_id=u789012&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&limit=10"
```

#### genre_trends
Shows genre popularity trends over time, helping to identify rising or declining music genres. Results can be filtered by country.

**Sample Request:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/genre_trends.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&country=US"
```

**Note:** For all endpoints, DateTime parameters must be formatted as YYYY-MM-DD HH:MM:SS, or else the request will fail.
