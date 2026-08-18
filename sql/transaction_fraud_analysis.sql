use fraud_analysis;
-- SQL Project Questions:
-- Customer Analysis:
-- 1. Who are the top 10 customers by total transaction amount?
WITH customer_rank AS
(SELECT c.customer_name, 
       SUM(t.transaction_amount) as total_transaction_amount,
	DENSE_RANK()OVER(ORDER BY sum(t.transaction_amount) DESC ) AS dr
   FROM customers c 
    JOIN transactions t 
   ON c.customer_id = t.customer_id 
    WHERE t.transaction_status = 'successful'
    GROUP BY  c.customer_name)
    SELECT customer_name, total_transaction_amount FROM customer_rank
    WHERE dr <= 10;
    
-- 2. Which customers have made the highest number of transactions?
WITH customer_rank AS
(SELECT c.customer_id,c.customer_name, 
      count(t.transaction_id) as total_transaction,
	ROW_NUMBER()OVER(ORDER BY count(t.transaction_id) DESC) AS dr
    FROM customers c 
    JOIN transactions t 
    ON c.customer_id = t.customer_id 
    WHERE t.transaction_status = 'successful'
    GROUP BY c.customer_id, c.customer_name)
    SELECT customer_id, customer_name, total_transaction FROM customer_rank
    WHERE dr = 1;

-- 3. Which age group contributes the highest transaction value?
SELECT 
   case
       WHEN c.age BETWEEN 18 AND 25 THEN '18-25'
       WHEN c.age BETWEEN 26 AND 35 THEN '26-35'
       WHEN c.age BETWEEN 36 AND 45 THEN '36-45'
       WHEN c.age BETWEEN 46 AND 60 THEN '46-60'
       ELSE '60+'
       END as age_group,
    SUM(t.transaction_amount) AS total_transaction_amount
FROM
    customers c
        JOIN
    transactions t ON c.customer_id = t.customer_id
    WHERE t.transaction_status = 'successful'
GROUP BY age_group
ORDER BY total_transaction_amount DESC
LIMIT 1;

-- 4. Compare transaction amount by gender.
SELECT 
    c.gender,
    SUM(transaction_amount) AS total_transaction_amount
FROM
    customers c
        JOIN
    transactions t ON c.customer_id = t.customer_id
    WHERE t.transaction_status = 'successful'
GROUP BY c.gender
ORDER BY total_transaction_amount DESC;

-- Find customers who have more than one active card.
SELECT 
    c.customer_id,
    c.customer_name,
    COUNT(cd.card_status) AS total_active_card
FROM
    customers c
        JOIN
    cards cd ON c.customer_id = cd.customer_id
WHERE
    cd.card_status = 'active' 
GROUP BY c.customer_id , c.customer_name
HAVING COUNT(cd.card_status) > 1;


-- Card Analysis:

-- 1. Which card type  generates the highest transaction value?
SELECT 
    cd.card_type,
    SUM(t.transaction_amount) AS total_amount_per_card
FROM
    cards cd
        JOIN
    transactions t ON cd.card_id = t.card_id
WHERE
    t.transaction_status = 'successful'
GROUP BY cd.card_type
ORDER BY total_amount_per_card DESC
LIMIT 1;

-- Which card network (Visa, Mastercard, etc.) is used the most?
SELECT cd.card_network,
       COUNT(*) AS total_transactions
FROM cards cd
JOIN transactions t
ON cd.card_id = t.card_id
WHERE t.transaction_status = 'successful'
GROUP BY cd.card_network
ORDER BY total_transactions DESC
LIMIT 1;

-- What is the average transaction amount for each card type?
SELECT 
    cd.card_type,
    AVG(t.transaction_amount) AS avg_transaction_amount
FROM
    cards cd
        JOIN
    transactions t ON cd.card_id = t.card_id
WHERE
    t.transaction_status = 'successful'
