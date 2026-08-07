with source as (

    select * from {{ ref('raw_gp_workforce') }}

)

select
    cast(prac_code as string) as practice_code,
    cast(prac_name as string) as practice_name,
    
    -- Cast metrics and FTE counts
    cast(total_patients as int64) as total_patients,
    cast(total_gp_fte as float64) as gp_fte,
    cast(total_nurses_fte as float64) as nurse_fte,
    cast(total_dpc_fte as float64) as dpc_fte,
    cast(total_admin_fte as float64) as admin_fte,
    
    -- Metric: Patients per GP FTE (Prevent division by zero using safe_divide)
    safe_divide(cast(total_patients as float64), cast(total_gp_fte as float64)) as patients_per_gp_fte,

    -- Demographics: Total patients aged 65 and over (coalesce handles nulls)
    (
        coalesce(cast(male_patients_65to74 as int64), 0) + 
        coalesce(cast(male_patients_75to84 as int64), 0) + 
        coalesce(cast(male_patients_85plus as int64), 0) +
        coalesce(cast(female_patients_65to74 as int64), 0) + 
        coalesce(cast(female_patients_75to84 as int64), 0) + 
        coalesce(cast(female_patients_85plus as int64), 0)
    ) as over65_count,

    -- Metric: Percentage of patients aged 65 and over (%)
    safe_divide(
        (
            coalesce(cast(male_patients_65to74 as float64), 0) + 
            coalesce(cast(male_patients_75to84 as float64), 0) + 
            coalesce(cast(male_patients_85plus as float64), 0) +
            coalesce(cast(female_patients_65to74 as float64), 0) + 
            coalesce(cast(female_patients_75to84 as float64), 0) + 
            coalesce(cast(female_patients_85plus as float64), 0)
        ) * 100.0,
        cast(total_patients as float64)
    ) as over65_pct

from source