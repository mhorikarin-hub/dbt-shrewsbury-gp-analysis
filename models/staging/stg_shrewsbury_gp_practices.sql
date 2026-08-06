with source as (

    select * from {{ ref('shrewsbury_gp_practices') }}

),

renamed as (

    select
        trim(gp_code) as gp_code,
        trim(gp_name) as gp_name,
        safe_cast(latitude as numeric) as latitude,
        safe_cast(longitude as numeric) as longitude,
        ST_GEOGPOINT(safe_cast(longitude as numeric), safe_cast(latitude as numeric)) as gp_location

    from source

)

select * from renamed