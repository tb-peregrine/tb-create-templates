# Referral Analytics API

This project provides a comprehensive analytics solution for tracking and analyzing user referral programs, helping you understand referral performance, identify top referrers, and measure viral growth.

## Tinybird

### Overview

This Tinybird project provides a comprehensive analytics system for tracking and analyzing user referral programs. It enables businesses to monitor referral performance, identify top referrers, calculate viral coefficients, and understand the impact of referrals on user lifetime value.

### Data Sources

#### Users

Stores user information including referral status and acquisition data.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=users" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "user_id": "u12345",
       "email": "user@example.com",
       "signup_date": "2023-05-15 10:30:45",
       "acquisition_source": "google",
       "referral_code": "REF123",
       "referred_by": "u54321",
       "lifetime_value": 125.50,
       "active": 1,
       "country": "US",
       "referrals_sent": 5,
       "referrals_converted": 2
     }'
```

#### Referrals

Tracks user referrals with details about referrer, new user, and timestamps.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=referrals" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "referral_id": "ref123",
       "referrer_id": "u54321",
       "new_user_id": "u12345",
       "referral_code": "REF123",
       "referral_channel": "email",
       "referral_date": "2023-05-10 14:22:30",
       "converted": 1,
       "conversion_date": "2023-05-15 10:30:45",
       "reward_given": 1,
       "reward_type": "credit",
       "reward_amount": 10.00
     }'
```

#### User Activity

Tracks user activity events for referral program analysis.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=user_activity" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "event_id": "evt789",
       "user_id": "u12345",
       "event_type": "referral_invite_sent",
       "event_date": "2023-05-09 16:45:20",
       "referral_related": 1,
       "referral_id": "ref123",
       "platform": "web",
       "device": "desktop",
       "country": "US",
       "session_id": "sess456"
     }'
```

### Endpoints

#### Referral Performance

Analyzes referral performance by channel, time period, and conversion rates.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/referral_performance.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&channel=email"
```

#### Top Referrers

Identifies top referrers based on number of successful referrals and conversion rate.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/top_referrers.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&country=US&min_referrals=5&limit=50"
```

#### Referral LTV Analysis

Compares Lifetime Value (LTV) between referred and non-referred users.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/referral_ltv_analysis.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&country=US"
```

#### Viral Coefficient

Calculates the viral coefficient (K-factor) over a given time period.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/viral_coefficient.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59"
```

#### Referral Funnel

Analyzes the referral program funnel from invitation to conversion.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/referral_funnel.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59"
```

#### Referral Cohort Analysis

Analyzes cohorts of referred users vs. non-referred users.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/referral_cohort_analysis.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59"
```
