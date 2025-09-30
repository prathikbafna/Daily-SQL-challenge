/*

2854. Rolling Average Steps
Solved
Medium
Topics
SQL Schema
Pandas Schema
Table: Steps

+-------------+------+ 
| Column Name | Type | 
+-------------+------+ 
| user_id     | int  | 
| steps_count | int  |
| steps_date  | date |
+-------------+------+
(user_id, steps_date) is the primary key for this table.
Each row of this table contains user_id, steps_count, and steps_date.
Write a solution to calculate 3-day rolling averages of steps for each user.

We calculate the n-day rolling average this way:

For each day, we calculate the average of n consecutive days of step counts ending on that day if available, otherwise, n-day rolling average is not defined for it.
Output the user_id, steps_date, and rolling average. Round the rolling average to two decimal places.

Return the result table ordered by user_id, steps_date in ascending order.

The result format is in the following example.

 

Example 1:

Input: 
Steps table:
+---------+-------------+------------+
| user_id | steps_count | steps_date |
+---------+-------------+------------+
| 1       | 687         | 2021-09-02 |
| 1       | 395         | 2021-09-04 |
| 1       | 499         | 2021-09-05 |
| 1       | 712         | 2021-09-06 |
| 1       | 576         | 2021-09-07 |
| 2       | 153         | 2021-09-06 |
| 2       | 171         | 2021-09-07 |
| 2       | 530         | 2021-09-08 |
| 3       | 945         | 2021-09-04 |
| 3       | 120         | 2021-09-07 |
| 3       | 557         | 2021-09-08 |
| 3       | 840         | 2021-09-09 |
| 3       | 627         | 2021-09-10 |
| 5       | 382         | 2021-09-05 |
| 6       | 480         | 2021-09-01 |
| 6       | 191         | 2021-09-02 |
| 6       | 303         | 2021-09-05 |
+---------+-------------+------------+
Output: 
+---------+------------+-----------------+
| user_id | steps_date | rolling_average | 
+---------+------------+-----------------+
| 1       | 2021-09-06 | 535.33          | 
| 1       | 2021-09-07 | 595.67          | 
| 2       | 2021-09-08 | 284.67          |
| 3       | 2021-09-09 | 505.67          |
| 3       | 2021-09-10 | 674.67          |    
+---------+------------+-----------------+


*/


-- Write your PostgreSQL query statement below

with back_fill as (
    select user_id, steps_count as day_0, steps_date,
    case when steps_date - (lag(steps_date) over(partition by user_id order by steps_date)) = 1 
        then lag(steps_count) over(partition by user_id order by steps_date) else null end as day_1,

    case when steps_date - (lag(steps_date,2,'1999-01-01') over(partition by user_id order by steps_date))::date = 2
        then lag(steps_count,2,null) over(partition by user_id order by steps_date) else null end as day_2
    from Steps
)

select user_id, steps_date, round(((day_0 + day_1 + day_2)::decimal/3),2) as rolling_average
from back_fill
where (day_1 is not null) and (day_2 is not null)