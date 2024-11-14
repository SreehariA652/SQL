create database covid;
use covid;
select * from covid_19;



-- Calculate the total confirmed, deaths, recovered, and active cases per month
select DISTINCT MONTH(Date) AS Month,
sum(Confirmed) over (partition by MONTH(Date)) as Total_Confirmed,
SUM(Deaths) over (partition by MONTH(Date)) as Total_Deaths,
SUM(Recovered) over (partition by MONTH(Date)) as Total_Recovered,
SUM(Active) over (partition by MONTH(Date)) as Total_Active
from covid_19
order by Month;

-- mortality rate by country
select distinct Country,
cast(sum(Deaths) over (partition by Country) as float) / 
sum(Confirmed) over (partition by Country) as Mortality_Rate from covid_19
where Confirmed > 0;

-- recovery rate by country
select distinct Country,
cast(sum(Recovered) over (partition by Country) as float) / 
sum(Confirmed) over (partition by Country) as Recovery_Rate from covid_19
where Confirmed > 0;

-- country w highest average mortality rate
select  Country,
cast(sum(Deaths) over (partition by Country) as float) /
sum(Confirmed) over (partition by Country) as Avg_Mortality_Rate from covid_19
where Confirmed > 0
order by Avg_Mortality_Rate desc limit 1;


-- country w highest avg recovery rate
select  Country,
cast(sum(Recovered) over (partition by Country) as float) /
sum(Confirmed) over (partition by Country) as Avg_Recovery_Rate from covid_19
where Confirmed > 0
order by Avg_Recovery_Rate desc limit 1;

-- Calculate the monthly new confirmed cases worldwide
select YEAR(Date) AS Year, MONTH(Date) AS Month, 
  sum(Confirmed) - LAG(sum(Confirmed), 1) over (order by  YEAR(Date), MONTH(Date)) as New_Confirmed
from covid_19
group by   YEAR(Date), MONTH(Date);


-- Calculate the monthly new deaths worldwide
select YEAR(Date) AS Year, MONTH(Date) AS Month, 
  sum(Confirmed) - LAG(sum(deaths), 1) over (order by  YEAR(Date), MONTH(Date)) as New_Deaths
from covid_19
group by   YEAR(Date), MONTH(Date);

-- 	Calculate the monthly new recovered cases worldwide 
select YEAR(Date) AS Year, MONTH(Date) AS Month, 
  sum(Confirmed) - LAG(sum(recovered), 1) over (order by  YEAR(Date), MONTH(Date)) as New_Recovered
from covid_19
group by   YEAR(Date), MONTH(Date);
	

-- Calculate the monthly new active cases worldwide 
select YEAR(Date) AS Year, MONTH(Date) AS Month, 
  sum(Confirmed) - LAG(sum(active), 1) over (order by  YEAR(Date), MONTH(Date)) as New_active
from covid_19
group by   YEAR(Date), MONTH(Date);

-- Top 5 countries with highest number of deaths on a specific date
select Country,Deaths from covid_19
where Date = '22/01/2020'  
order by   Deaths DESC LIMIT 5;

-- 	Calculate the average daily increase in confirmed cases for each country
with Daily_Increase as (
select Country,Confirmed - LAG(Confirmed, 1) over (partition by Country order by Date) as Daily_Confirmed_Increase
from   covid_19)
select Country, AVG(Daily_Confirmed_Increase) as Avg_Daily_Confirmed_Increase
from   Daily_Increase
group by Country
order by Avg_Daily_Confirmed_Increase DESC;


-- 	Calculate the average daily increase in deaths for each country 
with Daily_Increase as (
select Country,Deaths - LAG(Deaths, 1) over (partition by Country order by Date) as Daily_Death_Increase
from   covid_19)
select Country, AVG(Daily_Death_Increase) as Avg_Daily_Death_Increase
from   Daily_Increase
group by Country
order by Avg_Daily_Death_Increase DESC;

-- 16.	Calculate the average daily increase in recovered cases for each country 
with Daily_Increase as (
select Country,Recovered - LAG(Recovered, 1) over (partition by Country order by Date) as Daily_Recovered_Increase
from   covid_19)
select Country, AVG(Daily_Recovered_Increase) as Avg_Daily_Recovered_Increase
from   Daily_Increase
group by Country
order by Avg_Daily_Recovered_Increase DESC;

-- 17.	Find the date with the highest number of new confirmed cases worldwide 
select * from covid_19;
with Daily_Increase as (
select Date, sum(confirmed) - LAG(sum(confirmed) ,1) over (order by Date) as Confirmed_new
from covid_19 
group by Date)
select Date, Confirmed_new from Daily_Increase
order by Confirmed_new DESC LIMIT 1;

-- 18.	Find the date with the highest number of new deaths worldwide 
with Daily_Increase as (
select Date, sum(Deaths) - LAG(sum(Deaths) ,1) over (order by Date) as Deaths_new
from covid_19 
group by Date)
select Date, Deaths_new from Daily_Increase
order by Deaths_new DESC LIMIT 1;

-- 19.	Find the date with the highest number of new recovered cases worldwide 
with Daily_Increase as (
select Date, sum(Recovered) - LAG(sum(Recovered) ,1) over (order by Date) as Recovered_new
from covid_19 
group by Date)
select Date, Recovered_new from Daily_Increase
order by Recovered_new DESC LIMIT 1;

-- 20.	Calculate the cumulative confirmed cases per country over time 
select country,Date,sum(confirmed) over (partition by country) as cummulative_confirmed 
from covid_19

order by Date,country;

-- 21.	Calculate the cumulative deaths per country over time 
select country,Date,sum(Deaths) over (partition by country) as Cummulative_Deaths
from covid_19

order by Date,country;

-- 22.	Calculate the cumulative recovered cases per country over time 
select country,Date,sum(Recovered) over (partition by country) as Cummulative_Recovered
from covid_19

order by Date,country;

-- 23.	Calculate the cumulative active cases per country over time 
select country,Date,sum(Active) over (partition by country) as Cummulative_Active
from covid_19

order by Date,country;