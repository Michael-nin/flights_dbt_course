{{ config(materialized='incremental',unique_key='flight_id') }}

with flights_duration_table as
		(select  *
			   ,round(extract(epoch from (actual_arrival - actual_departure))/3600,2) as flight_duration
			   ,round(extract(epoch from (scheduled_arrival - scheduled_departure))/3600,2) as flight_duration_expected
			   ,'{{ run_started_at.strftime ("%Y-%m-%d %H:%M:%S")}}'::timestamp as dbt_time
		 from stg.flights)
select   *
		,case 
			when flight_duration = flight_duration_expected then 'as expected'
			when flight_duration < flight_duration_expected then 'longer'
			when flight_duration > flight_duration_expected then 'shorter'
			else null
		 end as is_as_expected
from flights_duration_table