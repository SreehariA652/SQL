--create database Accidents;
use Accidents;
select * from Road_accidents;

--current year casualities(2022)
select sum(Number_of_Casualties) as CY_Casualities from Road_accidents
where year(Accident_Date) = 2022;

--CY fatal casualties
select sum( Number_of_Casualties) as CY_fatal_casualities from Road_accidents
where year(Accident_date)=2022 and Accident_severity='Fatal';


--CY serious casualities
select sum(Number_of_Casualties) as CY_Serious_casualities from Road_accidents
where year(Accident_date)=2022 and Accident_severity='Serious';

--CY slight casualities
select sum(Number_of_Casualties) as CY_Slight_casualities from Road_accidents
where year(Accident_date)=2022 and Accident_severity='Slight';


with Fatal as (
select sum( Number_of_Casualties) as CY_fatal_casualities from Road_accidents
where year(Accident_date)=2022 and Accident_severity='Fatal'
),
Serious as (
select sum(Number_of_Casualties) as CY_Serious_casualities from Road_accidents
where year(Accident_date)=2022 and Accident_severity='Serious'
),
Slight as (
select sum(Number_of_Casualties) as CY_Slight_casualities from Road_accidents
where year(Accident_date)=2022 and Accident_severity='Slight'
)
select * from Fatal,Serious,Slight;




--Total number of casualities
select sum(Number_of_Casualties) as Total_casualities from Road_accidents;


--Percentage(%) of Accidents that got Severity – Slight
select (count(Accident_severity)/sum(Number_of_Casualties)*100) as Slight_severity_percentage from Road_accidents
where Accident_Severity= 'Slight';


--Percentage(%) of Accidents that got Severity – Fatal
select (count(Accident_severity)/sum(Number_of_Casualties)*100) as Slight_severity_percentage from Road_accidents
where Accident_Severity= 'Fatal';

with slight as(
select cast(sum(number_of_casualties) as decimal(10,2)) * 100 /
            (select (cast(sum(number_of_casualties) as decimal(10,2))) 
             from Road_accidents) as 'Slight percentage' from road_accidents
             where accident_severity = 'Slight'
),
Fatal as (
select cast(sum(number_of_casualties) as decimal(10,2)) * 100 /
            (select (cast(sum(number_of_casualties) as decimal(10,2))) 
             from Road_accidents) as 'Fatal percentage' from road_accidents
             where accident_severity = 'Fatal'
),
Serious as (
select cast(sum(number_of_casualties) as decimal(10,2)) * 100 /
            (select (cast(sum(number_of_casualties) as decimal(10,2))) 
             from Road_accidents) as 'Serious percentage' from road_accidents
             where accident_severity = 'Serious'
)
select * from slight,Fatal,Serious;


--Total number of casualties by vehicle group
select * from Road_accidents;

select 
       case 
       when vehicle_type in ('Bus or coach (17 or more pass seats)','Minibus (8 - 16 passenger seats)','Van / Goods 3.5 tonnes mgw or under') then 'Bus'
	   when vehicle_type in ('Motorcycle 125cc and under','Motorcycle 50cc and under','Motorcycle over 125cc and up to 500cc','Motorcycle over 500cc','Pedal cycle') then 'Bike'
	   when vehicle_type in ('Car','Taxi/Private hire car') then 'Car'
	   when vehicle_type in ('Goods 7.5 tonnes mgw and over','Goods over 3.5t. and under 7.5t') then 'Truck'
	   else 'Other vehicles' end as types_of_vehicle, sum(number_of_casualties) as total_no_of_casualties   from Road_accidents
	  group by  case 
       when vehicle_type in ('Bus or coach (17 or more pass seats)','Minibus (8 - 16 passenger seats)','Van / Goods 3.5 tonnes mgw or under') then 'Bus'
	   when vehicle_type in ('Motorcycle 125cc and under','Motorcycle 50cc and under','Motorcycle over 125cc and up to 500cc','Motorcycle over 500cc','Pedal cycle') then 'Bike'
	   when vehicle_type in ('Car','Taxi/Private hire car') then 'Car'
	   when vehicle_type in ('Goods 7.5 tonnes mgw and over','Goods over 3.5t. and under 7.5t') then 'Truck'
	   else 'Other vehicles' end
	   order by total_no_of_casualties desc;


--casualties by month
select year(accident_date) as accident_year, month(accident_date) as month_of_the_year, sum(number_of_casualties) as no_of_casualties
from Road_accidents
group by month(accident_date) , year(accident_date);

--another way
select datename(month,accident_date) as 'Month' ,sum(number_of_casualties) as 'CY-casualties'
from Road_accidents
where year(accident_date) =2022
group by datename(month,accident_date);





--casualities by the type of roads
select road_type, sum(number_of_casualties) as no_of_casualties from Road_accidents
group by Road_Type;


--Area – wise Percentage(%) and Total Number of Casualties
select Urban_or_Rural_Area as Area,
  cast(sum(number_of_casualties) as decimal(10, 2)) * 100 / 
  (select cast(sum(Number_of_Casualties) as decimal(10, 2)) from Road_accidents) 
  as Percentage_of_area_of_accident from Road_accidents
group by 
  Urban_or_Rural_Area;

--Count of Casualties By Light Conditions
select Light_Conditions , count(Accident_Index) as count_of_accidents
from Road_accidents
group by Light_Conditions;
		
		
--Percentage (%) and Segregation of Casualties by Different Light Conditions
select accident_severity , light_conditions , cast(sum(number_of_casualties) as decimal(10, 2)) * 100 / 
  (select cast(sum(Number_of_Casualties) as decimal(10, 2)) from Road_accidents) 
  as Percentage_of_area_of_accident from Road_accidents
  group by Accident_Severity, Light_Conditions;

  --another way
 select case
	      when light_conditions in ('Daylight') then 'Day'
		  when light_conditions in ('Darkness - no lighting',
                                          'Darkness - lights lit',
		                            'Darkness - lights unlit', 
                                          'Darkness - lighting unknown') then 'Night'
		end as 'Light Condition',
		cast(cast(sum(number_of_casualties) as decimal(10,2)) * 100 / 
		(select cast(sum(number_of_casualties) as decimal(10,2)) 
		 from Road_accidents
		 where YEAR(accident_date) = 2022) as decimal(10,2)) as percentage_of_area_of_accident
		 from Road_accidents
		 where YEAR(accident_date) = 2022
		 group by 
		case
	      when light_conditions in ('Daylight') then 'Day'
		  when light_conditions in ('Darkness - no lighting',
                                          'Darkness - lights lit',
		                            'Darkness - lights unlit', 
                                          'Darkness - lighting unknown') then 'Night'
		end
		order by percentage_of_area_of_accident desc;





  --Top 10 Local Authority with Highest Total Number of Casualties
  select top 10 Local_Authority_District , sum(number_of_casualties) as Total_number_of_casualties
  from Road_accidents
  group by Local_Authority_District
  order by Total_number_of_casualties desc;