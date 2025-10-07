/*

3673. Find Zombie Sessions

Hard

Table: app_events

+------------------+----------+
| Column Name      | Type     | 
+------------------+----------+
| event_id         | int      |
| user_id          | int      |
| event_timestamp  | datetime |
| event_type       | varchar  |
| session_id       | varchar  |
| event_value      | int      |
+------------------+----------+
event_id is the unique identifier for this table.
event_type can be app_open, click, scroll, purchase, or app_close.
session_id groups events within the same user session.
event_value represents: for purchase - amount in dollars, for scroll - pixels scrolled, for others - NULL.
Write a solution to identify zombie sessions, sessions where users appear active but show abnormal behavior patterns. A session is considered a zombie session if it meets ALL the following criteria:

The session duration is more than 30 minutes.
Has at least 5 scroll events.
The click-to-scroll ratio is less than 0.20 .
No purchases were made during the session.
Return the result table ordered by scroll_count in descending order, then by session_id in ascending order.

*/



-- Write your PostgreSQL query statement below

with temp as (
select session_id, user_id,
sum(case when event_type = 'scroll' then 1 else 0 end ) as scroll_count,
sum(case when event_type = 'click' then 1 else 0 end ) as click_count,
sum(case when event_type = 'purchase' then 1 else 0 end) as purchase,
extract(epoch from max(event_timestamp) - min(event_timestamp)) as time_seconds
from app_events
group by 1, 2
)

select session_id, user_id, time_seconds/60 as session_duration_minutes, scroll_count
from temp
where purchase = 0 and scroll_count > 4 and (time_seconds/60) > 30 and  (click_count::decimal/scroll_count::decimal) < 0.2
order by 4 desc, 1