SELECT 
    u.id AS customer_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,
    COUNT(s.id) AS total_transactions,

    -- Calculate estimated CLV:
    -- (transactions per month) * 12 * average profit per transaction
    -- Profit per transaction is 0.1% of the average confirmed_amount
    ROUND(
        (COUNT(s.id) / NULLIF(TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()), 0)) * 12 *
        (AVG(s.confirmed_amount) * 0.001),
        2
    ) AS estimated_clv

FROM users_customuser u
JOIN savings_savingsaccount s ON u.id = s.owner_id
WHERE s.confirmed_amount > 0  -- Only include inflow transactions
GROUP BY u.id, u.first_name, u.last_name, u.date_joined
ORDER BY estimated_clv DESC;
;

