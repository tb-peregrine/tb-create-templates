# Customer Lifetime Value Analysis API

This project provides a robust API for tracking and analyzing customer lifetime value (CLV) metrics to help businesses understand customer behavior, retention, and revenue patterns.

## Tinybird

### Overview
This Tinybird project provides a comprehensive solution for analyzing customer lifetime value, segmenting customers based on their behavior, and predicting future value. It enables businesses to make data-driven decisions about customer acquisition, retention, and engagement strategies.

### Data Sources

#### Customers
Stores customer information including ID, name, signup date, and other attributes.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=customers" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{"customer_id":"c123","name":"John Doe","email":"john@example.com","signup_date":"2023-01-15 10:30:00","country":"USA","customer_segment":"Premium","acquisition_source":"Organic Search","active":1,"created_at":"2023-01-15 10:30:00"}'
```

#### Customer CLV
Aggregated customer lifetime value metrics.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=customer_clv" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{"customer_id":"c123","total_spend":500.25,"purchase_count":5,"first_purchase_date":"2023-01-16 14:20:00","last_purchase_date":"2023-06-20 09:15:00","customer_segment":"Premium","country":"USA","acquisition_source":"Organic Search","updated_at":"2023-06-20 09:15:00"}'
```

#### Purchases
Stores individual purchase transactions with associated customer and product information.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=purchases" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{"purchase_id":"p456","customer_id":"c123","product_id":"prod789","product_name":"Premium Subscription","product_category":"Subscription","purchase_amount":99.99,"purchase_date":"2023-01-16 14:20:00","payment_method":"Credit Card","currency":"USD","created_at":"2023-01-16 14:20:00"}'
```

### Endpoints

#### Customer Retention
Analyze customer retention rates over time, showing how many customers from each cohort are still making purchases in subsequent months.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/customer_retention.json?token=$TB_ADMIN_TOKEN&country=USA&customer_segment=Premium"
```

#### CLV by Segment
Analyze customer lifetime value metrics grouped by customer segments to identify the most valuable customer groups.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/clv_by_segment.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01 00:00:00&end_date=2023-12-31 23:59:59&country=USA"
```

#### Purchase Frequency Analysis
Analyze customer purchase frequency and recency patterns to understand buying behavior.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/purchase_frequency_analysis.json?token=$TB_ADMIN_TOKEN&customer_segment=Premium&country=USA"
```

#### CLV by Acquisition Source
Analyze customer lifetime value metrics grouped by acquisition source to optimize marketing efforts.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/clv_by_acquisition_source.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01 00:00:00&end_date=2023-12-31 23:59:59&customer_segment=Premium"
```

#### CLV Prediction
Predict future customer lifetime value based on historical data.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/clv_prediction.json?token=$TB_ADMIN_TOKEN&customer_segment=Premium&country=USA&limit=50"
```

#### Customer Segmentation
Segment customers based on RFM (Recency, Frequency, Monetary) analysis.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/customer_segmentation.json?token=$TB_ADMIN_TOKEN&country=USA&acquisition_source=Organic%20Search&limit=100"
```

#### Total Customer Value
Calculate the total lifetime value for each customer.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/total_customer_value.json?token=$TB_ADMIN_TOKEN&customer_id=c123&country=USA&customer_segment=Premium"
```
