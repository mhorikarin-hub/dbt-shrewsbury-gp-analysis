with source as (

    select * from {{ ref('shrewsbury_postcodes') }}

),

renamed as (

    select
        trim(postcode) as postcode,
        cast(latitude as numeric) as latitude,
        cast(longitude as numeric) as longitude,
        cast(easting as int64) as easting,
        cast(northing as int64) as northing

    from source

)

select * from renamed