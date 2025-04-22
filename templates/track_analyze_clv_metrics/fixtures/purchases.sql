SELECT
    concat('pur_', toString(rand() % 100000)) AS purchase_id,
    concat('cust_', toString(rand() % 5000)) AS customer_id,
    concat('prod_', toString(rand() % 10000)) AS product_id,
    arrayElement(['Laptop', 'Smartphone', 'Headphones', 'Monitor', 'Keyboard', 'Mouse', 'Tablet', 'Camera', 'Printer', 'Speaker'], rand() % 10 + 1) AS product_name,
    arrayElement(['Electronics', 'Clothing', 'Home & Kitchen', 'Books', 'Sports', 'Beauty', 'Toys', 'Grocery', 'Furniture', 'Automotive'], rand() % 10 + 1) AS product_category,
    round(10 + rand() % 990 + rand(), 2) AS purchase_amount,
    now() - toIntervalDay(rand() % 365) - toIntervalHour(rand() % 24) AS purchase_date,
    arrayElement(['Credit Card', 'Debit Card', 'PayPal', 'Bank Transfer', 'Cash', 'Gift Card', 'Crypto'], rand() % 7 + 1) AS payment_method,
    arrayElement(['USD', 'EUR', 'GBP', 'JPY', 'CAD', 'AUD', 'CNY'], rand() % 7 + 1) AS currency,
    now() - toIntervalDay(rand() % 365) - toIntervalHour(rand() % 24) AS created_at
FROM numbers(10)