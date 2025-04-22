
# Fraud Detection API

## Tinybird

### Overview
This API is designed to process and analyze payment transaction data with a focus on fraud detection. It provides endpoints for monitoring transaction patterns, detecting anomalies, assessing risk levels for both merchants and users, and identifying potential fraudulent activities through pattern matching and signal analysis.

### Data sources

#### payment_transactions
Payment transaction data containing detailed information for fraud analysis.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=payment_transactions" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "transaction_id": "tx_12345",
       "user_id": "user_789",
       "merchant_id": "merch_456",
       "amount": 199.99,
       "currency": "USD",
       "payment_method": "credit_card",
       "transaction_timestamp": "2023-05-15 10:30:00",
       "ip_address": "192.168.1.1",
       "device_id": "dev_abc123",
       "location": "New York",
       "status": "completed",
       "is_flagged": 0
     }'
```

#### fraud_signals
Dataset containing known fraud signals and patterns that are used to identify suspicious activities.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=fraud_signals" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "signal_id": "sig_123",
       "signal_type": "ip_blacklist",
       "ip_address": "198.51.100.123",
       "device_id": "dev_xyz789",
       "merchant_id": "merch_456",
       "risk_score": 0.85,
       "updated_at": "2023-05-10 08:15:00",
       "is_active": 1
     }'
```

#### transaction_patterns
Aggregated data about transaction patterns used by machine learning models for fraud detection.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=transaction_patterns" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "pattern_id": "pat_456",
       "pattern_type": "ip_based",
       "pattern_features": "multiple_countries_single_day",
       "confidence_score": 0.92,
       "is_fraud": 1,
       "created_at": "2023-04-20 14:30:00",
       "updated_at": "2023-05-01 09:45:00"
     }'
```

### Endpoints

#### transaction_details
Retrieve detailed information about transactions with flexible filtering options.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/transaction_details.json?token=$TB_ADMIN_TOKEN&user_id=user_789&start_date=2023-05-01%2000:00:00&end_date=2023-05-31%2023:59:59&limit=10"
```

#### transaction_summary
Provides aggregated statistics on payment transactions with options to group by different time periods and filter by various attributes.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/transaction_summary.json?token=$TB_ADMIN_TOKEN&group_by=day&start_date=2023-05-01%2000:00:00&end_date=2023-05-31%2023:59:59&include_merchant=1"
```

#### anomaly_detection
Identifies transactions that deviate significantly from a user's normal behavior patterns, using statistical analysis to flag potential fraud.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/anomaly_detection.json?token=$TB_ADMIN_TOKEN&anomaly_threshold=2.5&start_date=2023-05-01%2000:00:00&end_date=2023-05-31%2023:59:59"
```

#### merchant_risk_analysis
Evaluates merchants based on their transaction history and association with fraud signals to determine their risk level.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/merchant_risk_analysis.json?token=$TB_ADMIN_TOKEN&min_transactions=50&risk_level_filter=High&sort_by=risk"
```

#### user_risk_profile
Generates comprehensive risk profiles for users based on their transaction patterns, device usage, and connections to known fraud signals.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_risk_profile.json?token=$TB_ADMIN_TOKEN&min_transactions=5&risk_level_filter=Medium&sort_by=risk"
```

#### pattern_matching
Matches transactions against known fraud patterns to identify potential fraudulent activities with confidence scores.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/pattern_matching.json?token=$TB_ADMIN_TOKEN&start_date=2023-05-01%2000:00:00&end_date=2023-05-31%2023:59:59"
```

#### fraud_analysis
Combines transaction data with fraud signals to provide a comprehensive fraud risk assessment for each transaction.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/fraud_analysis.json?token=$TB_ADMIN_TOKEN&min_risk_score=0.5&risk_level=High&limit=20"
```
