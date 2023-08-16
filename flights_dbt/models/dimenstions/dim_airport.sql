{{ config(materialized='table',unique_key='airport_code') }}

select   a.airport_code
		,replace(cast(a.airport_name -> 'en' as varchar(40)), '"' ,'') as airport_name_en
		,replace(cast(a.airport_name -> 'ru' as varchar(40)), '"' ,'') as airport_name_ru
		,replace(cast(a.city -> 'en' as varchar(40)), '"' ,'') as city_name_en
		,replace(cast(a.city -> 'ru' as varchar(40)), '"' ,'') as city_name_ru
		,a.coordinates
		,a.timezone
        ,'{{ run_started_at.strftime ("%Y-%m-%d %H:%M:%S")}}'::timestamp as dbt_time
from stg.airports_data a