GROUP BY cd.card_type
ORDER BY avg_transaction_amount DESC;

-- Which customers have spent more than 80% of their card limit?
SELECT 
    c.customer_name,
    cd.card_id,
    cd.card_limit,
    SUM(t.transaction_amount) AS total_spend,
    round((SUM(t.transaction_amount) / cd.card_limit) * 100 ,2) AS spend_percent
FROM 
    customers c 
JOIN 
    cards cd ON c.customer_id = cd.customer_id
 JOIN 
    transactions t ON cd.card_id = t.card_id
    WHERE t.transaction_status ='successful'
GROUP BY 
    c.customer_id, 
    c.customer_name, 
    cd.card_id, 
    cd.card_limit
HAVING 
    total_spend > (0.80 * cd.card_limit);
    
    
    
    -- Merchant Analysis

-- 1. Which merchant names have the highest successful transaction value?
SELECT 
    m.merchant_name,
    SUM(t.transaction_amount) AS total_transaction_value
FROM
    merchants m
        JOIN
    transactions t ON m.merchant_id = t.merchant_id
WHERE
    t.transaction_status = 'successful'
GROUP BY m.merchant_name
ORDER BY total_transaction_value DESC
LIMIT 10;

-- 2. Which merchant category generates the highest transaction value?
SELECT 
    m.merchant_category,
    SUM(t.transaction_amount) AS total_value
FROM
    merchants m
        JOIN
    transactions t ON m.merchant_id = t.merchant_id
WHERE
    t.transaction_status = 'successful'
GROUP BY m.merchant_category
ORDER BY total_value DESC
LIMIT 1;

-- Which city/state has the highest merchant transaction value?
SELECT 
    m.city AS merchant_city,
    m.state AS merchant_state,
    SUM(t.transaction_amount) AS total_value
FROM
    merchants m
        JOIN
    transactions t ON m.merchant_id = t.merchant_id
WHERE
    t.transaction_status = 'successful'
GROUP BY m.city , m.state
ORDER BY total_value DESC
LIMIT 1;



-- Fraud Analysis:

-- 1. What is the overall fraud rate?
SELECT AVG(fraud_flag) * 100 AS overall_fraud_rate
FROM transactions;

-- Which merchant categories have the highest fraud rate?
SELECT 
    m.merchant_category,
    ROUND((SUM(t.fraud_flag) * 100.0) / COUNT(*),
            1) AS fraud_rate_per_category
FROM
    merchants m
        JOIN
    transactions t ON m.merchant_id = t.merchant_id
GROUP BY m.merchant_category
ORDER BY fraud_rate_per_category DESC
LIMIT 1;

-- Which payment method has the highest fraud percentage?
SELECT 
    payment_method,
    ROUND((SUM(fraud_flag) * 100) / COUNT(*), 1) AS fraud_percentage
FROM
    transactions
GROUP BY payment_method
ORDER BY fraud_percentage DESC
LIMIT 1;


-- Time Analysis:

-- 1. Show the monthly transaction trend.
SELECT 
    DATE_FORMAT(transaction_date, '%Y-%M') AS month,
    SUM(transaction_amount) AS total_amount
FROM
    transactions
WHERE
    transaction_status = 'successful'
GROUP BY DATE_FORMAT(transaction_date, '%Y-%M') , YEAR(transaction_date) , MONTH(transaction_date)
ORDER BY YEAR(transaction_date) , MONTH(transaction_date);
         
-- 2. Find the peak transaction hour.
SELECT 
    HOUR(transaction_date) AS peak_hour,
    SUM(transaction_amount) AS total_amount
FROM
    transactions
WHERE
    transaction_status = 'successful'
GROUP BY HOUR(transaction_date)
ORDER BY total_amount DESC
LIMIT 1;


-- 3. Compare weekday vs weekend transaction volume.
SELECT 
    CASE
        WHEN DAYNAME(transaction_date) IN ('saturday' , 'sunday') THEN 'weekend'
        ELSE 'weekdays'
    END AS days_type,
    COUNT(*) AS total_transactions
