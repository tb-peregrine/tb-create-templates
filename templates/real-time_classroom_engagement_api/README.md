
# Classroom Engagement Analytics API

A real-time API built with Tinybird to track and analyze student engagement in classroom activities.

## Tinybird

### Overview

This project provides a real-time analytics API for tracking student engagement in classroom activities. It captures various engagement events like video views, quiz completions, and discussion participation to help educators understand student interaction patterns and improve learning outcomes.

### Data Sources

#### engagement_events

This datasource stores raw engagement events from classroom activities, capturing detailed information about how students interact with learning content.

**Sample Ingestion:**

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=engagement_events" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "event_id": "e12345",
       "student_id": "ST001",
       "class_id": "CL001",
       "event_type": "video_view",
       "timestamp": "2023-05-15 14:30:00",
       "duration_seconds": 300,
       "content_id": "VID123",
       "metadata": "{\"completion_percentage\": 85, \"device\": \"laptop\"}"
     }'
```

### Endpoints

#### student_engagement

This endpoint tracks engagement metrics for a specific student over time, allowing educators to analyze individual learning patterns and identify opportunities for personalized support.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/student_engagement.json?token=$TB_ADMIN_TOKEN&student_id=ST001&class_id=CL001&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59"
```

#### real_time_class_participation

This endpoint provides real-time insights into classroom participation, helping teachers gauge engagement levels during and after class sessions.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/real_time_class_participation.json?token=$TB_ADMIN_TOKEN&class_id=CL001&hours_back=24"
```

#### class_activity_summary

This endpoint generates a comprehensive summary of classroom activity over a specified period, enabling educators to identify engagement trends and assess the effectiveness of teaching materials.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/class_activity_summary.json?token=$TB_ADMIN_TOKEN&class_id=CL001&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59"
```
