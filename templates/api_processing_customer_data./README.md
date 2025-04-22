# NPS and Customer Satisfaction Analysis

This project provides a comprehensive analysis of customer satisfaction survey responses with a focus on Net Promoter Score (NPS) tracking and feedback analysis.

## Tinybird

### Overview

This Tinybird project processes and analyzes customer satisfaction survey data, providing valuable insights into Net Promoter Score (NPS) metrics, customer feedback, and satisfaction trends. The API endpoints built on this data allow for real-time monitoring of customer satisfaction across different segments, products, and time periods.

### Data Sources

#### survey_responses

Raw customer satisfaction survey responses, including NPS scores and feedback. This datasource stores all customer survey data with details on the customer, their feedback, and survey metadata.

**Sample Ingestion:**

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=survey_responses" \
  -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
  -d '{
    "response_id": "resp_12345",
    "customer_id": "cust_6789",
    "timestamp": "2023-06-15 14:30:00",
    "nps_score": 9,
    "feedback": "Love the product, very easy to use!",
    "channel": "email",
    "product_type": "software",
    "customer_tenure_days": 156,
    "customer_segment": "enterprise"
  }'
```

### Endpoints

#### feedback_analysis

Provides a sample of customer feedback comments grouped by NPS category (Detractor, Passive, Promoter) for qualitative analysis.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/feedback_analysis.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&product_type=software&channel=email&nps_category=Promoter&limit=50"
```

#### nps_score_distribution

Analyzes the distribution of NPS scores by category to visualize the breakdown of detractors, passives, and promoters.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/nps_score_distribution.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&product_type=software&channel=email"
```

#### customer_tenure_analysis

Analyzes NPS scores based on customer tenure to identify correlation between satisfaction and relationship length.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/customer_tenure_analysis.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&product_type=software&channel=email"
```

#### nps_summary

Provides an overall NPS summary with key metrics (promoters, passives, detractors, NPS value) for the selected time period.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/nps_summary.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&product_type=software&channel=email"
```

#### nps_score_trend

Shows the trend of NPS scores over time with daily or monthly granularity to track changes in customer satisfaction.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/nps_score_trend.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&product_type=software&channel=email&granularity=monthly"
```

#### nps_by_segment

Analyze NPS scores by customer segment, showing distribution and overall NPS value to identify segments with highest and lowest satisfaction.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/nps_by_segment.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&product_type=software&channel=email"
```

#### nps_by_product

Compare NPS scores across different product types to identify which products have higher customer satisfaction.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/nps_by_product.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&channel=email"
```
