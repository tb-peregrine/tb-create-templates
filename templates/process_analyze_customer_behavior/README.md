
# Customer Analytics API

## Tinybird

### Overview

This Tinybird project implements a customer analytics API that processes and analyzes customer behavior data with segmentation capabilities. It allows you to track customer events, manage customer profiles, define customer segments, and analyze customer behavior patterns to generate insights for marketing and customer experience optimization.

### Data Sources

#### customer_events

Stores raw customer behavior events including page views, purchases, and other interactions. This datasource is the foundation for behavioral analysis.

```
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=customer_events" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "event_id": "ev-12345",
       "customer_id": "cust-789",
       "event_type": "purchase",
       "event_timestamp": "2023-06-15 14:30:45",
       "session_id": "sess-456",
       "page_url": "https://example.com/product/123",
       "product_id": "prod-123",
       "category_id": "cat-456",
       "price": 49.99,
       "quantity": 1,
       "device_type": "mobile",
       "country": "US",
       "referrer": "google.com",
       "user_agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X)"
     }'
```

#### customer_profiles

Stores customer profile information including demographics and account details. This datasource helps in contextualizing customer behavior.

```
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=customer_profiles" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "customer_id": "cust-789",
       "email": "john.doe@example.com",
       "first_name": "John",
       "last_name": "Doe",
       "age": 35,
       "gender": "male",
       "city": "New York",
       "country": "US",
       "signup_date": "2023-01-15",
       "last_login": "2023-06-18 09:15:30",
       "customer_segment": "High Value",
       "lifetime_value": 1250.75
     }'
```

#### customer_segments

Stores customer segmentation data including behavioral and value-based segments. This datasource defines various customer segments used for targeting.

```
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=customer_segments" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "segment_id": "seg-123",
       "segment_name": "High Value Active",
       "segment_description": "Customers who spend more than $1000 and have high engagement",
       "creation_date": "2023-01-01",
       "update_date": "2023-06-01",
       "segment_rules": "total_spent > 1000 AND session_count > 10",
       "segment_type": "value-based"
     }'
```

### Endpoints

#### customer_purchase_history

Retrieves purchase history for a specific customer with detailed information.

```
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/customer_purchase_history.json?customer_id=cust-789&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&token=$TB_ADMIN_TOKEN"
```

Parameters:
- `customer_id` (required): Customer ID to retrieve purchase history for
- `start_date` (optional): Start date for filtering purchases (format: YYYY-MM-DD HH:MM:SS)
- `end_date` (optional): End date for filtering purchases (format: YYYY-MM-DD HH:MM:SS)
- `category_id` (optional): Filter purchases by category
- `limit` (optional): Maximum number of results to return (default: 50)

#### customer_activity

Retrieves event activity for a specific customer with filtering options.

```
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/customer_activity.json?customer_id=cust-789&event_type=page_view&token=$TB_ADMIN_TOKEN"
```

Parameters:
- `customer_id` (required): Customer ID to retrieve activity for
- `event_type` (optional): Filter by specific event type
- `start_date` (optional): Start date for filtering events (format: YYYY-MM-DD HH:MM:SS)
- `end_date` (optional): End date for filtering events (format: YYYY-MM-DD HH:MM:SS)
- `limit` (optional): Maximum number of results to return (default: 100)

#### customer_segmentation_suggestions

Generates customer segmentation suggestions based on behavioral patterns and purchase history.

```
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/customer_segmentation_suggestions.json?token=$TB_ADMIN_TOKEN"
```

This endpoint automatically analyzes all customers and suggests appropriate segments based on their behavior.

#### customer_behavioral_analysis

Analyzes customer behavior patterns across different event types and time periods.

```
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/customer_behavioral_analysis.json?start_date=2023-01-01%2000:00:00&end_date=2023-06-30%2023:59:59&event_type=purchase&country=US&token=$TB_ADMIN_TOKEN"
```

Parameters:
- `start_date` (optional): Start date for analysis (format: YYYY-MM-DD HH:MM:SS)
- `end_date` (optional): End date for analysis (format: YYYY-MM-DD HH:MM:SS)
- `event_type` (optional): Filter by specific event type
- `country` (optional): Filter by country
- `device_type` (optional): Filter by device type

#### segment_customers

Gets all customers belonging to a specific segment with profile details.

```
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/segment_customers.json?segment_name=High%20Value%20Active&country=US&min_age=25&max_age=45&min_lifetime_value=500&token=$TB_ADMIN_TOKEN"
```

Parameters:
- `segment_name` (required): Name of the segment to retrieve customers from
- `country` (optional): Filter by country
- `min_age` (optional): Minimum age for filtering
- `max_age` (optional): Maximum age for filtering
- `min_lifetime_value` (optional): Minimum lifetime value for filtering
- `limit` (optional): Maximum number of results to return (default: 1000)

#### segment_metrics

Calculates key metrics for each customer segment including activity and value.

```
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/segment_metrics.json?country=US&token=$TB_ADMIN_TOKEN"
```

Parameters:
- `country` (optional): Filter metrics by country
