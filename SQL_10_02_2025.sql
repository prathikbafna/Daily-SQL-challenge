/*

2986. Find Third Transaction

Medium

Table: Transactions

+------------------+----------+
| Column Name      | Type     |
+------------------+----------+
| user_id          | int      |
| spend            | decimal  |
| transaction_date | datetime |
+------------------+----------+
(user_id, transaction_date) is column of unique values for this table.
This table contains user_id, spend, and transaction_date.
Write a solution to find the third transaction (if they have at least three transactions) of every user, where the spending on the preceding two transactions is lower than the spending on the third transaction.

Return the result table by user_id in ascending order.

The result format is in the following example.

 

Example 1:

Input: 
Transactions table:
+---------+--------+---------------------+
| user_id | spend  | transaction_date    | 
+---------+--------+---------------------+
| 1       | 65.56  | 2023-11-18 13:49:42 | 
| 1       | 96.0   | 2023-11-30 02:47:26 |     
| 1       | 7.44   | 2023-11-02 12:15:23 | 
| 1       | 49.78  | 2023-11-12 00:13:46 | 
| 2       | 40.89  | 2023-11-21 04:39:15 |  
| 2       | 100.44 | 2023-11-20 07:39:34 | 
| 3       | 37.33  | 2023-11-03 06:22:02 | 
| 3       | 13.89  | 2023-11-11 16:00:14 | 
| 3       | 7.0    | 2023-11-29 22:32:36 | 
+---------+--------+---------------------+
Output
+---------+-------------------------+------------------------+
| user_id | third_transaction_spend | third_transaction_date | 
+---------+-------------------------+------------------------+
| 1       | 65.56                   | 2023-11-18 13:49:42    |  
+---------+-------------------------+------------------------+

*/

-- Write your PostgreSQL query statement below

with temp as (
select *, rank() over(partition by user_id order by transaction_date) as rk_1
from Transactions
),

temp2 as (
    select *, rank() over(partition by user_id order by spend) as rk_2
    from temp
    where rk_1 < 4
)

select user_id, spend as third_transaction_spend, transaction_date as third_transaction_date
from temp2
where rk_1 = 3 and rk_2 = 3
order by 1