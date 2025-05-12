SELECT
    concat('TICKET-', toString(100000 + rand() % 900000)) AS ticket_id,
    concat('CUST-', toString(10000 + rand() % 90000)) AS customer_id,
    ['Billing', 'Technical', 'Account', 'Product', 'General'][rand() % 5 + 1] AS category,
    ['Login issues', 'Payment failed', 'How to upgrade', 'Feature request', 'Cannot access account', 'Error message', 'Setup help', 'Refund request', 'Account deletion', 'Password reset'][rand() % 10 + 1] AS subject,
    concat('Customer reported: ', ['I cannot log in to my account', 'My payment was declined', 'Need help setting up the product', 'Getting an error message', 'Having trouble with the mobile app', 'Need to update billing information', 'Product is not working as expected', 'Need help with feature configuration', 'Experiencing slow performance', 'Account security concerns'][rand() % 10 + 1]) AS description,
    ['Low', 'Medium', 'High', 'Critical'][rand() % 4 + 1] AS priority,
    ['Open', 'In Progress', 'Resolved', 'Closed', 'Pending'][rand() % 5 + 1] AS status,
    now() - toIntervalDay(rand() % 30) - toIntervalHour(rand() % 24) - toIntervalMinute(rand() % 60) AS created_at,
    now() - toIntervalDay(rand() % 15) - toIntervalHour(rand() % 12) - toIntervalMinute(rand() % 30) AS resolved_at,
    ['John Doe', 'Jane Smith', 'Robert Johnson', 'Sarah Williams', 'Michael Brown'][rand() % 5 + 1] AS assigned_to,
    30 + rand() % 1440 AS resolution_time_mins
FROM numbers(10)
