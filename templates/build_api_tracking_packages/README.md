
# Package Tracking API

A simple API for tracking package delivery statuses across different carriers.

## Tinybird

### Overview

This project provides a real-time package tracking API built on Tinybird. It enables tracking of package delivery events across different carriers, providing current status information, full delivery history, and carrier performance analytics.

### Data Sources

#### package_events

This datasource stores all package delivery events with status updates from various carriers. Each event includes details about the package, its current status, location, and who updated the information.

**Sample Ingestion:**

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=package_events" \
    -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
    -d '{
        "package_id": "PKG12345678", 
        "event_timestamp": "2023-11-23 14:30:00", 
        "status": "in_transit", 
        "location": "Chicago Distribution Center", 
        "carrier": "UPS", 
        "notes": "Package processed at sorting facility", 
        "updated_by": "system"
    }'
```

### Endpoints

#### package_status

Get the current status of a package by its ID. Returns the most recent status, location, and timestamp.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/package_status.json?token=$TB_ADMIN_TOKEN&package_id=PKG12345678"
```

#### package_history

Retrieve the full history of a package's status updates in chronological order, showing how the package has progressed through the delivery process.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/package_history.json?token=$TB_ADMIN_TOKEN&package_id=PKG12345678"
```

#### carrier_status_summary

Get a summary of package delivery statuses grouped by carrier, providing insights on carrier performance and distribution of package statuses.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/carrier_status_summary.json?token=$TB_ADMIN_TOKEN"
```

To filter by a specific carrier:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/carrier_status_summary.json?token=$TB_ADMIN_TOKEN&carrier=UPS"
```
