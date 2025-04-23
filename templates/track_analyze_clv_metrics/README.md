# Customer Lifetime Value Analytics API

This project implements a real-time analytics API to track and analyze customer lifetime value metrics.

## Tinybird

### Overview

The Customer Lifetime Value Analytics API leverages Tinybird's real-time data processing capabilities to analyze customer behavior, calculate lifetime value metrics, and provide insights into customer retention, segmentation, and forecasting. This enables businesses to make data-driven decisions about customer acquisition, retention strategies, and targeted marketing efforts.

### Data Sources

The API is built on three main data sources:

#### 1. Customers

Stores customer information including their ID, registration date, and other demographic data.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=customers" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "customer_id": "cust_123456",
       "registration_date": "2023-01-15 10:30:00",
       "country": "US",
       "city": "New York",
       "age": 35,
       "gender": "F",
       "acquisition_source": "organic_search",
       "segment": "premium",
       "is_active": 1
     }'
```

#### 2. Transactions

Stores all customer transactions including amount, date, product category, and transaction type.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=transactions" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "transaction_id": "tx_789012",
       "customer_id": "cust_123456",
       "transaction_date": "2023-02-20 14:25:00",
       "amount": 89.99,
       "product_category": "electronics",
       "transaction_type": "purchase",
       "payment_method": "credit_card",
       "is_refund": 0
     }'
```

#### 3. Customer Interactions

Stores customer interaction events such as logins, support contacts, and feature usage.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=customer_interactions" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "interaction_id": "int_456789",
       "customer_id": "cust_123456",
       "interaction_date": "2023-03-05 09:15:00",
       "interaction_type": "login",
       "channel": "mobile_app",
       "duration_seconds": 240,
       "satisfaction_score": 5
     }'
```

### Endpoints

The API provides several analytics endpoints to extract valuable insights from customer data:

#### 1. Customer LTV

Calculates the customer lifetime value (LTV) based on their transaction history.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/customer_ltv.json?start_date=2020-01-01%2000:00:00&country=US&is_active=1&token=$TB_ADMIN_TOKEN"
```

Parameters:
- `start_date`: Filter by registration date (YYYY-MM-DD HH:MM:SS)
- `end_date`: Filter by registration date (YYYY-MM-DD HH:MM:SS)
- `country`: Filter by country code
- `segment`: Filter by customer segment
- `is_active`: Filter by active status (1 or 0)

#### 2. LTV by Cohort

Analyzes customer lifetime value by cohort (month of registration).

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/ltv_by_cohort.json?start_date=2020-01-01%2000:00:00&country=US&segment=premium&token=$TB_ADMIN_TOKEN"
```

Parameters:
- `start_date`: Filter by registration date (YYYY-MM-DD HH:MM:SS)
- `end_date`: Filter by registration date (YYYY-MM-DD HH:MM:SS)
- `country`: Filter by country code
- `acquisition_source`: Filter by acquisition source
- `segment`: Filter by customer segment

#### 3. LTV Influencing Factors

Analyzes factors that influence customer lifetime value.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/ltv_influencing_factors.json?segment=premium&country=US&min_customers=10&token=$TB_ADMIN_TOKEN"
```

Parameters:
- `start_date`: Filter by registration date (YYYY-MM-DD HH:MM:SS)
- `end_date`: Filter by registration date (YYYY-MM-DD HH:MM:SS)
- `segment`: Filter by customer segment
- `acquisition_source`: Filter by acquisition source
- `country`: Filter by country code
- `min_customers`: Minimum number of customers to include in analysis

#### 4. Customer Retention Analysis

Analyzes customer retention rates by cohort over time.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/customer_retention_analysis.json?start_date=2020-01-01%2000:00:00&country=US&segment=premium&token=$TB_ADMIN_TOKEN"
```

Parameters:
- `start_date`: Filter by registration date (YYYY-MM-DD HH:MM:SS)
- `end_date`: Filter by registration date (YYYY-MM-DD HH:MM:SS)
- `segment`: Filter by customer segment
- `country`: Filter by country code

#### 5. LTV Forecast

Forecasts future LTV based on historical customer spending patterns and tenure.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/ltv_forecast.json?segment=premium&country=US&min_transactions=3&min_ltv=50&limit=100&token=$TB_ADMIN_TOKEN"
```

Parameters:
- `segment`: Filter by customer segment
- `country`: Filter by country code
- `min_transactions`: Minimum number of transactions
- `min_ltv`: Minimum current LTV
- `limit`: Maximum number of results

#### 6. Customer Segmentation

Segments customers based on RFM (Recency, Frequency, Monetary) analysis.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/customer_segmentation.json?start_date=2020-01-01%2000:00:00&country=US&min_frequency=2&min_monetary=100&segment_filter=Champions&limit=100&token=$TB_ADMIN_TOKEN"
```

Parameters:
- `start_date`: Filter by transaction date (YYYY-MM-DD HH:MM:SS)
- `end_date`: Filter by transaction date (YYYY-MM-DD HH:MM:SS)
- `country`: Filter by country code
- `min_frequency`: Minimum purchase frequency
- `min_monetary`: Minimum monetary value
- `segment_filter`: Filter by RFM segment
- `limit`: Maximum number of results
