/*

2720. Popularity Percentage

Hard

Table: Friends
+-------------+------+
| Column Name | Type |
+-------------+------+
| user1       | int  |
| user2       | int  |
+-------------+------+
(user1, user2) is the primary key (combination of unique values) of this table.
Each row contains information about friendship where user1 and user2 are friends.
Write a solution to find the popularity percentage for each user on Meta/Facebook. The popularity percentage is defined as the total number of friends the user has divided by the total number of users on the platform, then converted into a percentage by multiplying by 100, rounded to 2 decimal places.

Return the result table ordered by user1 in ascending order.

The result format is in the following example.

 

Example 1:

Input: 
Friends table:
+-------+-------+
| user1 | user2 | 
+-------+-------+
| 2     | 1     | 
| 1     | 3     | 
| 4     | 1     | 
| 1     | 5     | 
| 1     | 6     |
| 2     | 6     | 
| 7     | 2     | 
| 8     | 3     | 
| 3     | 9     |  
+-------+-------+
Output: 
+-------+-----------------------+
| user1 | percentage_popularity |
+-------+-----------------------+
| 1     | 55.56                 |
| 2     | 33.33                 |
| 3     | 33.33                 |
| 4     | 11.11                 |
| 5     | 11.11                 |
| 6     | 22.22                 |
| 7     | 11.11                 |
| 8     | 11.11                 |
| 9     | 11.11                 |
+-------+-----------------------+


*/



-- Write your PostgreSQL query statement below


with temp as (
    select user1 as u1, user2 as u2
    from Friends

    union

    select user2 as u1, user1 as u2
    from Friends
)

select u1 as user1, round( ((count(*)::float/(select count(distinct u1) from temp)::float) * 100)::decimal,2) as percentage_popularity
from temp
group by 1
order by 1
