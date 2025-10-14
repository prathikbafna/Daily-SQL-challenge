/*
3657. Find Loyal Customers

Medium

Table: customer_transactions

+------------------+---------+
| Column Name      | Type    | 
+------------------+---------+
| transaction_id   | int     |
| customer_id      | int     |
| transaction_date | date    |
| amount           | decimal |
| transaction_type | varchar |
+------------------+---------+
transaction_id is the unique identifier for this table.
transaction_type can be either 'purchase' or 'refund'.
Write a solution to find loyal customers. A customer is considered loyal if they meet ALL the following criteria:

Made at least 3 purchase transactions.
Have been active for at least 30 days.
Their refund rate is less than 20% .
Return the result table ordered by customer_id in ascending order.
*/


with temp as (
    select customer_id, max(transaction_date) - min(transaction_date) as active_days,
    sum(case when transaction_type = 'purchase' then 1 else 0 end) as purchase_count,
    sum(case when transaction_type = 'refund' then 1 else 0 end) as refund_count
    from customer_transactions
    group by 1

)


select customer_id
from temp
where (active_days > 29) and (purchase_count + refund_count > 2) and (refund_count::decimal/purchase_count <= 0.2)
order by 1