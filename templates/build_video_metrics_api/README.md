
# Video Streaming Analytics API

## Tinybird 

### Overview
This project provides a real-time API for analyzing video streaming metrics. It processes events from a video streaming platform to provide insights on video quality, CDN performance, and user engagement patterns.

### Data Sources

#### video_streaming_events
This datasource stores raw events from a video streaming platform including video views, quality metrics, and user interactions. It captures important metrics like buffering events, quality levels, and error occurrences.

**Sample Data Ingestion:**
```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=video_streaming_events" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
         "event_id": "ev_12345",
         "timestamp": "2023-05-15 14:30:00",
         "user_id": "user_789",
         "video_id": "vid_456",
         "event_type": "play",
         "duration": 245.5,
         "buffer_count": 2,
         "quality_level": "1080p",
         "device_type": "mobile",
         "country": "US",
         "session_id": "sess_123456",
         "position": 120.5,
         "error_type": "",
         "cdn": "cloudfront"
     }'
```

### Endpoints

#### video_performance_by_cdn
This endpoint compares video streaming performance across different CDNs. It provides metrics like view count, average duration, buffering issues, error counts, and completion rates to help identify the best-performing CDN providers.

**Example Usage:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/video_performance_by_cdn.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&cdn=cloudfront"
```

**Parameters:**
- `start_date`: Start date for data filtering (format: YYYY-MM-DD HH:MM:SS)
- `end_date`: End date for data filtering (format: YYYY-MM-DD HH:MM:SS)
- `cdn`: (Optional) Filter by specific CDN provider
- `quality_level`: (Optional) Filter by specific quality level (e.g., "1080p")
- `sort_by`: (Optional) Field to sort results by (default: "view_count")
- `limit`: (Optional) Maximum number of results to return (default: 100)

#### video_quality_metrics
This endpoint retrieves quality metrics for specific videos, providing insights on buffering events, playback issues, and viewer engagement. It helps identify problematic videos that may need technical optimization.

**Example Usage:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/video_quality_metrics.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&video_id=vid_456"
```

**Parameters:**
- `start_date`: Start date for data filtering (format: YYYY-MM-DD HH:MM:SS)
- `end_date`: End date for data filtering (format: YYYY-MM-DD HH:MM:SS)
- `video_id`: (Optional) Filter by specific video ID
- `sort_by`: (Optional) Field to sort results by (default: "total_views")
- `limit`: (Optional) Maximum number of results to return (default: 100)

#### user_streaming_activity
This endpoint analyzes user engagement and streaming behavior over time, segmented by device type and country. It provides metrics on views, play/pause events, completions, errors, and average viewing durations.

**Example Usage:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_streaming_activity.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&device_type=mobile&country=US"
```

**Parameters:**
- `start_date`: Start date for data filtering (format: YYYY-MM-DD HH:MM:SS)
- `end_date`: End date for data filtering (format: YYYY-MM-DD HH:MM:SS)
- `device_type`: (Optional) Filter by specific device type
- `country`: (Optional) Filter by specific country
- `limit`: (Optional) Maximum number of results to return (default: 1000)
