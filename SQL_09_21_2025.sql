/*

1459. Rectangles Area

Medium


Table: Points

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| x_value       | int     |
| y_value       | int     |
+---------------+---------+
id is the column with unique values for this table.
Each point is represented as a 2D coordinate (x_value, y_value).
 

Write a solution to report all possible axis-aligned rectangles with a non-zero area that can be formed by any two points from the Points table.

Each row in the result should contain three columns (p1, p2, area) where:

p1 and p2 are the ids of the two points that determine the opposite corners of a rectangle.
area is the area of the rectangle and must be non-zero.
Return the result table ordered by area in descending order. If there is a tie, order them by p1 in ascending order. If there is still a tie, order them by p2 in ascending order.

The result format is in the following table.


*/



-- Write your PostgreSQL query statement below

select p1.id as P1, p2.id as P2, (abs(p1.x_value -  p2.x_value) * abs(p1.y_value - p2.y_value) ) as AREA
from Points p1
cross join Points p2
where p1.id < p2.id and p1.x_value <>  p2.x_value and p1.y_value <> p2.y_value
order by 3 desc, 1, 2




-- Write your PostgreSQL query statement below

-- with points_pair as (
--     select p1.id as P1, p2.id as P2, (abs(p1.x_value -  p2.x_value) * abs(p1.y_value - p2.y_value) ) as AREA
--     from Points p1
--     cross join Points p2
--     where p1.id < p2.id
-- )

-- select * from points_pair
-- where AREA > 0
-- order by AREA desc, P1, P2