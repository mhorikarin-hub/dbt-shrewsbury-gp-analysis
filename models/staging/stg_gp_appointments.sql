with source as (
    select * from {{ ref('raw_gp_appointments') }}
),

aggregated as (
    select
        cast(gp_code as string) as practice_code,
        
        -- 総予約件数の合計
        sum(cast(count_of_appointments as int64)) as total_appointments,
        
        -- 2週間（15日）以上の予約待ち件数の合計
        sum(
            case 
                when time_between_book_and_appt in ('15 to 28 Days', 'More than 28 Days', '15_to_28_days', '28_plus_days') 
                then cast(count_of_appointments as int64)
                else 0 
            end
        ) as wait_over_2weeks_count,
        
        -- DNA (無断キャンセル) 件数の合計
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
    
    -- 【指標計算】2週間超え予約待ち率 (%)
    safe_divide(
        cast(wait_over_2weeks_count as float64) * 100.0, 
        cast(total_appointments as float64)
    ) as wait_over_2weeks_pct,
    
    -- 【指標計算】無断キャンセル(DNA)率 (%)
    safe_divide(
        cast(dna_count as float64) * 100.0, 
        cast(total_appointments as float64)
    ) as dna_rate_pct

from aggregated