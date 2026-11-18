create or replace database databrick_project_db;

create or replace schema Gold_schema;

show tables;

select * from delay_cause_analysis;
select * from airport_monthly_performance;
select * from flight_summary_table;     
select * from route_based_insights;     

-- ===========================================================================================================================================================
 -- creating table for delay_cause_analysis
-- data been imported from Databricks Dataframe to Snowflake Table 
CREATE OR REPLACE  TABLE  delay_cause_analysis (
    flight_year INT,
    flight_month INT,
    airline_code VARCHAR(3),
    delayed_flights BIGINT,
    total_delay_minutes FLOAT,
    carrier_delay_min FLOAT,
    weather_delay_min FLOAT,
    nas_delay_min FLOAT,
    security_delay_min FLOAT,
    late_aircraft_delay_min FLOAT,
    carrier_pct FLOAT,
    weather_pct FLOAT,
    nas_pct FLOAT,
    security_pct FLOAT,
    late_aircraft_pct FLOAT,
    gold_processed_ts TIMESTAMP_NTZ
);

select * from delay_cause_analysis;


--==================================--==================================--==================================--==================================
   -- creating table for airport_monthly_performance
-- data been imported from Databricks Dataframe to Snowflake Table 

   CREATE OR REPLACE TABLE airport_monthly_performance(
    flight_year INT,
    flight_month INT,
    year_month VARCHAR(7),
    airport_code varchar(5),
    origin_code VARCHAR(3),
    origin_airport_name VARCHAR(200),
    origin_city VARCHAR(100),
    origin_state VARCHAR(100),
    origin_lat FLOAT,
    origin_lon FLOAT,
    departures BIGINT,
    cancelled_departures BIGINT,
    avg_dep_delay FLOAT,
    dep_on_time_pct FLOAT,
    avg_airtime FLOAT,
    avg_route_distance FLOAT,
    airlines_operating INT,
    unique_destinations INT,
    gold_processed_ts TIMESTAMP_NTZ default current_timestamp());

    select * from airport_monthly_performance;



--======================================================================================================================================================================
-- creating table for flight_summary_table
-- data been imported from Databricks Dataframe to Snowflake Table 

CREATE OR REPLACE TABLE flight_summary_table (
    flight_year INT,
    flight_month INT,
    airline_code VARCHAR,
    total_flights NUMBER,
    total_diverted NUMBER,
    total_cancelled NUMBER,
    Average_delay FLOAT,
    on_time_percentage FLOAT,
    carrierdelay_percentage FLOAT,
    weatherdelay_percentage FLOAT,
    nasdelay_percentage FLOAT,
    securitydelay_percentage FLOAT,
    lateaircraftdelay_percentage FLOAT
);

select * from flight_summary_table;


-- =======================================================================================================================================
-- creating table for route based insight 
-- data been imported from Databricks Dataframe to Snowflake Table 

CREATE OR REPLACE TABLE route_based_insights (
    flight_year INT,
    route VARCHAR,
    total_flights NUMBER,
    avg_dep_delay FLOAT,
    avg_arr_delay FLOAT,
    total_cancelled NUMBER,
    avg_distance FLOAT
);

select * from route_based_insights;