/*

3601. Find Drivers with Improved Fuel Efficiency

Medium

Table: drivers

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| driver_id   | int     |
| driver_name | varchar |
+-------------+---------+
driver_id is the unique identifier for this table.
Each row contains information about a driver.
Table: trips

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| trip_id       | int     |
| driver_id     | int     |
| trip_date     | date    |
| distance_km   | decimal |
| fuel_consumed | decimal |
+---------------+---------+
trip_id is the unique identifier for this table.
Each row represents a trip made by a driver, including the distance traveled and fuel consumed for that trip.
Write a solution to find drivers whose fuel efficiency has improved by comparing their average fuel efficiency in the first half of the year with the second half of the year.

Calculate fuel efficiency as distance_km / fuel_consumed for each trip
First half: January to June, Second half: July to December
Only include drivers who have trips in both halves of the year
Calculate the efficiency improvement as (second_half_avg - first_half_avg)
Round all results to 2 decimal places
Return the result table ordered by efficiency improvement in descending order, then by driver name in ascending order.


*/
with temp as (
    select case when extract(month from trip_date) < 7 then 1 else 2 end as time_frame,
    driver_id, avg(distance_km/fuel_consumed) as efficiency
    from trips
    group by 1,2

)

select tr.driver_id, driver_name, round(first_half_avg,2) as first_half_avg , 
    round(second_half_avg,2) as second_half_avg, round(efficiency_improvement,2) as efficiency_improvement
from (
    select t1.driver_id, t1.efficiency as first_half_avg, t2.efficiency as second_half_avg, 
    t2.efficiency - t1.efficiency as efficiency_improvement
    from temp t1 join temp t2 
    on t1.driver_id = t2.driver_id and t1.time_frame < t2.time_frame and t1.efficiency < t2.efficiency
) tr 
join drivers d on tr.driver_id = d.driver_id
order by efficiency_improvement desc, driver_name