
/*

3611. Find Overbooked Employees

Medium

Table: employees

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| employee_id   | int     |
| employee_name | varchar |
| department    | varchar |
+---------------+---------+
employee_id is the unique identifier for this table.
Each row contains information about an employee and their department.
Table: meetings

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| meeting_id    | int     |
| employee_id   | int     |
| meeting_date  | date    |
| meeting_type  | varchar |
| duration_hours| decimal |
+---------------+---------+
meeting_id is the unique identifier for this table.
Each row represents a meeting attended by an employee. meeting_type can be 'Team', 'Client', or 'Training'.
Write a solution to find employees who are meeting-heavy - employees who spend more than 50% of their working time in meetings during any given week.

Assume a standard work week is 40 hours
Calculate total meeting hours per employee per week (Monday to Sunday)
An employee is meeting-heavy if their weekly meeting hours > 20 hours (50% of 40 hours)
Count how many weeks each employee was meeting-heavy
Only include employees who were meeting-heavy for at least 2 weeks
Return the result table ordered by the number of meeting-heavy weeks in descending order, then by employee name in ascending order.

*/



-- Write your PostgreSQL query statement below
with temp as (
select *,  date_part('week', meeting_date) as week_number,
    date_part('year',meeting_date) as yr
from meetings
),

emp as (
select employee_id, sum(heavy_week) as meeting_heavy_weeks
from (
select employee_id, week_number, yr,
    case when sum(duration_hours) > 20 then 1 else 0 end as heavy_week
from temp
group by 1,2,3
) x
group by employee_id
)

select e.employee_id, e.employee_name, e.department, em.meeting_heavy_weeks
from employees e join emp em on e.employee_id = em.employee_id
where em.meeting_heavy_weeks > 1
order by em.meeting_heavy_weeks desc, e.employee_name