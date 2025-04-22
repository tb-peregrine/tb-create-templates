SELECT
    concat('test_', toString(rand() % 1000)) AS test_id,
    arrayElement(['Homepage Redesign', 'Checkout Flow Optimization', 'Product Recommendation Algorithm', 'Pricing Strategy', 'Email Subject Line Test', 'Call-to-Action Button Color', 'Landing Page Layout', 'Mobile App Onboarding', 'Search Results Ranking', 'Notification Frequency'], rand() % 10 + 1) AS test_name,
    arrayElement(['Testing a new homepage design to improve conversion rate', 'Optimizing checkout flow to reduce cart abandonment', 'Comparing recommendation algorithms for higher engagement', 'Testing different price points for subscription plans', 'Evaluating email subject lines for better open rates', 'Testing different button colors for higher click-through rates', 'Comparing different landing page layouts', 'Testing new onboarding flow to improve retention', 'Evaluating new search ranking algorithm', 'Testing different notification frequencies'], rand() % 10 + 1) AS description,
    now() - toIntervalDay(rand() % 60) AS start_date,
    now() + toIntervalDay(rand() % 90) AS end_date,
    arrayElement(['{"control": 50, "variant_a": 50}', '{"control": 33, "variant_a": 33, "variant_b": 34}', '{"control": 25, "variant_a": 25, "variant_b": 25, "variant_c": 25}', '{"control": 40, "variant_a": 60}', '{"control": 20, "variant_a": 40, "variant_b": 40}'], rand() % 5 + 1) AS variants,
    arrayElement(['conversion_rate', 'click_through_rate', 'revenue_per_user', 'average_order_value', 'retention_rate', 'bounce_rate', 'time_on_page', 'add_to_cart_rate', 'completion_rate', 'engagement_score'], rand() % 10 + 1) AS primary_metric,
    arrayElement(['["bounce_rate", "time_on_page"]', '["revenue_per_user", "conversion_rate"]', '["click_through_rate", "engagement_score"]', '["retention_rate", "average_order_value"]', '["completion_rate", "bounce_rate"]'], rand() % 5 + 1) AS secondary_metrics,
    now() - toIntervalDay(rand() % 120) AS created_at,
    now() - toIntervalDay(rand() % 30) AS updated_at,
    arrayElement(['draft', 'running', 'completed', 'paused', 'archived'], rand() % 5 + 1) AS status
FROM numbers(10)