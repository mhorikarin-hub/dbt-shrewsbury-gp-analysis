with source as (

    select * from {{ ref('shrewsbury_postcodes') }}

),

renamed as (

    select
        trim(postcode) as postcode,
        safe_cast(latitude as numeric) as latitude,
        safe_cast(longitude as numeric) as longitude,
        safe_cast(easting as int64) as easting,
        safe_cast(northing as int64) as northing,

        -- Create geographic point for distance calculations
        case 
            when safe_cast(latitude as numeric) is not null 
             and safe_cast(longitude as numeric) is not null 
            then ST_GEOGPOINT(safe_cast(longitude as numeric), safe_cast(latitude as numeric))
            else null
        end as postcode_location

    from source

)

select * 
from renamed
where postcode is not null