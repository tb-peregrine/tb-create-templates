# Tinybird Inventory Management System

## Tinybird

### Overview
The Inventory Management System provides a real-time API to track inventory items, monitor stock levels, and record inventory transactions. It helps businesses manage their inventory efficiently by providing real-time insights into stock levels, low stock alerts, and inventory transaction history.

### Data Sources

#### inventory_items
This datasource stores inventory items with their current stock levels and other details including pricing, supplier information, and warehouse location.

**Sample ingestion:**
```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=inventory_items" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
         "item_id": "ITM001",
         "item_name": "Wireless Headphones",
         "category": "Electronics",
         "current_stock": 45,
         "min_stock_level": 10,
         "max_stock_level": 100,
         "unit_price": 49.99,
         "supplier_id": "SUP123",
         "warehouse_id": "WH001",
         "last_updated": "2023-06-15 14:30:00"
     }'
```

#### inventory_transactions
This datasource tracks all inventory movements, including stock additions (purchases), removals (sales), transfers, and adjustments. Each transaction is linked to a specific item and warehouse.

**Sample ingestion:**
```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=inventory_transactions" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
         "transaction_id": "TRX001",
         "item_id": "ITM001",
         "warehouse_id": "WH001",
         "transaction_type": "addition",
         "quantity": 20,
         "transaction_date": "2023-06-15 14:30:00",
         "user_id": "USR456",
         "reference_id": "PO789",
         "notes": "Restocking purchase order"
     }'
```

### Endpoints

#### get_inventory_items
This endpoint retrieves a list of inventory items with optional filtering by category, warehouse, and low stock status. It also supports sorting and pagination.

**Sample usage:**
```bash
# Get all inventory items
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_inventory_items.json?token=$TB_ADMIN_TOKEN"

# Get low stock items from a specific warehouse
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_inventory_items.json?token=$TB_ADMIN_TOKEN&warehouse_id=WH001&low_stock_only=1"

# Get items in a specific category, sorted by current stock
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_inventory_items.json?token=$TB_ADMIN_TOKEN&category=Electronics&sort_by=current_stock&sort_desc=1&limit=50"
```

#### get_inventory_details
This endpoint provides detailed information about a specific inventory item including its recent transaction history (last 30 days).

**Sample usage:**
```bash
# Get details for a specific item
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_inventory_details.json?token=$TB_ADMIN_TOKEN&item_id=ITM001"

# Get details for a specific item in a specific warehouse
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_inventory_details.json?token=$TB_ADMIN_TOKEN&item_id=ITM001&warehouse_id=WH001"
```

#### get_inventory_summary
This endpoint provides summary statistics aggregated by warehouse and category, including total items, stock levels, and inventory value.

**Sample usage:**
```bash
# Get overall inventory summary
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_inventory_summary.json?token=$TB_ADMIN_TOKEN"

# Get inventory summary for a specific warehouse
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_inventory_summary.json?token=$TB_ADMIN_TOKEN&warehouse_id=WH001"

# Get inventory summary for a specific category, sorted by low stock items
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_inventory_summary.json?token=$TB_ADMIN_TOKEN&category=Electronics&sort_by=low_stock_items&sort_desc=1"
```