FROM
    transactions
WHERE
    transaction_status = 'successful'
GROUP BY days_type;

-- Advanced SQL (Window Functions & CTEs):

-- Rank the top 5 customers in each state by transaction amount using DENSE_RANK().
WITH customer_rnk AS
(SELECT c.customer_name,c.state AS customer_state,sum(t.transaction_amount) AS total_amount,
DENSE_RANK() OVER(PARTITION BY c.state ORDER BY sum(t.transaction_amount) DESC) AS dr
FROM customers c 
JOIN transactions t 
ON c.customer_id = t.customer_id
GROUP BY c.customer_name,c.state)
SELECT customer_state, customer_name,total_amount FROM customer_rnk
WHERE dr <= 5; 

-- Find the first and latest transaction for every customer using window functions.
WITH cte AS
(SELECT  customer_id, transaction_id, transaction_date,transaction_amount,
ROW_NUMBER() OVER(PARTITION BY  customer_id ORDER BY transaction_date DESC) AS latest_date,
ROW_NUMBER() OVER(PARTITION BY  customer_id ORDER BY transaction_date ASC) AS first_date
FROM transactions)
SELECT DISTINCT customer_id,transaction_id, first_date,latest_date,transaction_amount,
CASE WHEN first_date =1 THEN 'first_transaction'
       WHEN latest_date=1 THEN 'latest_transaction'
END AS transaction_type
FROM  cte
WHERE latest_date = 1 or first_date =1;


-- advance  questions:
-- Identify dormant customers (no transactions in the last 90 days).
SELECT 
    c.customer_id, c.customer_name
FROM
    customers c
        LEFT JOIN
    transactions t ON c.customer_id = t.customer_id
GROUP BY c.customer_id , c.customer_name
HAVING MAX(t.transaction_date) < CURRENT_DATE() - INTERVAL 90 DAY
    OR MAX(t.transaction_date) IS NULL;

-- Find customers with transactions in consecutive months.
WITH customer_months AS (
    SELECT DISTINCT
        customer_id,
        YEAR(transaction_date) AS yr,
        MONTH(transaction_date) AS mon
    FROM transactions
    WHERE transaction_status = 'successful'
),
cte AS (
    SELECT *,
           LAG(yr) OVER(PARTITION BY customer_id ORDER BY yr, mon) AS prev_year,
           LAG(mon) OVER(PARTITION BY customer_id ORDER BY yr, mon) AS prev_month
    FROM customer_months
)
SELECT DISTINCT customer_id
FROM cte
WHERE (yr = prev_year AND mon = prev_month + 1)
   OR (yr = prev_year + 1 AND prev_month = 12 AND mon = 1);
   
-- Calculate Customer Lifetime Value (CLV).
SELECT 
    c.customer_name, SUM(t.transaction_amount) AS clv
FROM
    customers c
        JOIN
    transactions t ON c.customer_id = t.customer_id
WHERE
    t.transaction_status = 'successful'
GROUP BY c.customer_id , c.customer_name
ORDER BY clv DESC;

-- Perform RFM Analysis (Recency, Frequency, Monetary).
WITH rfm AS (
    SELECT
        c.customer_id,
        c.customer_name,

        -- Recency: days since customer's latest transaction
        DATEDIFF(
            CURRENT_DATE(),
            MAX(t.transaction_date)
        ) AS recency,

        -- Frequency: number of successful transactions
        COUNT(t.transaction_id) AS frequency,

        -- Monetary: total amount spent
        SUM(t.transaction_amount) AS monetary

    FROM customers c
    JOIN transactions t
        ON c.customer_id = t.customer_id

    WHERE t.transaction_status = 'successful'

    GROUP BY
        c.customer_id,
        c.customer_name
)

SELECT *
FROM rfm
ORDER BY monetary DESC;

