/*

3626. Find Stores with Inventory Imbalance

Medium

Table: stores

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| store_id    | int     |
| store_name  | varchar |
| location    | varchar |
+-------------+---------+
store_id is the unique identifier for this table.
Each row contains information about a store and its location.
Table: inventory

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| inventory_id| int     |
| store_id    | int     |
| product_name| varchar |
| quantity    | int     |
| price       | decimal |
+-------------+---------+
inventory_id is the unique identifier for this table.
Each row represents the inventory of a specific product at a specific store.
Write a solution to find stores that have inventory imbalance - stores where the most expensive product has lower stock than the cheapest product.

For each store, identify the most expensive product (highest price) and its quantity
For each store, identify the cheapest product (lowest price) and its quantity
A store has inventory imbalance if the most expensive product's quantity is less than the cheapest product's quantity
Calculate the imbalance ratio as (cheapest_quantity / most_expensive_quantity)
Round the imbalance ratio to 2 decimal places
Only include stores that have at least 3 different products
Return the result table ordered by imbalance ratio in descending order, then by store name in ascending order.

*/



-- Write your PostgreSQL query statement below

with temp as (
select *, rank() over(partition by store_id order by price desc) as price_rank_top,
rank() over(partition by store_id order by price) as price_rank_low
from inventory
),

temp2 as (
select store_id, lead(product_name) over(partition by store_id order by price_rank_low ) as most_exp_product,
product_name as cheapest_product,
(quantity::decimal/lead(quantity) over(partition by store_id order by price_rank_low )) as imbalance_ratio,
lead(price) over(partition by store_id order by price_rank_low ) as exp_price,
price_rank_low, lead(price_rank_low) over(partition by store_id order by price_rank_low ) as next_rk
from temp
where (price_rank_top = 1 or price_rank_low = 1)
order by store_id
)

select t.store_id, store_name , location,  most_exp_product, cheapest_product, round(imbalance_ratio,2) as imbalance_ratio
from temp2 t join stores s on s.store_id = t.store_id
where imbalance_ratio > 1 and most_exp_product is not null and ((next_rk - price_rank_low) > 1)
order by imbalance_ratio desc, 2
