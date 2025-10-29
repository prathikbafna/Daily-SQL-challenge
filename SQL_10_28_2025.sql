# /*

# 3268. Find Overlapping Shifts II

# Hard

# Table: EmployeeShifts

# +------------------+----------+
# | Column Name      | Type     |
# +------------------+----------+
# | employee_id      | int      |
# | start_time       | datetime |
# | end_time         | datetime |
# +------------------+----------+
# (employee_id, start_time) is the unique key for this table.
# This table contains information about the shifts worked by employees, including the start time, and end time.
# Write a solution to analyze overlapping shifts for each employee. Two shifts are considered overlapping if they occur on the same date and one shift's end_time is later than another shift's start_time.

# For each employee, calculate the following:

# The maximum number of shifts that overlap at any given time.
# The total duration of all overlaps in minutes.
# Return the result table ordered by employee_id in ascending order.

# */


with cte as(
    select a.employee_id,
    count(b.start_time) overlap,
    sum(
        case when a.start_time=b.start_time
        and a.end_time=b.end_time
        then 0
        else timestampdiff(minute,b.start_time,a.end_time) end)duration
    from EmployeeShifts a
    join EmployeeShifts b
    on a.employee_id=b.employee_id
    and a.start_time<=b.start_time
    and a.end_time>b.start_time
    group by 1,a.start_time
        
)
select employee_id,
max(overlap)max_overlapping_shifts    ,
sum(duration)total_overlap_duration 
from cte
group by 1
order by 1