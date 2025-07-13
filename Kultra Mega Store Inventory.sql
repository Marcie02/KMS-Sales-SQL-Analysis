--SELECT * FROM KMS

-- Q1. Which product category had the highest sales? 
SELECT TOP 1
product_category, SUM(sales) AS Total_Sales 
from KMS
group by product_category
ORDER BY Total_Sales desc;

-- Q2.  What are the Top 3 and Bottom 3 regions in terms of sales? 
SELECT TOP 3
region, SUM(sales) AS Top_Sales 
from KMS
group by region
ORDER BY Top_Sales desc;

SELECT top 3
region, SUM(sales) AS Bottom_Sales 
from KMS
group by region
ORDER BY Bottom_Sales asc;

--Q3. What were the total sales of appliances in Ontario? 
SELECT region, product_subcategory, SUM(sales) as Total_Sales
FROM KMS
WHERE region = 'Ontario' AND 
product_subcategory = 'Appliances' 
group by region, product_subcategory

--Q4.  Advise the management of KMS on what to do to increase the revenue from the bottom 10 customers
select top 10
customer_name, sales, shipping_cost, product_category, customer_segment, product_name, (order_quantity * unit_price) as	Revenue 
from KMS
order by Revenue asc
--I noticed that the customers with the bottom 10 revenue get the product moslty sold under the office supplies category, the customers that partonize us more are from the corporate sector and they 
--have cheap shipping cost. so to increase the revenue i suggest
--1. When someone orders office supplies, recommend: High-margin electronics (printers, shredders), Maintenance products or complementary items
--2. Sell bundle packs like "Corporate starter kits', that have products like pen, pencil, stapler, paper clip, highlighters and price them to increase bulk purchases
--3. Introduce incentives like "spend $300 and get 10% off shipping fee" since shipping fee is already cheap

--Q5. KMS incurred the most shipping cost using which shipping method? 
select TOP 1 
ship_mode, sum(shipping_cost) as delivery_fee
from KMS
group by ship_mode
order by delivery_fee desc

--Q6. Who are the most valuable customers, and what products or services do they typically purchase? 
SELECT TOP 20
customer_name, product_category, product_name, customer_segment,
	COUNT(DISTINCT order_id) AS Total_Orders, -- to chech for loyalty and how often they order
    SUM(order_quantity * unit_price) AS Total_Revenue,
    SUM(profit) AS Total_Profit, --company gain
    AVG(order_quantity * unit_price) AS Avg_Order_Value -- how much they spend per transaction
FROM KMS
GROUP BY customer_name, customer_segment, product_category, product_name
ORDER BY Total_Revenue DESC;

--Q7. Which small business customer had the highest sales? 
select top 1
customer_name, customer_segment, sum(sales) as Total_Sales
from KMS
where customer_segment = 'Small Business'
group by customer_name, customer_segment
order by Total_Sales desc

--Q8.  Which Corporate Customer placed the most number of orders in 2009 – 2012? 
select top 1
customer_name, 
customer_segment,  
count(distinct (order_id)) as Total_Orders 
from KMS
where customer_segment = 'Corporate'
and YEAR(order_date) BETWEEN 2009 AND 2012
group by customer_name, customer_segment, YEAR(order_date)
order by Total_Orders desc

--Q9.  Which consumer customer was the most profitable one? 
select top 1
customer_name, customer_segment, sum(profit) as Total_Profit
from KMS
where customer_segment = 'Consumer'
group by customer_name, customer_segment
order by Total_Profit desc

--Q10 Which customer returned items, and what segment do they belong to? 
select 
customer_name, customer_segment,  COUNT(*) AS Return_Count
from KMS
where profit < 0
GROUP BY customer_name, customer_segment
ORDER BY Return_Count DESC;

--11. If the delivery truck is the most economical but the slowest shipping method and 
--Express Air is the fastest but the most expensive one, do you think the company 
--appropriately spent shipping costs based on the Order Priority? Explain your answer

select
ship_mode, order_priority ,sum(shipping_cost) as delivery_fee,count(distinct (order_id)) as Total_Orders
from KMS 
where ship_mode = 'Delivery Truck' or ship_mode = 'Express Air'
group by ship_mode, order_priority
order by delivery_fee desc

/* Based on the data, Express Air, the most expensive shipping method, is being used even for Low and Medium priority orders.
This implies that KMS is overspending on shipping where it's not necessary.
Also, if Critical or High priority orders are being delivered using Delivery Truck, that may cause delays in urgent deliveries, potentially harming customer satisfaction.
Therefore, it appears that shipping methods were not always chosen appropriately based on the order priority, and KMS should establish a better shipping policy to align cost with urgency.*/
