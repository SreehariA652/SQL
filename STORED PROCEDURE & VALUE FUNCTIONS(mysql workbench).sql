-- STORED PROCEDURES
create database vehicle;
use vehicle;
CREATE TABLE Cars (
    make VARCHAR(50),
    model VARCHAR(50),
    year INT,
    value DECIMAL(15, 2)
);
INSERT INTO Cars (make, model, year, value) VALUES
('Porsche', '911 GT3', 2020, 169700.00),
('Porsche', 'Cayman GT4', 2018, 118000.00),
('Porsche', 'Panamera', 2022, 113200.00),
('Porsche', 'Macan', 2019, 27400.00),
('Porsche', '718 Boxster', 2017, 48880.00),
('Ferrari', '488 GTB', 2015, 254750.00),
('Ferrari', 'F8 Tributo', 2019, 375000.00),
('Ferrari', 'SF90 Stradale', 2020, 627000.00),
('Ferrari', '812 Superfast', 2017, 335300.00),
('Ferrari', 'GTC4Lusso', 2016, 268000.00),
('Porsche', '911 GT3', 2020, 169700.00),
('Porsche', 'Cayman GT4', 2018, 118000.00),
('Porsche', 'Panamera', 2022, 113200.00),
('Porsche', 'Macan', 2019, 27400.00),
('Porsche', '718 Boxster', 2017, 48880.00),
('Ferrari', '488 GTB', 2015, 254750.00),
('Ferrari', 'F8 Tributo', 2019, 375000.00),
('Ferrari', 'SF90 Stradale', 2020, 627000.00),
('Ferrari', '812 Superfast', 2017, 335300.00),
('Ferrari', 'GTC4Lusso', 2016, 268000.00);
select * from cars;
select count(*) from cars;

select * from cars
order by value desc limit 5;


--  without parameter
DELIMITER //
CREATE PROCEDURE get_all_cars()
BEGIN
    select * from cars
    order by value desc limit 5;
END //
DELIMITER ;
    
CALL get_all_cars;   


-- with parameter
-- IN
DELIMITER //
CREATE PROCEDURE get_cars_by_year(IN year_filter int)
BEGIN
     select * from cars
     where year = year_filter
     order by value desc limit 2;
END //
DELIMITER ;

CALL get_cars_by_year(2020); -- can give any specific year

-- with parameter
-- OUT
 DELIMITER //
CREATE PROCEDURE get_car_stats_by_year(
               IN year_filter INT,
               OUT cars_number INT,
               OUT min_value DECIMAL(10,2),
               OUT avg_value DECIMAL(10,2),
               OUT max_value DECIMAL(10,2)
)
BEGIN 
     select count(*), min(value), 
            avg(value), max(value)
	 INTO cars_number, min_value, avg_value, max_value
     from cars
     where year = year_filter
     order by make, value desc;
END //
DELIMITER ;

CALL get_car_stats_by_year(2020, @cars_number, @min_value,
								 @avg_value, @max_value);
                                 
select @cars_number, @min_value,@avg_value, @max_value;


-- VALUE FUNCTION
create table func1(
month varchar(100),
sales int
);

insert into func1(month, sales)
values 
('January', 1000),
('February', 1200),
('March', 1500),
('April', 1700);


-- LEAD
-- Allows you to access data from the following rows to the current rows
select month, sales,
       lead(sales) over(order by month) as 'Next month sales'
       from func1;
  
  
  -- LAG
  -- Allows you to access data from the previous rows to the current rows
select month, sales,
       lag(sales) over(order by month) as 'Previous month sales'
       from func1;       