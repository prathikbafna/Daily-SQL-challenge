/*


1811. Find Interview Candidates

Medium

Table: Contests

+--------------+------+
| Column Name  | Type |
+--------------+------+
| contest_id   | int  |
| gold_medal   | int  |
| silver_medal | int  |
| bronze_medal | int  |
+--------------+------+
contest_id is the column with unique values for this table.
This table contains the LeetCode contest ID and the user IDs of the gold, silver, and bronze medalists.
It is guaranteed that any consecutive contests have consecutive IDs and that no ID is skipped.
 

Table: Users

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| user_id     | int     |
| mail        | varchar |
| name        | varchar |
+-------------+---------+
user_id is the column with unique values for this table.
This table contains information about the users.
 

Write a solution to report the name and the mail of all interview candidates. A user is an interview candidate if at least one of these two conditions is true:

The user won any medal in three or more consecutive contests.
The user won the gold medal in three or more different contests (not necessarily consecutive).
Return the result table in any order.

*/

-- Write your PostgreSQL query statement below

with user_gold_wins as (
    select mail, name, u.user_id
    from Users u
    join Contests c 
    on u.user_id = c.gold_medal
    group by 1,2,3
    having count(*) > 2
),

other_wins as (
    select mail, name, u.user_id , contest_id 
    from Users u
    join Contests c 
    on u.user_id = c.gold_medal or u.user_id = c.silver_medal or u.user_id = bronze_medal
),
temp as (
select mail, name, user_id , contest_id - row_number() over(partition by user_id order by contest_id) as rn
from other_wins
)

select name , mail 
from temp
group by 1, 2, user_id, rn
having count(*) > 2

union 

select name, mail 
from user_gold_wins