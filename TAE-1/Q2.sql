USE retail_analytics;

-- ====================================================================
-- Q2a: Basic Filtering & Ordering (Easy)
-- ====================================================================
-- Write a MySQL query to retrieve the full_name, email, city, and preferred_channel of all 
-- customers residing in either 'California' or 'Texas' who registered after January 1st, 2023. 
-- Sort the results alphabetically by full_name.

SELECT 
    full_name,
    email,
    city,
    preferred_channel
FROM customers
WHERE state IN ('California', 'Texas')
    AND registration_date > '2023-01-01'
ORDER BY full_name ASC;

-- ====================================================================
-- Q2b: Multi-Table Aggregation with Conditional Filtering (Intermediate)
-- ====================================================================
-- Write a MySQL query to identify high-value customers who have spent a total of over $1,000 
-- across at least 3 separate transactions in the Online store. Display the customer's customer_id, 
-- full_name, email, the total amount spent (aliased as total_spent), and the total number of 
-- transactions. Format total_spent to 2 decimal places and order the output by total spending 
-- in descending order.

SELECT 
    c.customer_id,
    c.full_name,
    c.email,
    ROUND(SUM(t.quantity * t.price), 2) AS total_spent,
    COUNT(t.transaction_id) AS total_transactions
FROM customers c
INNER JOIN transactions t ON c.customer_id = t.customer_id
WHERE t.store_location = 'Online'
GROUP BY c.customer_id, c.full_name, c.email
HAVING SUM(t.quantity * t.price) > 1000
    AND COUNT(t.transaction_id) >= 3
ORDER BY total_spent DESC;
