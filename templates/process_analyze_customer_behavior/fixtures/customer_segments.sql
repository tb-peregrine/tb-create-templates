SELECT
    concat('SEG_', toString(rand() % 1000)) AS segment_id,
    toString(arrayElement(['High Value', 'New Customers', 'At Risk', 'Loyal', 'Dormant', 'Seasonal', 'Discount Seekers', 'Premium Buyers', 'One-time Shoppers', 'Potential Loyalists'], rand() % 10 + 1)) AS segment_name,
    toString(arrayElement([
        'Customers with high lifetime value',
        'Customers who joined in the last 30 days',
        'Customers showing declining engagement',
        'Customers with regular purchases',
        'Customers inactive for over 90 days',
        'Customers who shop during specific seasons',
        'Customers who only buy during promotions',
        'Customers who purchase premium products',
        'Customers who made only one purchase',
        'Customers showing potential for loyalty program'
    ], rand() % 10 + 1)) AS segment_description,
    today() - toIntervalDay(rand() % 365) AS creation_date,
    today() - toIntervalDay(rand() % 30) AS update_date,
    toString(arrayElement([
        'total_spend > 1000 AND purchase_count > 10',
        'days_since_signup < 30',
        'days_since_last_purchase > 60 AND previous_purchase_frequency < 30',
        'purchase_frequency < 14 AND lifetime_orders > 5',
        'days_since_last_purchase > 90',
        'month(last_purchase_date) IN (11, 12) OR quarter(last_purchase_date) = 4',
        'discount_used_count / order_count > 0.8',
        'avg_order_value > 200',
        'order_count = 1 AND days_since_last_purchase > 60',
        'repeat_purchase_rate > 0.3 AND days_since_signup < 90'
    ], rand() % 10 + 1)) AS segment_rules,
    toString(arrayElement(['Behavioral', 'Value-based', 'Lifecycle', 'Demographic', 'RFM'], rand() % 5 + 1)) AS segment_type
FROM numbers(10)