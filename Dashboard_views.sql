--- Views for Power Bi Dashboards 

use database databrick_project_db;

create or replace schema Views_schema;

select * from Dimension_models.Dim_origin;
select * from Dimension_models.Dim_Airline;
select * from Dimension_models.dim_date;

select * from Dimension_models.fact_airport_monthly;
select * from Dimension_models.fact_airline_dealy_cause;
select * from Dimension_models.fact_flight_summary;


select * from vw_airline_performance;       
select * from vw_delay_trend_monthy;
select * from vw_airport_performance_map;



create or replace view vw_airline_performance
as
select 
dd.year ,
da.airline_code ,
sum(ffs.total_flights)  as total_flight, 
sum(ffs.total_cancelled)  as total_cancelled, 
avg(ffs.on_time_percentage) as total_on_time_pct,
avg(fad.total_delay_minutes ) as total_delayed_minutes,

from Dimension_models.fact_flight_summary as ffs
join Dimension_models.Dim_Airline as da 
on da.airline_sk = ffs.airline_sk

join Dimension_models.fact_airline_dealy_cause as fad
on fad.airline_sk = da.airline_sk 

join Dimension_models.dim_date dd 
on dd.year = fad.flight_year and dd.year = ffs.flight_year
group by dd.year , da.airline_code ;




-- =====================================================================================================================================
create or replace view vw_delay_trend_monthy
as
select 
concat(dd.year,'-',dd.month_number) as year_month ,
da.airline_code , 
avg(ffs.on_time_percentage) as avg_on_time_pct,

avg(fad.total_delay_minutes ) as avg_arr_delay_min,


from Dimension_models.fact_flight_summary as ffs
join Dimension_models.Dim_Airline as da 
on da.airline_sk = ffs.airline_sk

join Dimension_models.fact_airline_dealy_cause as fad
on fad.airline_sk = da.airline_sk 

join Dimension_models.dim_date dd 
on dd.year = fad.flight_year and dd.year = ffs.flight_year and dd.month_number = fad.flight_month and dd.month_number = ffs.flight_month
group by dd.year , dd.month_number , da.airline_code ;



-- ======================================================================================================================================================================
create or replace view vw_airport_performance_map
as 
select 
do.origin_code , 
do.origin_airport_name , 
do.origin_city , 
do.Origin_state ,

fam.flight_year ,
fam.FLIGHT_MONTH,
fam.ORIGIN_LAT,
fam.ORIGIN_LON,
fam.DEPARTURES,
fam.CANCELLED_DEPARTURES,
fam.AVG_DEP_DELAY,
fam.DEP_ON_TIME_PCT,
fam.AVG_AIRTIME,
fam.AVG_ROUTE_DISTANCE,
fam.AIRLINES_OPERATING,
fam.UNIQUE_DESTINATIONS

from Dimension_models.fact_airport_year_monthly as fam 
join Dimension_models.Dim_origin as do 
on do.ORIGIN_SK = fam.origin_sk;



