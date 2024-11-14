create database walmart;
use walmart;
select * from walmartsales;


--How many unique product lines
select APPROX_COUNT_DISTINCT (product_line) from Walmartsales;

-- Most common payment method
select top 1 payment, count(payment) as number_of_times from Walmartsales group by Payment order by Payment desc; 


--Add time of day
select time, (case when time between '00:00:00' and '12:00:00' then 'Morning'
                   when time between '12:01:00' and '16:00:00' then 'Afternon'
				   else 'Evening' end) as time_of_day from Walmartsales;

Alter table walmartsales add  time_of_day varchar(20);

update Walmartsales set time_of_day =case when time between '00:00:00' and '12:00:00' then 'Morning'
                   when time between '12:01:00' and '16:00:00' then 'Afternon'
				   else 'Evening' end;
select * from Walmartsales;


--Add column day name
alter table walmartsales add day_name varchar(50);

update Walmartsales set day_name = DATENAME(weekday, Date);

-- Add column month name
alter table walmartsales add month_name varchar(50);

update Walmartsales set month_name = DAtename(month, Date);

--How many unique cities and in which city each branch
select APPROX_COUNT_DISTINCT (city) from Walmartsales;

select branch,city from Walmartsales
group by branch, city
order by branch;


--Most selling product line
select * from walmartsales;

select top 1 Product_line, count(Product_line) as number_of_times from Walmartsales group by Product_line order by Product_line desc; 

--What is the total revenue by month
select month_name, sum(cogs) from Walmartsales
group by month_name;


--what month had the largest cogs
select top 1  month_name,  sum(cogs) from Walmartsales
group by month_name
order by sum(cogs) desc;


--product line that had the largest revenue
select top 1 Product_line, SUM(Total) as Revenue
from Walmartsales
group by Product_line
order by Revenue desc;


--City with largest revenue
select top 1 city, sum(total) as Revenue
from Walmartsales
group by city
order by Revenue desc;


--Product line with the largest vat
select top 1 product_line, sum(0.05 * COGS) as VAT
from Walmartsales
group by Product_line
order by VAT desc;


-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
alter table walmartsales add good_or_bad varchar(50);

select product_line, avg(quantity) as avg_quantity from Walmartsales group by Product_line;

select product_line, (case when avg(quantity) > 5.51 then 'good'
else 'Bad' end) as good_or_bad from Walmartsales
group by Product_line;


UPDATE Walmartsales
SET good_or_bad = (
  SELECT CASE 
    WHEN AVG(quantity) > 5.51 THEN 'Good' 
    ELSE 'Bad' 
  END 
  FROM Walmartsales 
  WHERE product_line = Walmartsales.product_line
);

select * from Walmartsales;





--. Which branch sold more products than average product sold
select * from Walmartsales;
select branch, sum(quantity) as total_product_sold from Walmartsales
group by Branch
having sum(quantity) > avg(quantity);

--most common product line by gender
select Gender, Product_line , APPROX_COUNT_DISTINCT (Product_line) as number_of_products from Walmartsales
group by Gender, Product_line
order by Gender, count(Product_line) desc;


--average rating of each product line
select * from Walmartsales;
select product_line , avg(rating) as avg_rating from Walmartsales
group by Product_line
order by avg_rating desc;


--CUSTOMER ANALYSIS
--How many unique customer type
select APPROX_COUNT_DISTINCT (Customer_type) as customer_types_unique from Walmartsales;

--How many unique payment methods
select APPROX_COUNT_DISTINCT (Payment) as payment_types_unique from Walmartsales;

--which customer type buys the most

select top 1 customer_type, sum(quantity) as how_much_bought from Walmartsales
group by Customer_type
order by how_much_bought desc;


--gender of most of the customers
select top 1 gender, count(gender) as most_common_gender from Walmartsales
group by Gender
order by most_common_gender desc;


--Gender distribution per branch
select branch, Gender ,count(gender) as count_of_gender from Walmartsales
group by Branch, Gender
order by count_of_gender ;


--Which time of the day customer gives more rating
select * from Walmartsales;
select time_of_day, count(Rating) as no_of_rating from Walmartsales
group by time_of_day
order by no_of_rating desc;


--Which time of the day customer gives more rating per branch
select Branch, time_of_day, count(Rating) as no_of_rating from Walmartsales
group by time_of_day, Branch
order by no_of_rating desc;


--.Which day of the week has the best avg ratings
select top 1 day_name, avg(rating) as avg_rating from Walmartsales
group by day_name
order by avg_rating desc;


--Which day of the week has the best average ratings per branch
select top 1 branch, day_name, avg(rating) as avg_rating from Walmartsales
group by Branch, day_name
order by avg_rating desc;


--SALES ANALYSIS
--Number of sales made in each time of the day per week day
select * from Walmartsales;
select time_of_day, day_name, count(quantity) as no_of_sales from Walmartsales
where day_name in( 'Monday','Tuesday','Wednesday','Thursday','Friday')
group by time_of_day, day_name
order by no_of_sales;


--which customer type brings the most revenue
select top 1 gender, sum(total) as total_revenue from Walmartsales
group by Gender
order by total_revenue desc;


--which city has the largest tax percentage/VAT
select top 1 city, sum(Tax_5)/sum(0.05 * COGS) as tax_percentage_by_VAt from walmartsales
group by city
order by tax_percentage_by_VAt desc;



--which customer type pays the most in  VAT(5% * COGS)
select top 1 customer_type, sum(0.05 * COGS) as total_VAt from Walmartsales
group by Customer_type
order by total_VAt desc;
