use database databrick_project_db;

create or replace schema Dimension_models;

select * from databrick_project_db.gold_schema.airport_monthly_performance;         

select * from databrick_project_db.gold_schema.delay_cause_analysis;

select * from databrick_project_db.gold_schema.flight_summary_table;

select * from databrick_project_db.gold_schema.route_based_insights;

-- DIMENSION tables 
select * from Dim_origin;
select * from Dim_Airline;
select * from dim_date;

select * from fact_airport_monthly;
select * from fact_airline_dealy_cause;
select * from fact_flight_summary;

-- ============================================================================================================================================
-- CREATING DIMENSION TABLE FOR ORIGIN 
create or replace table Dim_origin(
origin_sk int autoincrement , 
origin_code varchar(5),
origin_airport_name varchar(200),
origin_city varchar(200),
origin_state varchar(200)
);

insert into Dim_origin(origin_code,origin_airport_name,origin_city,origin_state)
select 
distinct origin_code,origin_airport_name,origin_city,origin_state
from  databrick_project_db.gold_schema.airport_monthly_performance;
-- ==================================================================================================================================

-- creating  Dim table for Dim_airline 
create or replace table Dim_Airline(
Airline_sk int autoincrement , 
Airline_code varchar(5)
);

insert into Dim_Airline(Airline_code)
select distinct Airline_code
from databrick_project_db.gold_schema.delay_cause_analysis;


--==================================================================================================================================
-- creating Dimension Table for date 
create or replace table dim_date(
date_key date  primary key ,  
day_of_week integer , 
day_name varchar(10),
day_of_month integer ,
day_of_year integer ,
week_of_year integer ,
month_number integer ,
month_name  varchar(10) , 
quater integer ,
quater_name varchar(10) ,
year integer ,
is_weekend boolean ,
month_year varchar(10),
quarter_year varchar(10) ,
updated_at timestamp_ntz default current_timestamp()
);


--===================================================================================================================================
-- inserting into the  date dimension table 
--===================================================================================================================================
insert into dim_date(date_key ,day_of_week , day_name ,day_of_month , day_of_year ,  week_of_year , month_number , month_name ,quater ,
quater_name , year, is_weekend  , month_year ,quarter_year )

with date_generated as  -- created cte for getting an column of generated dates from 2023-01-01
(
select dateadd('day' , row_number() over (order by null)-1, '2023-01-01'::date ) as generated_date 
from table(generator(rowcount => 365 * 5))  -- NEED TO ASK ABOUT THIS
)

select generated_date,
extract(dayofweek from generated_date) as day_of_week ,
dayname(generated_date) as day_name,
day(generated_date) as day ,
extract(dayofyear from generated_date) as day_of_year,
extract(weekofyear from generated_date) as week_of_year ,
extract(month from generated_date) as month,
monthname(generated_date) as month_name,
extract(quarter from generated_date) as quarter ,
concat( 'Q' , (extract(quarter from generated_date)))  as quater_name ,
year(generated_date) as year,
case when (extract(dayofweek from generated_date)) not between 1 and 5 then TRUE else FALSE end  as is_weekend ,
concat(monthname(generated_date) , '-',year(generated_date)) as month_year ,
concat(concat( 'Q' , (extract(quarter from generated_date))) , '-', year(generated_date))  as quater_year
from date_generated;


select * from dim_date;



-- ==================================================================================================================================================================
-- creating DYNAMIC fact table for databrick_project_db.gold_schema.airport_monthly_performance

create or replace DYNAMIC TABLE fact_airport_year_monthly
target_lag = '1 hour'
warehouse = compute_wh
as 
select
ddo.origin_sk as origin_sk , 

-- Numerical fact Columns 
amp.flight_year as flight_year ,
amp.flight_month as flight_month ,
amp.origin_lat  as origin_lat ,
amp.origin_lon   as origin_lon ,
amp.departures   as departures ,
amp.cancelled_departures   as cancelled_departures ,
amp.avg_dep_delay   as avg_dep_delay ,
amp.dep_on_time_pct   as dep_on_time_pct ,
amp.avg_airtime  as avg_airtime ,
amp.avg_route_distance   as avg_route_distance ,
amp.airlines_operating   as airlines_operating ,
amp.unique_destinations  as unique_destinations 

from databrick_project_db.gold_schema.airport_monthly_performance  as amp
join dim_origin as ddo 
on ddo.origin_code = amp.origin_code;



--===============================================================================================================================================================
-- creating dynamic fact table for databrick_project_db.gold_schema.delay_cause_analysis

create or replace DYNAMIC Table fact_airline_dealy_cause
target_lag = '1 hour'
warehouse = compute_wh
as 
select 
da.Airline_sk, 


dca.flight_year  as  flight_year  ,
dca.flight_month  as  flight_month ,
dca.delayed_flights  as  delayed_flights ,
dca.total_delay_minutes  as  total_delay_minutes ,
dca.carrier_delay_min  as  carrier_delay_min ,
dca.weather_delay_min  as  weather_delay_min ,
dca.nas_delay_min   as  nas_delay_min ,
dca.security_delay_min  as  security_delay_min ,
dca.late_aircraft_delay_min as  late_aircraft_delay_min  ,
dca.carrier_pct  as  carrier_pct ,
dca.weather_pct  as  weather_pct ,
dca.nas_pct  as  nas_pct ,
dca.security_pct  as  security_pct ,
dca.late_aircraft_pct as  late_aircraft_pct

from databrick_project_db.gold_schema.delay_cause_analysis dca 
join dim_airline as da 
on da.airline_code = dca.airline_code;

-- ==========================================================================================================================================
-- fact dynamic  table for databrick_project_db.gold_schema.flight_summary_table 


create or replace DYNAMIC Table  fact_flight_summary 
target_lag = '1 hour'
warehouse = compute_wh
as
select 
da.Airline_sk ,

fst.flight_year  as flight_year ,
fst.flight_month  as  flight_month,
fst.total_flights  as total_flights ,
fst.total_diverted  as  total_diverted,
fst.total_cancelled  as total_cancelled ,
fst.average_delay  as average_delay ,
fst.on_time_percentage as on_time_percentage  ,
fst.carrierdelay_percentage as carrierdelay_percentage  ,
fst.weatherdelay_percentage  as weatherdelay_percentage ,
fst.nasdelay_percentage as  nasdelay_percentage ,
fst.securitydelay_percentage as securitydelay_percentage   ,
fst.lateaircraftdelay_percentage as lateaircraftdelay_percentage  

from databrick_project_db.gold_schema.flight_summary_table fst 
join dim_airline as da 
on da.airline_code = fst.airline_code;



--==============================================================================================================================================================================

select * from fact_flight_summary;