{{ config(materialized='incremental',unique_key='book_ref') }}

select   b.*
		,t.passenger_id
		,t.passenger_name
		,replace(cast(t.contact_data -> 'email' as varchar(40)), '"' ,'') as email
		,replace(cast(t.contact_data -> 'phone' as varchar(40)), '"' ,'') as phone
		,last_update
		,'{{ run_started_at.strftime ("%Y-%m-%d %H:%M:%S")}}'::timestamp as dbt_time
from stg.bookings as b
	 left join stg.tickets t on b.book_ref = t.book_ref