USE retail_analytics;

-- ====================================================================
-- Q3a: Support Metrics & Category Filtering (Intermediate)
-- ====================================================================
-- Write a MySQL query to evaluate urgent customer support tickets. Calculate the average 
-- resolution time in hours (resolution_time_hours) and average customer satisfaction score 
-- (customer_satisfaction_score) for each issue_category where the ticket priority is 'High' 
-- and the ticket status is 'Resolved'. Round both calculated averages to 2 decimal places, 
-- and only include issue categories that have processed more than 5 high-priority tickets.

SELECT 
    issue_category,
    ROUND(AVG(resolution_time_hours), 2) AS avg_resolution_time_hours,
    ROUND(AVG(customer_satisfaction_score), 2) AS avg_customer_satisfaction_score,
    COUNT(ticket_id) AS total_high_priority_tickets
FROM support_tickets
WHERE priority = 'High'
    AND resolution_status = 'Resolved'
GROUP BY issue_category
HAVING COUNT(ticket_id) > 5
ORDER BY avg_resolution_time_hours ASC;

-- ====================================================================
-- Q3b: Multi-Table CTE / Cross-Channel Behavioral Analysis (Very Hard)
-- ====================================================================
-- Marketing needs to analyze customer activity across communication channels. Write a single 
-- MySQL query using Common Table Expressions (CTEs) or subqueries to calculate the following metrics 
-- grouped by preferred_channel (from the customers table):
-- 1. Total registered customers
-- 2. Total count of 'Add to Cart' interactions (from the interactions table)
-- 3. Total revenue generated (from the transactions table)
-- 4. Total count of support tickets raised (from the support_tickets table)
-- Note: Ensure all preferred communication channels are included in the output even if they 
-- have zero transactions or support tickets. Sort the results by total revenue in descending order.

WITH channel_customer_count AS (
    -- CTE 1: Get total registered customers per preferred channel
    SELECT 
        COALESCE(preferred_channel, 'Unknown') AS preferred_channel,
        COUNT(DISTINCT customer_id) AS total_registered_customers
    FROM customers
    GROUP BY preferred_channel
),
channel_add_to_cart_interactions AS (
    -- CTE 2: Get total 'Add to Cart' interactions per channel
    -- Matching 'add to cart' interactions regardless of case/spacing
    SELECT 
        c.preferred_channel,
        COUNT(i.interaction_id) AS total_add_to_cart_interactions
    FROM customers c
    LEFT JOIN interactions i ON c.customer_id = i.customer_id 
        AND LOWER(i.interaction_type) LIKE '%add%cart%'
    GROUP BY c.preferred_channel
),
channel_revenue AS (
    -- CTE 3: Get total revenue generated per channel (quantity * price)
    SELECT 
        c.preferred_channel,
        COALESCE(SUM(t.quantity * t.price), 0) AS total_revenue_generated
    FROM customers c
    LEFT JOIN transactions t ON c.customer_id = t.customer_id
    GROUP BY c.preferred_channel
),
channel_support_tickets AS (
    -- CTE 4: Get total support tickets raised per channel
    SELECT 
        c.preferred_channel,
        COUNT(st.ticket_id) AS total_support_tickets_raised
    FROM customers c
    LEFT JOIN support_tickets st ON c.customer_id = st.customer_id
    GROUP BY c.preferred_channel
)
-- Final SELECT joining all CTEs to produce comprehensive cross-channel analysis
-- Ensures all preferred channels are included even with zero values
SELECT 
    cc.preferred_channel,
    cc.total_registered_customers,
    COALESCE(ci.total_add_to_cart_interactions, 0) AS total_add_to_cart_interactions,
    COALESCE(cr.total_revenue_generated, 0) AS total_revenue_generated,
    COALESCE(cs.total_support_tickets_raised, 0) AS total_support_tickets_raised
FROM channel_customer_count cc
LEFT JOIN channel_add_to_cart_interactions ci ON cc.preferred_channel = ci.preferred_channel
LEFT JOIN channel_revenue cr ON cc.preferred_channel = cr.preferred_channel
LEFT JOIN channel_support_tickets cs ON cc.preferred_channel = cs.preferred_channel
ORDER BY total_revenue_generated DESC;
