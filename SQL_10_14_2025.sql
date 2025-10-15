
/*

3705. Find Golden Hour Customers

Medium

Table: restaurant_orders

+------------------+----------+
| Column Name      | Type     | 
+------------------+----------+
| order_id         | int      |
| customer_id      | int      |
| order_timestamp  | datetime |
| order_amount     | decimal  |
| payment_method   | varchar  |
| order_rating     | int      |
+------------------+----------+
order_id is the unique identifier for this table.
payment_method can be cash, card, or app.
order_rating is between 1 and 5, where 5 is the best (NULL if not rated).
order_timestamp contains both date and time information.
Write a solution to find golden hour customers - customers who consistently order during peak hours and provide high satisfaction. A customer is a golden hour customer if they meet ALL the following criteria:

Made at least 3 orders.
At least 60% of their orders are during peak hours (11:00-14:00 or 18:00-21:00).
Their average rating for rated orders is at least 4.0, round it to 2 decimal places.
Have rated at least 50% of their orders.
Return the result table ordered by average_rating in descending order, then by customer_id​​​​​​​ in descending order.

*/

with temp as (
select customer_id, count(order_id) as total_orders, avg(order_rating) as average_rating,
sum( case when (11 <= extract('hour' from order_timestamp) and extract('hour' from order_timestamp) < 14) or
     (18 <= extract('hour' from order_timestamp) and extract('hour' from order_timestamp) < 21)  then 1 else 0 end) as peak_hours_orders,
sum(case when order_rating is not null then 1 else 0 end) as orders_rated
from restaurant_orders
group by 1
)

select customer_id, total_orders, round((peak_hours_orders::decimal/total_orders) * 100,0) as peak_hour_percentage, round(average_rating,2) as average_rating
from temp
where total_orders >= 3 and ((peak_hours_orders::decimal/total_orders) >= 0.6) and ((orders_rated::decimal/total_orders) >= 0.5) and average_rating >= 4
order by average_rating desc, 1 desc