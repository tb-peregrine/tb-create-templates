
# Inventory Tracking API

This project provides a real-time inventory tracking system API using Tinybird, enabling businesses to monitor stock levels, track inventory movements, and get insights into their inventory data.

## Tinybird

### Overview

This Tinybird project implements a real-time inventory tracking system that allows you to:
- Track inventory items with their current stock levels
- Record all inventory transactions (additions, removals, adjustments)
- Get detailed information about specific items
- View inventory summaries by category and location
- Identify low stock items that need replenishment

### Data Sources

#### inventory_items

Stores inventory items with their current stock levels and other details including item information, location, pricing, and stock thresholds.

Example data ingestion:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=inventory_items" \
  -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
  -d '{
    "item_id": "ITM001",
    "item_name": "Widget A",
    "category": "Widgets",
    "quantity": 120,
    "location": "Warehouse 1",
    "last_updated": "2023-10-15 14:30:00",
    "low_stock_threshold": 50,
    "unit_price": 29.99
  }'
```

#### inventory_transactions

Tracks all inventory transactions (additions, removals, adjustments) with transaction details, quantities, and user information.

Example data ingestion:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=inventory_transactions" \
  -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
  -d '{
    "transaction_id": "TRX123456",
    "item_id": "ITM001",
    "transaction_type": "addition",
    "quantity": 25,
    "timestamp": "2023-10-16 09:45:00",
    "location": "Warehouse 1",
    "user_id": "user_123",
    "notes": "Regular stock replenishment"
  }'
```

### Endpoints

#### get_inventory_items

API endpoint to retrieve inventory items with optional filtering by category, location, and low stock status.

Example usage:

```bash
# Get all inventory items (default limit 100)
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_inventory_items.json?token=$TB_ADMIN_TOKEN"

# Get items in a specific category
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_inventory_items.json?token=$TB_ADMIN_TOKEN&category=Widgets"

# Get low stock items in a specific location
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_inventory_items.json?token=$TB_ADMIN_TOKEN&location=Warehouse%201&low_stock_only=1"

# Get items sorted by quantity with custom limit
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_inventory_items.json?token=$TB_ADMIN_TOKEN&sort_by=quantity&limit=50"
```

#### get_item_details

API endpoint to get detailed information about a specific inventory item, including recent transactions.

Example usage:

```bash
# Get details for a specific item with default transaction limit (10)
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_item_details.json?token=$TB_ADMIN_TOKEN&item_id=ITM001"

# Get details with more transaction history
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_item_details.json?token=$TB_ADMIN_TOKEN&item_id=ITM001&transaction_limit=25"
```

#### get_inventory_summary

API endpoint to get summarized inventory statistics by category and location, including total items, quantities, values, and low stock items.

Example usage:

```bash
# Get summary of all inventory
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_inventory_summary.json?token=$TB_ADMIN_TOKEN"

# Get summary for a specific category
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_inventory_summary.json?token=$TB_ADMIN_TOKEN&category=Widgets"

# Get summary with minimum total value
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_inventory_summary.json?token=$TB_ADMIN_TOKEN&min_value=5000"

# Get summary sorted by total items
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_inventory_summary.json?token=$TB_ADMIN_TOKEN&sort_by=total_items"
```
