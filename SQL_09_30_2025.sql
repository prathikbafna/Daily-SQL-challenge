/*
2701. Consecutive Transactions with Increasing Amounts

Hard

Table: Transactions

+------------------+------+
| Column Name      | Type |
+------------------+------+
| transaction_id   | int  |
| customer_id      | int  |
| transaction_date | date |
| amount           | int  |
+------------------+------+
transaction_id is the primary key of this table. 
Each row contains information about transactions that includes unique (customer_id, transaction_date) along with the corresponding customer_id and amount.  
Write an SQL query to find the customers who have made consecutive transactions with increasing amount for at least three consecutive days. Include the customer_id, start date of the consecutive transactions period and the end date of the consecutive transactions period. There can be multiple consecutive transactions by a customer.

Return the result table ordered by customer_id, consecutive_start, consecutive_end in ascending order.

The query result format is in the following example.

 

Example 1:

Input: 
Transactions table:
+----------------+-------------+------------------+--------+
| transaction_id | customer_id | transaction_date | amount |
+----------------+-------------+------------------+--------+
| 1              | 101         | 2023-05-01       | 100    |
| 2              | 101         | 2023-05-02       | 150    |
| 3              | 101         | 2023-05-03       | 200    |
| 4              | 102         | 2023-05-01       | 50     |
| 5              | 102         | 2023-05-03       | 100    |
| 6              | 102         | 2023-05-04       | 200    |
| 7              | 105         | 2023-05-01       | 100    |
| 8              | 105         | 2023-05-02       | 150    |
| 9              | 105         | 2023-05-03       | 200    |
| 10             | 105         | 2023-05-04       | 300    |
| 11             | 105         | 2023-05-12       | 250    |
| 12             | 105         | 2023-05-13       | 260    |
| 13             | 105         | 2023-05-14       | 270    |
+----------------+-------------+------------------+--------+
Output: 
+-------------+-------------------+-----------------+
| customer_id | consecutive_start | consecutive_end | 
+-------------+-------------------+-----------------+
| 101         |  2023-05-01       | 2023-05-03      | 
| 105         |  2023-05-01       | 2023-05-04      |
| 105         |  2023-05-12       | 2023-05-14      | 
+-------------+-------------------+-----------------+
Explanation: 
- customer_id 101 has made consecutive transactions with increasing amounts from May 1st, 2023, to May 3rd, 2023
- customer_id 102 does not have any consecutive transactions for at least 3 days. 
- customer_id 105 has two sets of consecutive transactions: from May 1st, 2023, to May 4th, 2023, and from May 12th, 2023, to May 14th, 2023. 
customer_id is sorted in ascending order.

*/

-- -- Write your PostgreSQL query statement below

-- -- first lets find consecutive dates
-- with cont_dates as (
--     select customer_id, transaction_date,amount,  transaction_date - '2000-01-01'::date - 
--     row_number() over(partition by customer_id order by transaction_date) as d_rn,
--     row_number() over(partition by customer_id order by transaction_date) as rn
--     -- row_number() over(partition by customer_id order by transaction_date) - row_number() over(partition by customer_id order by amount) as d
--     from Transactions
-- ),

-- cont_amount as (
--     select customer_id, transaction_date,amount, d_rn,
--     rn - row_number() over(partition by customer_id,d_rn order by amount) as d
--     from cont_dates
-- ),

-- temp as (
-- select customer_id, min(transaction_date) as consecutive_start, max(transaction_date) as consecutive_end, count(*) as cnt
-- from cont_amount
-- group by customer_id,d_rn,d
-- )

-- -- select customer_id, consecutive_start, consecutive_end
-- -- from temp
-- -- where (cnt > 2) and consecutive_end - consecutive_start >= 2
-- -- order by 1,2,3

-- select * from cont_amount
-- where customer_id in (15,43)
-- order by customer_id,transaction_date




-- Write your PostgreSQL query statement below

with cte as (
    select
        t1.customer_id,
        t1.transaction_date as dt1,
        t2.transaction_date as dt2,
        t1.amount,
        t1.transaction_date - row_number() over (partition by t1.customer_id order by t1.transaction_date) * interval '1 day' as diff
    from
        transactions t1
    join
        transactions t2
    on
        t1.customer_id = t2.customer_id and t1.transaction_date + interval '1 day' = t2.transaction_date and t1.amount < t2.amount
)

select 
    customer_id,
    min(dt1) as consecutive_start,
    max(dt2) as consecutive_end
from 
    cte
group by 
    1, diff
having 
    count(*) >= 2
order by 1;