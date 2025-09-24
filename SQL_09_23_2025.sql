/*

1892. Page Recommendations II

Hard

Table: Friendship

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| user1_id      | int     |
| user2_id      | int     |
+---------------+---------+
(user1_id, user2_id) is the primary key (combination of columns with unique values) for this table.
Each row of this table indicates that the users user1_id and user2_id are friends.
 

Table: Likes

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| user_id     | int     |
| page_id     | int     |
+-------------+---------+
(user_id, page_id) is the primary key (combination of columns with unique values) for this table.
Each row of this table indicates that user_id likes page_id.
 

You are implementing a page recommendation system for a social media website. Your system will recommend a page to user_id if the page is liked by at least one friend of user_id and is not liked by user_id.

Write a solution to find all the possible page recommendations for every user. Each recommendation should appear as a row in the result table with these columns:

user_id: The ID of the user that your system is making the recommendation to.
page_id: The ID of the page that will be recommended to user_id.
friends_likes: The number of the friends of user_id that like page_id.
Return the result table in any order.

*/


-- Write your PostgreSQL query statement below

-- page to recomment to user,
--  User must have not liked
--  Users friends must have liked

with all_friends as (
    select user2_id as u1, user1_id as u2
    from Friendship

    union

    select user1_id as u1, user2_id as u2
    from Friendship
),

 temp as (
    -- get all the pages liked by u1's friends
    select a.u1, a.u2, l.page_id
    from all_friends a
    join Likes l on a.u2 = l.user_id

)

select u1 as user_id, page_id, count(*) as friends_likes
from temp t
where not exists (
    select 1 
    from Likes l
    where t.u1 = l.user_id and t.page_id = l.page_id
)
group by 1,2
