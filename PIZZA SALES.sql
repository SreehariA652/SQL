CREATE TABLE pizza_sales (
  sale_id INT IDENTITY(1,1) PRIMARY KEY,
  sale_date DATE,
  pizza_type VARCHAR(50),
  size VARCHAR(20),
  quantity INT,
  price DECIMAL(10, 2),
  location VARCHAR(50)
);

INSERT INTO pizza_sales (sale_date, pizza_type, size, quantity, price, location) 
VALUES 
('2024-01-01', 'Pepperoni', 'Small', 5, 8.99, 'New York'), 
('2024-01-01', 'Pepperoni', 'Medium', 3, 12.99, 'New York'), 
('2024-01-02', 'Margherita', 'Large', 2, 15.99, 'New York'), 
('2024-01-02', 'BBQ Chicken', 'Small', 4, 9.99, 'Chicago'), 
('2024-01-03', 'Vegetarian', 'Large', 6, 14.99, 'Los Angeles'), 
('2024-01-04', 'Pepperoni', 'Small', 7, 8.99, 'Chicago'), 
('2024-01-05', 'BBQ Chicken', 'Medium', 2, 13.99, 'Los Angeles'), 
('2024-01-06', 'Margherita', 'Small', 8, 7.99, 'New York'), 
('2024-01-07', 'Vegetarian', 'Medium', 3, 12.99, 'Chicago'), 
('2024-01-08', 'Pepperoni', 'Large', 1, 15.99, 'Los Angeles'), 
('2024-01-09', 'BBQ Chicken', 'Large', 2, 17.99, 'New York'), 
('2024-01-10', 'Vegetarian', 'Small', 5, 9.99, 'Chicago');

select * from pizza_sales;

--Total sales amount by pizza type
with pizza_wise_sales as (select pizza_type, sum(quantity*price) as Total_sales_amount 
from pizza_sales
group by pizza_type)
select * from pizza_wise_sales;

--Average prize of pizza type
with pizza_wise_avg_price as (select pizza_type, avg(price) as Avg_price 
from pizza_sales
group by pizza_type)
select * from pizza_wise_avg_price;

--Total quantity sold by loation
with location_wise_quantity as(
select location,sum(quantity) as Total_quantity
from pizza_sales
group by location)
select * from location_wise_quantity;

--Total sales amount by size
with sales_amount_size as(
select size, sum(quantity*price) as total_sales
from pizza_sales
group by size)
select * from sales_amount_size;

--Total sales amount by type and size
with total_sales_size_type as(
select pizza_type,size, sum(quantity*price) as total_sales_type_and_size
from pizza_sales
group by pizza_type,size)
select * from total_sales_size_type;


--Total sales amount by month
with total_sales_by_month as(
select sale_date, sum(quantity*price) as sale_amount_month
from pizza_sales
group by sale_date)
select * from total_sales_by_month;



select * from pizza_sales;


--Count of sales by pizza type
with pizza_type_count as(
select pizza_type, count(quantity) as count_of_sales
from pizza_sales
group by pizza_type)
select * from pizza_type_count;


--Total sales amount by prize range
select case
when price < 10 then 'cheap'
when price between 10 and 15 then 'normal'
else 'expensive'
end as price_range,
sum(price*quantity) as total_sales_price
from pizza_sales
group by
      case
when price < 10 then 'cheap'
when price between 10 and 15 then 'normal'
else 'expensive'
end;


--Total sales amount by pizza type with a minimum of 5 pizzas sold
select pizza_type, sum(price*quantity) as total_sales_amount
from pizza_sales
group by pizza_type
having sum(quantity) >= 5
order by total_sales_amount;


--Total sales amount by size and location
with total_sales_size_location as(
select location,size, sum(quantity*price) as total_sales_location_and_size
from pizza_sales
group by location,size)
select * from total_sales_size_location;


--Avg quantity sold by the pizza type
with avg_quantity_type as(
select pizza_type, avg(quantity) as avg_quantity
from pizza_sales
group by pizza_type)
select * from avg_quantity_type;


--Total sales amount by location with average price above 10 

select location, sum(price*quantity) as total_sales
from pizza_sales
group by location
having avg(price) > 10;


--Total sales amount by the day of the week
select day(sale_date) as day_of_week,
sum(price*quantity) as total_sales
from pizza_sales
group by day(sale_date);

--or
select datename(dw,sale_date) as day_of_week,
sum(price*quantity) as total_sales
from pizza_sales
group by datename(dw,sale_date);



--Total sales amount by month and location
select location, month(sale_date) as month_of_date, sum(price*quantity)
from pizza_sales
group by month(sale_date), location;

--or
select location, datename(month,sale_date) as month_of_year,
sum(price*quantity) as total_sales
from pizza_sales
group by location, datename(month,sale_date);


-- Total sales amount by pizza type with price range categorization ( Price < 10, “Low”, Between 10 and 15, “Medium”, Else “High”) 
select pizza_type,
case
when price < 10 then 'low'
when price between 10 and 15 then 'medium'
else 'high'
end as price_range,
sum(price*quantity) as total_sales_price 
from pizza_sales
group by pizza_type,case
when price < 10 then 'low'
when price between 10 and 15 then 'medium'
else 'high'
end
order by pizza_type;

--Total sales amount by location with a minimum total sales of 100
with sales_by_location as(
select location,sum(price * quantity) as total_sales
from pizza_sales
group by location
having sum(price * quantity) >= 100
)
select * from sales_by_location
order by total_sales desc;

--Average sales amount per order by pizza type
with avg_sales_amount as(
select pizza_type, avg(price*quantity) as avg_sales_per_order
from pizza_sales
group by pizza_type)
select * from avg_sales_amount;



select * from pizza_sales;

--Total sales amount by location and day of the week
with sales_by_location_day as(
select location, datename(dw,sale_date) as day_of_week, sum(price*quantity) as total_sales
from pizza_sales
group by location,datename(dw,sale_date))
select * from sales_by_location_day;