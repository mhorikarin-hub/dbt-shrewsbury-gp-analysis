with source as (

    select * from {{ ref('shrewsbury_gp_practices') }}

),

renamed as (

    select
        trim(gp_code) as gp_code,
        trim(gp_name) as gp_name,
        safe_cast(latitude as numeric) as latitude,
        safe_cast(longitude as numeric) as longitude,
        case 
            when safe_cast(latitude as numeric) is not null 
             and safe_cast(longitude as numeric) is not null 
            then ST_GEOGPOINT(safe_cast(longitude as numeric), safe_cast(latitude as numeric))
            else null
        end as gp_location

    from source

)

select * 
from renamed
where gp_code is not null