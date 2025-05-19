Data Analyst Assessment:
This assessment involves solving a series of real-world business problems using SQL, focusing on customer behavior, transaction frequency, account activity, and customer lifetime value (CLV).

Explanations
1. High-Value Customers with Multiple Products
Objective: Rank customers based on total confirmed savings and investment inflows.

Approach:

Use CTEs (WITH savings_data, WITH investment_data) to separately summarize savings and investment metrics.

Join with users_customuser using LEFT JOIN to preserve all users.

Use IFNULL() to handle missing data.

Calculate total_deposits = total_savings + total_investments.

2. Transaction Frequency Analysis
Objective: Categorize customers based on average monthly transactions as High, Medium, or Low frequency users.

Approach:

Count total inflow transactions per customer.

Calculate the number of months each customer has been active (based on earliest and latest transaction dates).

Compute average transactions per month.

Use a CASE statement to classify into frequency buckets:

High: ≥ 10 transactions/month

Medium: 3–9 transactions/month

Low: ≤ 2 transactions/month

3. Account Inactivity alert
Objective: Identify active accounts (savings or investments) with no inflow transactions in the past 365 days.

Approach:

Use confirmed_amount > 0 to filter for inflows.

Aggregate the latest transaction date per customer.

Use DATEDIFF(CURDATE(), last_transaction_date) to calculate inactivity based on difference between current date and last txn date.

Flag any account with inactivity_days > 365.

4. Customer Lifetime Value (CLV) Estimation
Objective: Estimate CLV based on tenure and transaction history.

Tenure is calculated from date_joined to current date in months.

Use aggregate functions: COUNT(), AVG(), ROUND().

Challenges Encountered
1. Performance Bottlenecks
Issue: Queries were timing out or causing server connection loss.

Solution: Rewrote queries using CTEs(Common Table Expressions).

2. Handling Missing Data
Issue: Some users lacked either savings or investment records.

Solution: Used LEFT JOIN and IFNULL() to prevent data loss or inaccurate aggregations.

3. Null Division in CLV
Issue: Division by zero when tenure was zero months.

Solution: Used NULLIF() to safely handle potential zero values in tenure calculation.
