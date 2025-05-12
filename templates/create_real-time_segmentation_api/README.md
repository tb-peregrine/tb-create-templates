
# Customer Segmentation API

## Tinybird

### Overview
This project provides a real-time customer segmentation API that allows you to analyze and segment customers based on their behavior and attributes. The API enables you to retrieve customer segments, analyze engagement patterns, and get segment summaries to support targeted marketing campaigns and personalized experiences.

### Data Sources

#### customers
Stores customer information including demographic data and customer IDs.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=customers" \
  -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
  -d '{
    "customer_id": "cust123",
    "name": "John Doe",
    "email": "john.doe@example.com",
    "age": 35,
    "gender": "male",
    "location": "New York",
    "signup_date": "2022-05-15 10:30:00",
    "lifetime_value": 750.50,
    "timestamp": "2023-10-01 12:00:00"
  }'
```

#### customer_events
Tracks customer activity events such as purchases, logins, page views, etc.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=customer_events" \
  -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
  -d '{
    "event_id": "evt456",
    "customer_id": "cust123",
    "event_type": "purchase",
    "event_value": 125.99,
    "product_id": "prod789",
    "category": "electronics",
    "timestamp": "2023-10-02 15:45:00"
  }'
```

### Endpoints

#### customer_segment_lookup
Look up a customer's segment based on their customer ID. This endpoint categorizes customers into value segments (VIP, High Value, Medium Value, Low Value) and loyalty segments (Loyal, Established, New).

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/customer_segment_lookup.json?customer_id=cust123&token=$TB_ADMIN_TOKEN"
```

#### customer_engagement_analysis
Analyze customer engagement based on events, with options to filter by date range and event types. This endpoint provides insights into activity levels (Active, Recent, Inactive, Dormant).

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/customer_engagement_analysis.json?token=$TB_ADMIN_TOKEN&event_type=purchase&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&limit=50"
```

#### customer_segments_summary
Get a summary of customer segments showing counts and average lifetime value by segment. This endpoint can be filtered by location and age range.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/customer_segments_summary.json?token=$TB_ADMIN_TOKEN&location=New%20York&min_age=25&max_age=45"
```
