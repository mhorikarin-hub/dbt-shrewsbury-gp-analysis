with source as (

    select * from {{ ref('gp_survey') }}

),

renamed as (

    select
        trim(gp_code) as gp_code,
        trim(gp_name) as gp_name,

        -- Overall satisfaction (%)
        safe_cast(gp_overall_good_total_pct as numeric) as overall_good_pct,

        -- Phone ease of use (% very easy)
        safe_cast(gp_phone_very_easy_pct as numeric) as phone_very_easy_pct,

        -- Website ease of use (% very easy)
        safe_cast(gp_web_very_easy_pct as numeric) as web_very_easy_pct,

        -- NHS App ease of use (% very easy)
        safe_cast(gp_app_very_easy_pct as numeric) as app_very_easy_pct,

        -- Receptionist helpfulness (% very helpful)
        safe_cast(gp_reception_very_helpful_pct as numeric) as reception_very_helpful_pct,

        -- Online booking usage rate (%)
        safe_cast(gp_online_booking_pct as numeric) as online_booking_pct

    from source

)

select * 
from renamed
where gp_code is not null