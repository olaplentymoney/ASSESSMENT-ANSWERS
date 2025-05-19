WITH savings_data AS (
    SELECT 
        owner_id,
        COUNT(DISTINCT id) AS savings_count,
        SUM(confirmed_amount) AS total_savings
    FROM savings_savingsaccount
    WHERE confirmed_amount > 0
    GROUP BY owner_id
),
investment_data AS (
    SELECT 
        owner_id,
        COUNT(DISTINCT id) AS investment_count,
        SUM(amount) AS total_investments
    FROM plans_plan
    WHERE plan_type_id > 0 AND amount > 0
    GROUP BY owner_id
)
SELECT 
    u.id AS customer_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    IFNULL(s.savings_count, 0) AS savings_count,         -- Use 0 if user has no savings data
    IFNULL(i.investment_count, 0) AS investment_count,   -- Use 0 if user has no investment data
    IFNULL(s.total_savings, 0) + IFNULL(i.total_investments, 0) AS total_deposits  -- Handle null sums
FROM users_customuser u
LEFT JOIN savings_data s ON u.id = s.owner_id            -- Ensure users without savings are included
LEFT JOIN investment_data i ON u.id = i.owner_id         -- Ensure users without investments are included
ORDER BY total_deposits DESC;

