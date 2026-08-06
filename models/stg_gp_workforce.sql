with source as (
    select * from {{ ref('raw_gp_workforce') }}
)

select
    cast(prac_code as string) as practice_code,
    cast(prac_name as string) as practice_name,
    
    -- 人員・患者数の型キャスト
    cast(total_patients as int64) as total_patients,
    cast(total_gp_fte as float64) as gp_fte,
    cast(total_nurses_fte as float64) as nurse_fte,
    cast(total_dpc_fte as float64) as dpc_fte,
    cast(total_admin_fte as float64) as admin_fte,
    
    -- 【指標計算】GP1人あたりの患者数（safe_divideで0除算を防止）
    safe_divide(cast(total_patients as float64), cast(total_gp_fte as float64)) as patients_per_gp_fte,

    -- 【デモグラ集計】65歳以上の患者数合計
    (
        cast(male_patients_65to74 as int64) + cast(male_patients_75to84 as int64) + cast(male_patients_85plus as int64) +
        cast(female_patients_65to74 as int64) + cast(female_patients_75to84 as int64) + cast(female_patients_85plus as int64)
    ) as over65_count,

    -- 【指標計算】65歳以上の患者割合 (%)
    safe_divide(
        (
            cast(male_patients_65to74 as float64) + cast(male_patients_75to84 as float64) + cast(male_patients_85plus as float64) +
            cast(female_patients_65to74 as float64) + cast(female_patients_75to84 as float64) + cast(female_patients_85plus as float64)
        ) * 100.0,
        cast(total_patients as float64)
    ) as over65_pct

from source