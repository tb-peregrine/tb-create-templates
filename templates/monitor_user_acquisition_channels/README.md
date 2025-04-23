# Marketing ROI Analysis API

This project helps marketing teams analyze user acquisition channels, track ROI metrics, and optimize campaign performance.

## Tinybird

### Overview

This Tinybird project provides a comprehensive marketing analytics API for analyzing user acquisition channels, campaign performance, and ROI metrics. It connects user acquisition data with conversion events to help marketing teams make data-driven decisions about their marketing spend and channel effectiveness.

### Data sources

#### user_acquisitions

Stores user acquisition data from different channels with cost information.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=user_acquisitions" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{"user_id":"u123","channel":"facebook","campaign":"summer_promo","acquisition_date":"2023-01-15 08:30:00","cost":5.75,"country":"US"}'
```

#### user_conversions

Stores user conversion events with revenue information.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=user_conversions" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{"user_id":"u123","conversion_date":"2023-01-18 15:45:00","conversion_type":"purchase","revenue":125.50,"country":"US"}'
```

### Endpoints

#### time_to_conversion

Analyzes the average, median, minimum, and maximum time from acquisition to conversion by channel and campaign.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/time_to_conversion.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&channel=facebook&campaign=summer_promo"
```

Parameters:
- `start_date` (DateTime, default: '2023-01-01 00:00:00')
- `end_date` (DateTime, default: '2023-12-31 23:59:59')
- `channel` (String, optional, default: 'facebook')
- `campaign` (String, optional, default: 'summer_promo')
- `country` (String, optional, default: 'US')

#### campaign_comparison

Compares campaign performance across different channels with comprehensive ROI metrics.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/campaign_comparison.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&channels=facebook,google,twitter&min_users=10"
```

Parameters:
- `start_date` (DateTime, default: '2023-01-01 00:00:00')
- `end_date` (DateTime, default: '2023-12-31 23:59:59')
- `channels` (String, optional, default: 'facebook,google,twitter')
- `min_users` (Int, default: 10)

#### daily_channel_metrics

Tracks daily performance metrics for acquisition channels to monitor trends over time.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/daily_channel_metrics.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&channel=facebook&country=US"
```

Parameters:
- `start_date` (DateTime, default: '2023-01-01 00:00:00')
- `end_date` (DateTime, default: '2023-12-31 23:59:59')
- `channel` (String, optional, default: 'facebook')
- `country` (String, optional, default: 'US')

#### country_channel_effectiveness

Analyzes channel effectiveness by country with ROI and conversion metrics for geographic optimization.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/country_channel_effectiveness.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&channel=facebook&countries=US,UK,CA"
```

Parameters:
- `start_date` (DateTime, default: '2023-01-01 00:00:00')
- `end_date` (DateTime, default: '2023-12-31 23:59:59')
- `channel` (String, optional, default: 'facebook')
- `countries` (String, optional, default: 'US,UK,CA')

#### channel_performance

Provides detailed channel performance analysis with acquisition costs and revenue metrics.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/channel_performance.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&channel=facebook&campaign=summer_promo&country=US"
```

Parameters:
- `start_date` (DateTime, default: '2023-01-01 00:00:00')
- `end_date` (DateTime, default: '2023-12-31 23:59:59')
- `channel` (String, optional, default: 'facebook')
- `campaign` (String, optional, default: 'summer_promo')
- `country` (String, optional, default: 'US')
