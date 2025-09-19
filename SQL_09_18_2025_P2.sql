<----

3564. Seasonal Sales Analysis

Medium

Table: sales

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| sale_id       | int     |
| product_id    | int     |
| sale_date     | date    |
| quantity      | int     |
| price         | decimal |
+---------------+---------+
sale_id is the unique identifier for this table.
Each row contains information about a product sale including the product_id, date of sale, quantity sold, and price per unit.
Table: products

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| product_name  | varchar |
| category      | varchar |
+---------------+---------+
product_id is the unique identifier for this table.
Each row contains information about a product including its name and category.
Write a solution to find the most popular product category for each season. The seasons are defined as:

Winter: December, January, February
Spring: March, April, May
Summer: June, July, August
Fall: September, October, November
The popularity of a category is determined by the total quantity sold in that season. If there is a tie, select the category with the highest total revenue (quantity × price).

Return the result table ordered by season in ascending order.

The result format is in the following example.

 

Example:

Input:

sales table:

+---------+------------+------------+----------+-------+
| sale_id | product_id | sale_date  | quantity | price |
+---------+------------+------------+----------+-------+
| 1       | 1          | 2023-01-15 | 5        | 10.00 |
| 2       | 2          | 2023-01-20 | 4        | 15.00 |
| 3       | 3          | 2023-03-10 | 3        | 18.00 |
| 4       | 4          | 2023-04-05 | 1        | 20.00 |
| 5       | 1          | 2023-05-20 | 2        | 10.00 |
| 6       | 2          | 2023-06-12 | 4        | 15.00 |
| 7       | 5          | 2023-06-15 | 5        | 12.00 |
| 8       | 3          | 2023-07-24 | 2        | 18.00 |
| 9       | 4          | 2023-08-01 | 5        | 20.00 |
| 10      | 5          | 2023-09-03 | 3        | 12.00 |
| 11      | 1          | 2023-09-25 | 6        | 10.00 |
| 12      | 2          | 2023-11-10 | 4        | 15.00 |
| 13      | 3          | 2023-12-05 | 6        | 18.00 |
| 14      | 4          | 2023-12-22 | 3        | 20.00 |
| 15      | 5          | 2024-02-14 | 2        | 12.00 |
+---------+------------+------------+----------+-------+
products table:

+------------+-----------------+----------+
| product_id | product_name    | category |
+------------+-----------------+----------+
| 1          | Warm Jacket     | Apparel  |
| 2          | Designer Jeans  | Apparel  |
| 3          | Cutting Board   | Kitchen  |
| 4          | Smart Speaker   | Tech     |
| 5          | Yoga Mat        | Fitness  |
+------------+-----------------+----------+
Output:

+---------+----------+----------------+---------------+
| season  | category | total_quantity | total_revenue |
+---------+----------+----------------+---------------+
| Fall    | Apparel  | 10             | 120.00        |
| Spring  | Kitchen  | 3              | 54.00         |
| Summer  | Tech     | 5              | 100.00        |
| Winter  | Apparel  | 9              | 110.00        |
+---------+----------+----------------+---------------+


---->



-- Write your PostgreSQL query statement below

with temp as (
    select 
    case when EXTRACT('MONTH' from sale_date) in (12,1,2) then 'Winter'
        when EXTRACT('MONTH' from sale_date) > 2 and EXTRACT('MONTH' from sale_date) < 6 then 'Spring'
        when EXTRACT('MONTH' from sale_date) > 5 and EXTRACT('MONTH' from sale_date) < 9 then 'Summer'
        else 'Fall' end as season  
    , category, quantity , (quantity*price) as revenue
    from sales s
    join products p
    on p.product_id = s.product_id
),

temp2 as (
select season, category, sum(quantity) as total_quantity, sum(revenue) as total_revenue
from temp
group by season, category
),
temp_res as (
select season, category, total_quantity, total_revenue,
rank() over(partition by season order by total_quantity desc, total_revenue desc) as rk
from temp2 )

select season, category, total_quantity, total_revenue
from temp_res
where rk = 1
order by 1