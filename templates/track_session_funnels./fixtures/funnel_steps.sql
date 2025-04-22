SELECT
    concat('funnel_', toString(1 + rand() % 5)) AS funnel_id,
    ['Signup Flow', 'Purchase Flow', 'Onboarding Flow', 'Content Creation Flow', 'Subscription Flow'][1 + rand() % 5] AS funnel_name,
    toUInt8(1 + number % 5) AS step_number,
    CASE toUInt8(1 + number % 5)
        WHEN 1 THEN 'Visit Landing Page'
        WHEN 2 THEN 'View Details'
        WHEN 3 THEN 'Add to Cart'
        WHEN 4 THEN 'Checkout'
        WHEN 5 THEN 'Complete Purchase'
    END AS step_name,
    CASE toUInt8(1 + number % 5)
        WHEN 1 THEN 'page_view'
        WHEN 2 THEN 'product_view'
        WHEN 3 THEN 'add_to_cart'
        WHEN 4 THEN 'checkout_start'
        WHEN 5 THEN 'purchase_complete'
    END AS event_name,
    toUInt8(rand() % 2) AS is_required
FROM numbers(10)