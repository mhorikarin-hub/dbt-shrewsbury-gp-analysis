with source as (

    select * from {{ ref('gp_survey') }}

),

renamed as (

    select
        trim(gp_code) as gp_code,
        trim(gp_name) as gp_name,

        -- 総合評価
        safe_cast(gp_overall_good_total_pct as numeric) as overall_good_pct,

        -- 電話の使いやすさ (very easy)
        safe_cast(gp_phone_very_easy_pct as numeric) as phone_very_easy_pct,

        -- Webの使いやすさ (very easy)
        safe_cast(gp_web_very_easy_pct as numeric) as web_very_easy_pct,

        -- アプリの使いやすさ (very easy)
        safe_cast(gp_app_very_easy_pct as numeric) as app_very_easy_pct,

        -- 受付の親切さ (very helpful)
        safe_cast(gp_reception_very_helpful_pct as numeric) as reception_very_helpful_pct,

        -- オンライン予約利用率
        safe_cast(gp_online_booking_pct as numeric) as online_booking_pct

    from source

)

select * from renamed