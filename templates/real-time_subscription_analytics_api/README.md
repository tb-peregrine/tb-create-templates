# Subscription Analytics with Tinybird

## Overview

This project provides a real-time API for analyzing subscription data. It tracks subscription events and current subscription statuses, allowing you to gain insights into user behavior, revenue trends, and churn.

## Data sources

### `subscriptions`

This data source stores the current status and details of each user subscription.

**Schema:**

*   `subscription_id` (String): Unique identifier for the subscription.
*   `user_id` (String): Unique identifier for the user.
*   `plan_id` (String): Identifier for the subscription plan.
*   `plan_name` (String): Name of the subscription plan.
*   `status` (String): Current status of the subscription (e.g., "active", "cancelled", "trialing").
*   `amount` (Float64): Subscription amount.
*   `currency` (String): Currency of the subscription amount.
*   `billing_period` (String): Billing frequency (e.g., "monthly", "yearly").
*   `start_date` (DateTime): Subscription start date.
*   `end_date` (DateTime): Subscription end date.
*   `trial_end_date` (DateTime): Trial period end date (if applicable).
*   `cancel_at_period_end` (UInt8): Flag indicating whether the subscription will be canceled at the end of the current period (1 for true, 0 for false).
*   `created_at` (DateTime): Timestamp of when the subscription was created.
*   `updated_at` (DateTime): Timestamp of the last update to the subscription.

**Ingestion Example:**

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=subscriptions" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{"subscription_id":"sub_123","user_id":"user_456","plan_id":"plan_A","plan_name":"Basic Plan","status":"active","amount":9.99,"currency":"USD","billing_period":"monthly","start_date":"2024-01-01 00:00:00","end_date":"2025-01-01 00:00:00","trial_end_date":"2024-01-15 00:00:00","cancel_at_period_end":0,"created_at":"2024-01-01 00:00:00","updated_at":"2024-01-01 00:00:00"}'
```

### `subscription_events`

This data source stores events related to subscriptions, such as creations, cancellations, renewals, and upgrades.

**Schema:**

*   `event_id` (String): Unique identifier for the event.
*   `user_id` (String): Unique identifier for the user.
*   `subscription_id` (String): Identifier for the subscription.
*   `event_type` (String): Type of event (e.g., "created", "cancelled", "renewal", "upgrade").
*   `plan_id` (String): Identifier for the plan associated with the event.
*   `plan_name` (String): Name of the plan associated with the event.
*   `amount` (Float64): Amount related to the event (e.g., renewal amount).
*   `currency` (String): Currency of the amount.
*   `billing_period` (String): Billing frequency.
*   `timestamp` (DateTime): Timestamp of when the event occurred.
*   `metadata` (String): Additional information about the event (JSON format).

**Ingestion Example:**

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=subscription_events" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{"event_id":"event_789","user_id":"user_456","subscription_id":"sub_123","event_type":"created","plan_id":"plan_A","plan_name":"Basic Plan","amount":9.99,"currency":"USD","billing_period":"monthly","timestamp":"2024-01-01 00:00:00","metadata":"{}"}'
```

## Endpoints

### `user_subscription_history`

Retrieves the subscription history for a specific user, optionally filtered by subscription ID and date range.

**Parameters:**

*   `user_id` (String, required): The ID of the user.
*   `subscription_id` (String, optional): The ID of the subscription.
*   `start_date` (DateTime, optional): Start date for filtering events (YYYY-MM-DD HH:MM:SS).
*   `end_date` (DateTime, optional): End date for filtering events (YYYY-MM-DD HH:MM:SS).

**Usage Example:**

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_subscription_history.json?token=$TB_ADMIN_TOKEN&user_id=user_456&start_date=2024-01-01 00:00:00&end_date=2024-01-31 23:59:59"
```

### `active_subscriptions`

Returns aggregated data about active subscriptions, optionally filtered by plan and date range.

**Parameters:**

*   `plan_id` (String, optional): Filter by a specific plan ID.
*   `start_date` (DateTime, optional): Consider subscriptions started on or after this date (YYYY-MM-DD HH:MM:SS).
*   `end_date` (DateTime, optional): Consider subscriptions started on or before this date (YYYY-MM-DD HH:MM:SS).

**Usage Example:**

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/active_subscriptions.json?token=$TB_ADMIN_TOKEN&plan_id=plan_A&start_date=2024-01-01 00:00:00&end_date=2024-01-31 23:59:59"
```

### `subscription_metrics`

Provides key subscription metrics including MRR, churn rate, and subscriber count by time period.

**Parameters:**

*   `start_date` (DateTime, optional): Start date for calculating metrics (YYYY-MM-DD HH:MM:SS).
*   `end_date` (DateTime, optional): End date for calculating metrics (YYYY-MM-DD HH:MM:SS).

**Usage Example:**

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/subscription_metrics.json?token=$TB_ADMIN_TOKEN&start_date=2024-01-01 00:00:00&end_date=2024-01-31 23:59:59"
```
