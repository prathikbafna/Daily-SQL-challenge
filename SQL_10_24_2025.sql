/*

1651. Hopper Company Queries III

Hard

Table: Drivers

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| driver_id   | int     |
| join_date   | date    |
+-------------+---------+
driver_id is the column with unique values for this table.
Each row of this table contains the driver's ID and the date they joined the Hopper company.
 

Table: Rides

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| ride_id      | int     |
| user_id      | int     |
| requested_at | date    |
+--------------+---------+
ride_id is the column with unique values for this table.
Each row of this table contains the ID of a ride, the user's ID that requested it, and the day they requested it.
There may be some ride requests in this table that were not accepted.
 

Table: AcceptedRides

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| ride_id       | int     |
| driver_id     | int     |
| ride_distance | int     |
| ride_duration | int     |
+---------------+---------+
ride_id is the column with unique values for this table.
Each row of this table contains some information about an accepted ride.
It is guaranteed that each accepted ride exists in the Rides table.
 

Write a solution to compute the average_ride_distance and average_ride_duration of every 3-month window starting from January - March 2020 to October - December 2020. Round average_ride_distance and average_ride_duration to the nearest two decimal places.

The average_ride_distance is calculated by summing up the total ride_distance values from the three months and dividing it by 3. The average_ride_duration is calculated in a similar way.

Return the result table ordered by month in ascending order, where month is the starting month's number (January is 1, February is 2, etc.).

*/


-- Write your PostgreSQL query statement below

with recursive month_data as(
    select 1 as month
    union

    select month + 1
    from month_data
    where month < 12
),

temp as (
    select a.ride_id, a.ride_distance, a.ride_duration, extract(month from requested_at) as month
    from AcceptedRides a 
    join Rides r on a.ride_id = r.ride_id
    where extract(year from r.requested_at) = 2020
),
temp2 as (
    select month, sum(ride_distance) as "ride_distance", sum(ride_duration) as "ride_duration"
    from temp
    group by 1
),

partial_res as (
    select m.month, coalesce(ride_distance,0) as "ride_distance", 
            coalesce(ride_duration,0) as "ride_duration"
    from month_data m left join temp2 x 
    on m.month = x.month
    order by 1
),

partial_res_2 as (
select month, 
(ride_distance + lead(ride_distance,1,0) over(order by month) + lead(ride_distance,2,0) over(order by month))::decimal/3 as "ride_distance",
(ride_duration + lead(ride_duration,1,0) over(order by month) + lead(ride_duration,2,0) over(order by month))::decimal/3 as "ride_duration"
from partial_res
)

select month, round(ride_distance,2) as average_ride_distance, round(ride_duration,2) as average_ride_duration 
from partial_res_2
where month < 11
order by 1