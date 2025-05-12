
# Real-time Auction Bidding API

## Tinybird

### Overview
This project provides a real-time API for processing and analyzing auction bidding data. It allows users to track bids across multiple auctions, monitor bidder activity, and retrieve auction statistics in real-time.

### Data Sources

#### auction_bids
Stores real-time auction bidding data including bid amount, auction ID, bidder ID, and timestamp.

**Sample data ingestion:**
```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=auction_bids" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
           "bid_id": "bid_12345",
           "auction_id": "auction_789",
           "bidder_id": "user_456",
           "bid_amount": 150.75,
           "timestamp": "2023-04-15 14:30:45",
           "status": "active",
           "item_id": "item_101"
         }'
```

### Endpoints

#### recent_bids
Returns recent bids for a specific auction or all auctions, with optional pagination.

**Parameters:**
- `auction_id` (optional): Filter by specific auction
- `status` (optional): Filter by bid status (default: 'active')
- `limit` (optional): Number of results to return (default: 100)
- `offset` (optional): Results offset for pagination (default: 0)

**Example:**
```bash
# Get recent bids for a specific auction
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/recent_bids.json?auction_id=auction_789&token=$TB_ADMIN_TOKEN"

# Get all recent bids with pagination
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/recent_bids.json?limit=50&offset=50&token=$TB_ADMIN_TOKEN"
```

#### auction_summary
Returns summary statistics for a specific auction including highest bid, total bids, and unique bidders.

**Parameters:**
- `auction_id` (required): Auction ID to summarize
- `status` (optional): Filter by bid status (default: 'active')

**Example:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/auction_summary.json?auction_id=auction_789&token=$TB_ADMIN_TOKEN"
```

#### bidder_activity
Returns bidding activity for a specific bidder across all auctions or for a specific auction.

**Parameters:**
- `bidder_id` (required): Bidder ID to analyze
- `auction_id` (optional): Filter by specific auction
- `status` (optional): Filter by bid status (default: 'active')

**Example:**
```bash
# Get all activity for a specific bidder
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/bidder_activity.json?bidder_id=user_456&token=$TB_ADMIN_TOKEN"

# Get bidder activity for a specific auction
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/bidder_activity.json?bidder_id=user_456&auction_id=auction_789&token=$TB_ADMIN_TOKEN"
```
