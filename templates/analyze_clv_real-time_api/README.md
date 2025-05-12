
# Customer Lifetime Value Analytics API

Real-time API for analyzing customer lifetime value (CLTV) and demographic insights.

## Tinybird

### Overview

This Tinybird project provides real-time analysis of customer lifetime value (CLTV) based on transaction data and customer demographics. The API allows querying of average CLTV across all customers, CLTV for specific customers, and CLTV analysis by location.

### Data Sources

#### customer_demographics

Contains customer demographic information including customer ID, age, and location.

**Example data ingestion:**
```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=customer_demographics" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{"customer_id":"cust123","age":35,"location":"New York"}'
```

#### customer_transactions

Contains customer transaction data including customer ID, transaction date, and transaction amount.

**Example data ingestion:**
```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=customer_transactions" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{"customer_id":"cust123","transaction_date":"2023-01-15 14:30:00","transaction_amount":125.50}'
```

### Endpoints

#### cltv_summary

Calculates the average customer lifetime value across all customers.

**Example usage:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/cltv_summary.json?token=$TB_ADMIN_TOKEN"
```

#### customer_cltv

Retrieves the lifetime value for a specific customer by ID.

**Example usage:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/customer_cltv.json?customer_id=cust123&token=$TB_ADMIN_TOKEN"
```

#### cltv_by_location

Calculates the average customer lifetime value segmented by location.

**Example usage:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/cltv_by_location.json?token=$TB_ADMIN_TOKEN"
```
