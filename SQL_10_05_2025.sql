/*

3580. Find Consistently Improving Employees
Solved
Medium
Topics
premium lock icon
Companies
SQL Schema
Pandas Schema
Table: employees

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| employee_id | int     |
| name        | varchar |
+-------------+---------+
employee_id is the unique identifier for this table.
Each row contains information about an employee.
Table: performance_reviews

+-------------+------+
| Column Name | Type |
+-------------+------+
| review_id   | int  |
| employee_id | int  |
| review_date | date |
| rating      | int  |
+-------------+------+
review_id is the unique identifier for this table.
Each row represents a performance review for an employee. The rating is on a scale of 1-5 where 5 is excellent and 1 is poor.
Write a solution to find employees who have consistently improved their performance over their last three reviews.

An employee must have at least 3 review to be considered
The employee's last 3 reviews must show strictly increasing ratings (each review better than the previous)
Use the most recent 3 reviews based on review_date for each employee
Calculate the improvement score as the difference between the latest rating and the earliest rating among the last 3 reviews
Return the result table ordered by improvement score in descending order, then by name in ascending order.


*/


-- Write your PostgreSQL query statement below


with most_recent_reviews as (
    select *, rank() over(partition by employee_id order by review_date desc) as rk
    from performance_reviews
),

temp as (
select *,
case when rk = rank() over(partition by employee_id order by rating desc) then 1 else 0 end as eval
from most_recent_reviews
where rk < 4
)

select t.employee_id, e.name, max(rating) -  min(rating) as improvement_score
from temp t
join employees e
on t.employee_id = e.employee_id
group by 1,2
having sum(eval) = 3
order by 3 desc , 2