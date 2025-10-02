/*

3220. Odd and Even Transactions
Solved
Medium
Topics
SQL Schema
Pandas Schema
Table: transactions

+------------------+------+
| Column Name      | Type | 
+------------------+------+
| transaction_id   | int  |
| amount           | int  |
| transaction_date | date |
+------------------+------+
The transactions_id column uniquely identifies each row in this table.
Each row of this table contains the transaction id, amount and transaction date.
Write a solution to find the sum of amounts for odd and even transactions for each day. If there are no odd or even transactions for a specific date, display as 0.

Return the result table ordered by transaction_date in ascending order.

*/

-- Write your PostgreSQL query statement below
select transaction_date, 
sum(case when amount % 2 = 1 then amount else 0 end) as odd_sum,
sum(case when amount % 2 = 0 then amount else 0 end) as even_sum
from transactions
group by 1
order by 1