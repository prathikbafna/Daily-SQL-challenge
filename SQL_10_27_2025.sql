
/*

3390. Longest Team Pass Streak

Hard


Table: Teams

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| player_id   | int     |
| team_name   | varchar | 
+-------------+---------+
player_id is the unique key for this table.
Each row contains the unique identifier for player and the name of one of the teams participating in that match.
Table: Passes

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| pass_from   | int     |
| time_stamp  | varchar |
| pass_to     | int     |
+-------------+---------+
(pass_from, time_stamp) is the unique key for this table.
pass_from is a foreign key to player_id from Teams table.
Each row represents a pass made during a match, time_stamp represents the time in minutes (00:00-90:00) when the pass was made,
pass_to is the player_id of the player receiving the pass.
Write a solution to find the longest successful pass streak for each team during the match. The rules are as follows:

A successful pass streak is defined as consecutive passes where:
Both the pass_from and pass_to players belong to the same team
A streak breaks when either:
The pass is intercepted (received by a player from the opposing team)
Return the result table ordered by team_name in ascending order.

*/



# Write your MySQL query statement below
WITH combined AS (
    SELECT pass_from, t1.team_name AS team_1, time_stamp, pass_to, t2.team_name AS team_2, ROW_NUMBER() OVER(PARTITION BY t1.team_name ORDER BY time_stamp) as shot, ROW_NUMBER() OVER(PARTITION BY t1.team_name, t1.team_name = t2.team_name ORDER BY time_stamp) AS rankk
    FROM Passes p
    JOIN Teams t1 ON p.pass_from = t1.player_id
    JOIN Teams t2 ON p.pass_to = t2.player_id
),
grouped AS (
    SELECT team_1, COUNT(*) as streak, ROW_NUMBER() OVER(PARTITION BY team_1 ORDER BY COUNT(*) DESC) as roww
    FROM combined
    WHERE team_1 = team_2
    GROUP BY team_1, shot-rankk
)

SELECT team_1 AS team_name, streak AS longest_streak
FROM grouped
WHERE roww = 1
ORDER BY team_name;



-- Write your PostgreSQL query statement below

with temp as (
    select pass_from, t.team_name as pass_from_team, time_stamp, pass_to
    from Passes p join Teams t
    on p.pass_from = t.player_id
),

temp2 as (
    select pass_from, pass_from_team, time_stamp, pass_to, t.team_name as pass_to_team
    from temp tt join Teams t
    on tt.pass_to = t.player_id
),

temp3 as (
select *, case when pass_to_team = pass_from_team then 0 else 1 end as group_id
from temp2
),


partial_res as (
select *, sum(group_id) over(order by time_stamp) as group_id_2
from temp3
),

res as (
select pass_from_team as team_name, count(group_id_2) as streak
from partial_res
where pass_from_team = pass_to_team
group by pass_from_team, pass_to_team, group_id_2
)


select * from partial_res
-- select team_name, max(streak) as longest_streak
-- from res
-- group by 1
-- order by 1
