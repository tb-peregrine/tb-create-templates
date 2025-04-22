SELECT
    concat('camp_', toString(rand() % 10000)) AS campaign_id,
    arrayElement(['Welcome Series', 'Product Update', 'Monthly Newsletter', 'Promotional Offer', 'Event Invitation', 'Customer Feedback', 'Holiday Special', 'Abandoned Cart', 'New Feature Announcement', 'Seasonal Campaign'], rand() % 10 + 1) AS campaign_name,
    arrayElement(['Onboarding email sequence for new users', 'Updates about our latest product features', 'Monthly roundup of company news and updates', 'Special discount for loyal customers', 'Invitation to our annual conference', 'Survey to collect customer feedback', 'Special offers for the holiday season', 'Reminder about items left in cart', 'Announcing our exciting new features', 'Summer sale campaign'], rand() % 10 + 1) AS campaign_description,
    now() - toIntervalDay(rand() % 60) AS created_at,
    now() - toIntervalDay(rand() % 30) AS updated_at,
    arrayElement(['draft', 'scheduled', 'sending', 'sent', 'paused', 'cancelled'], rand() % 6 + 1) AS status,
    arrayElement(['marketing@example.com', 'newsletter@example.com', 'updates@example.com', 'contact@example.com', 'support@example.com'], rand() % 5 + 1) AS sender_email,
    arrayElement(['Marketing Team', 'Newsletter Team', 'Product Team', 'Customer Support', 'Sales Team'], rand() % 5 + 1) AS sender_name,
    arrayElement(['Check out our latest products', 'Your monthly newsletter is here', 'Exclusive offer just for you', 'Important updates from our team', 'We miss you - come back and save', 'Invitation to our upcoming event', 'Your feedback matters to us', 'Holiday specials inside', 'New features you\'ll love', 'Limited time offer'], rand() % 10 + 1) AS subject,
    concat('tmpl_', toString(rand() % 1000)) AS template_id
FROM numbers(10)