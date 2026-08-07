with source as (

    select * from {{ ref('raw_gp_appointments') }}

),

aggregated as (

    select
        cast(gp_code as string) as practice_code,
        
        -- Total number of appointments
        sum(cast(count_of_appointments as int64)) as total_appointments,
        
        -- Appointments waiting over 2 weeks (15+ days)
        sum(
            case 
                when time_between_book_and_appt in ('15 to 28 Days', 'More than 28 Days', '15_to_28_days', '28_plus_days') 
                then cast(count_of_appointments as int64)
                else 0 
            end
        ) as wait_over_2weeks_count,
        
        -- Did Not Attend (DNA / Unattended) appointment count
        sum(
            case 
                when appt_status in ('DNA', 'Did Not Attend') 
                then cast(count_of_appointments as int64)
                else 0 
            end
        ) as dna_count

    from source
    group by 1

)

select
    practice_code,
    total_appointments,
    wait_over_2weeks_count,
    dna_count,
    
    -- Metrics: Percentage of appointments waiting over 2 weeks (%)
    safe_divide(
        cast(wait_over_2weeks_count as float64) * 100.0, 
        cast(total_appointments as float64)
    ) as wait_over_2weeks_pct,
    
    -- Metrics: DNA (Did Not Attend) rate (%)
    safe_divide(
        cast(dna_count as float64) * 100.0, 
        cast(total_appointments as float64)
    ) as dna_rate_pct

from aggregated