-- 1. Latest transaction per customer from savings
WITH savings_activity AS (
    SELECT 
        owner_id,
        MAX(transaction_date) AS last_transaction_date
    FROM savings_savingsaccount
    GROUP BY owner_id
),

-- 2. Investment activity based on plan start_date
investment_activity AS (
    SELECT 
        owner_id,
        MAX(start_date) AS last_transaction_date
    FROM plans_plan
    GROUP BY owner_id
),

-- 3. Combine both inflow sources
all_activity AS (
    SELECT owner_id, last_transaction_date FROM savings_activity
    UNION ALL
    SELECT owner_id, last_transaction_date FROM investment_activity
),

-- 4. Get most recent inflow per customer
latest_inflow_per_owner AS (
    SELECT 
        owner_id,
        MAX(last_transaction_date) AS last_transaction_date
    FROM all_activity
    GROUP BY owner_id
),

-- 5. Add inactivity days and filter
inactive_owners AS (
    SELECT 
        owner_id,
        last_transaction_date,
        DATEDIFF(CURDATE(), last_transaction_date) AS inactivity_days
    FROM latest_inflow_per_owner
    WHERE last_transaction_date IS NULL OR DATEDIFF(CURDATE(), last_transaction_date) > 365
)

-- 6. Join back to account types for context (investment or savings)
SELECT 
    p.id AS plan_id,
    p.owner_id,
    'Investment' AS type,
    i.last_transaction_date,
    i.inactivity_days
FROM plans_plan p
JOIN inactive_owners i ON p.owner_id = i.owner_id

UNION ALL

SELECT 
    s.plan_id AS plan_id,
    s.owner_id,
    'Savings' AS type,
    i.last_transaction_date,
    i.inactivity_days
FROM savings_savingsaccount s
JOIN inactive_owners i ON s.owner_id = i.owner_id;
