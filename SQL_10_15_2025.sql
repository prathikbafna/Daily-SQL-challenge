/*

3716. Find Churn Risk Customers

Medium

Table: subscription_events

+------------------+---------+
| Column Name      | Type    | 
+------------------+---------+
| event_id         | int     |
| user_id          | int     |
| event_date       | date    |
| event_type       | varchar |
| plan_name        | varchar |
| monthly_amount   | decimal |
+------------------+---------+
event_id is the unique identifier for this table.
event_type can be start, upgrade, downgrade, or cancel.
plan_name can be basic, standard, premium, or NULL (when event_type is cancel).
monthly_amount represents the monthly subscription cost after this event.
For cancel events, monthly_amount is 0.
Write a solution to Find Churn Risk Customers - users who show warning signs before churning. A user is considered churn risk customer if they meet ALL the following criteria:

Currently have an active subscription (their last event is not cancel).
Have performed at least one downgrade in their subscription history.
Their current plan revenue is less than 50% of their historical maximum plan revenue.
Have been a subscriber for at least 60 days.
Return the result table ordered by days_as_subscriber in descending order, then by user_id in ascending order.

*/


-- -- Write your PostgreSQL query statement below

with xyz as (
    select *, last_value(plan_name) over(partition by user_id order by event_date) as last_plan
    from subscription_events
),

temp as (
    select user_id, min(last_plan) as current_plan, max(event_date) - min(event_date) as active_days,
    sum(case when event_type = 'cancel' then 1 else 0 end ) as cancel_count,
    sum(case when event_type = 'start' then 1 else 0 end ) as start_count,
    sum(case when event_type = 'downgrade' then 1 else 0 end ) as num_of_downgrades,
    min(case when event_type = 'downgrade' then monthly_amount else 99999 end) as low_plan,
    max(case when (event_type <> 'cancel' and event_type <> 'downgrade') then monthly_amount else 0 end ) as high_plan
    from xyz
    group by 1

)

select user_id, current_plan, low_plan as current_monthly_amount, high_plan as max_historical_amount, active_days as days_as_subscriber
from temp
where active_days >= 60 and num_of_downgrades > 0 and high_plan/2 >= low_plan and start_count >= cancel_count and cancel_count = 0
order by active_days desc, 1


