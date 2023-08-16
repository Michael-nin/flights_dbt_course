{{ config(materialized='incremental',unique_key='ticket_no') }}

select  tf.*
	   ,bp.boarding_no
	   ,bp.seat_no
	   ,'{{ run_started_at.strftime ("%Y-%m-%d %H:%M:%S")}}'::timestamp as dbt_time
from stg.ticket_flights tf 
	 left join stg.boarding_passes bp on  tf.ticket_no = bp.ticket_no 
	 								  and tf.flight_id = bp.flight_id