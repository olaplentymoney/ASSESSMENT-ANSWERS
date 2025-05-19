-- Step 1: Transactions per user per month
WITH monthly_user_txn AS (
    SELECT 
        owner_id,
        DATE_FORMAT(transaction_date, '%Y-%m') AS txn_month,
        COUNT(*) AS txn_count
    FROM savings_savingsaccount
    GROUP BY owner_id, txn_month
),

-- Step 2: Average transactions per user per month
user_avg_monthly_txn AS (
    SELECT 
        owner_id,
        AVG(txn_count) AS avg_txn_per_month
    FROM monthly_user_txn
    GROUP BY owner_id
),

-- Step 3: Categorize users by frequency
categorized_users AS (
    SELECT 
        owner_id,
        avg_txn_per_month,
        CASE 
            WHEN avg_txn_per_month >= 10 THEN 'High Frequency'
            WHEN avg_txn_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM user_avg_monthly_txn
)

-- Final output: Aggregate by category
SELECT 
    frequency_category,
    COUNT(owner_id) AS customer_count,
    ROUND(AVG(avg_txn_per_month), 1) AS avg_transactions_per_month
FROM categorized_users
GROUP BY frequency_category
ORDER BY 
    FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');
