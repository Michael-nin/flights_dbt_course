{{ config(materialized='table',unique_key='aircraft_code') }}

select   a.aircraft_code
		,replace(cast(a.model -> 'en' as varchar(40)),'"','') as model_english
		,replace(cast(a.model -> 'ru' as varchar(40)),'"','') as model_russian
		,a."range"
		,case when range >= 5600 then 'high'
			  when range <  5600 then 'low'
		 end as range_definition 
		,a.last_update 
	    ,s.seat_no
	    ,s.fare_conditions
	    ,'{{ run_started_at.strftime ("%Y-%m-%d %H:%M:%S")}}'::timestamp as dbt_time
from stg.aircrafts_data a 
	 join stg.seats s on s.aircraft_code = a.aircraft_code