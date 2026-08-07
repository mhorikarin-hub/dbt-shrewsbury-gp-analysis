with practices as (

    select * from {{ ref('stg_shrewsbury_gp_practices') }}

),

workforce as (

    select * from {{ ref('stg_gp_workforce') }}

),

appointments as (

    select * from {{ ref('stg_gp_appointments') }}

)

select
    -- Practice Master Information
    p.gp_code,
    p.gp_name,
    p.latitude,
    p.longitude,
    p.gp_location,
    
    -- Workforce & Demographic Metrics
    w.total_patients,
    w.gp_fte,
    w.patients_per_gp_fte,
    w.over65_count,
    w.over65_pct,
    
    -- Appointment Metrics
    a.total_appointments,
    a.wait_over_2weeks_count,
    a.wait_over_2weeks_pct,
    a.dna_count,
    a.dna_rate_pct

from practices p
left join workforce w 
    on p.gp_code = w.practice_code
left join appointments a 
    on p.gp_code = a.practice_code