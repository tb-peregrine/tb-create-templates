
## Tinybird

### Overview
This project implements a real-time product recommendation engine API. It stores user interactions with products and provides personalized product recommendations based on user behavior patterns.

### Data sources

#### user_interactions
Stores user interactions with products such as views, clicks, and purchases.

**Sample ingestion:**
```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=user_interactions" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
         "user_id": "user123",
         "product_id": "prod456",
         "interaction_type": "view",
         "timestamp": "2023-05-22 10:30:45",
         "session_id": "sess789",
         "value": 1.0
     }'
```

### Endpoints

#### user_based_recommendations
Generates product recommendations based on popularity and user interactions. It can exclude products already interacted with by a specific user if the user_id parameter is provided.

**Sample usage:**
```bash
# Get general recommendations
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_based_recommendations.json?token=$TB_ADMIN_TOKEN&limit=5"

# Get recommendations excluding products already interacted with by a specific user
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_based_recommendations.json?token=$TB_ADMIN_TOKEN&user_id=user123&limit=10"
```

Parameters:
- `user_id` (optional): Exclude products already interacted with by this user
- `limit` (optional, default: 10): Number of recommendations to return
