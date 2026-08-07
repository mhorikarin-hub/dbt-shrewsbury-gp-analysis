with postcodes as (

    select * from {{ ref('stg_shrewsbury_postcodes') }}

),

gp_practices as (

    select * from {{ ref('stg_shrewsbury_gp_practices') }}

),

gp_surveys as (

    select * from {{ ref('stg_gp_survey') }}

),

-- Join GP basic info with patient satisfaction survey metrics
gp_with_survey as (

    select
        g.gp_code,
        g.gp_name,
        g.latitude,
        g.longitude,
        g.gp_location,
        s.overall_good_pct,
        s.phone_very_easy_pct,
        s.web_very_easy_pct,
        s.app_very_easy_pct,
        s.reception_very_helpful_pct,
        s.online_booking_pct

    from gp_practices g
    left join gp_surveys s
        on g.gp_code = s.gp_code

),

-- Cross join all postcodes and GP practices to calculate distances
calculated_distances as (

    select
        p.postcode,
        p.latitude as postcode_lat,
        p.longitude as postcode_long,
        g.gp_code,
        g.gp_name,
        g.latitude as gp_lat,
        g.longitude as gp_long,
        g.overall_good_pct,
        g.phone_very_easy_pct,
        g.web_very_easy_pct,
        g.app_very_easy_pct,
        g.reception_very_helpful_pct,
        g.online_booking_pct,
        
        -- Calculate distance using geographic points
        ST_DISTANCE(
            coalesce(p.postcode_location, ST_GEOGPOINT(p.longitude, p.latitude)),
            g.gp_location
        ) as distance_meters

    from postcodes p
    cross join gp_with_survey g

),

-- Rank nearest GP practices (1 to 3) per postcode
ranked_distances as (

    select
        *,
        row_number() over (
            partition by postcode
            order by distance_meters asc
        ) as rank_nearest

    from calculated_distances

)

-- Output long-format dataset (Top 3 nearest GP practices per postcode)
select
    postcode,
    postcode_lat,
    postcode_long,
    rank_nearest as rank,  -- Rank column (1, 2, 3)
    gp_code,
    gp_name,
    gp_lat,
    gp_long,
    round(distance_meters / 1000.0, 2) as distance_km,
    overall_good_pct,
    phone_very_easy_pct,
    web_very_easy_pct,
    app_very_easy_pct,
    reception_very_helpful_pct,
    online_booking_pct

from ranked_distances
where rank_nearest <= 3
order by postcode, rank