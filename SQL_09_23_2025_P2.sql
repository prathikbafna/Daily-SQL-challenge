/*

2159. Order Two Columns Independently

Medium

Table: Data

+-------------+------+
| Column Name | Type |
+-------------+------+
| first_col   | int  |
| second_col  | int  |
+-------------+------+
This table may contain duplicate rows.
 

Write a solution to independently:

order first_col in ascending order.
order second_col in descending order.
The result format is in the following example.

*/

-- Write your PostgreSQL query statement below

with first_t as (
    select first_col, row_number() over(order by first_col) as rn
    from Data
),

second_t as (
    select second_col, row_number() over(order by second_col desc) as rn
    from Data
)

select first_col, second_col 
from first_t f join second_t s on s.rn = f.rn