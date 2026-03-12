{{ config(materialized='table') }}

{%- set datepart = "day" -%}
{%- set start_date = "'2020-01-01'::date" -%}
{%- set end_date = "dateadd(month, 1, current_date)" -%}

WITH date_spine AS (
    {{ dbt_utils.date_spine(datepart=datepart, 
                            start_date=start_date,
                            end_date=end_date) }}
),

months as (
    select
        -- 1) Period_date (1st of month)
        date_trunc('month', date_day)::date           as period_date,

        -- 2) Period_date_MOM (15th of month)
        dateadd(
            day,
            14,                                       -- 1st + 14 days = 15th
            date_trunc('month', date_day)
        )::date                                      as period_date_mom,

        -- 3) Period_date_EOM (end of month)
        last_day(date_day)::date                      as period_date_eom
    from date_spine
    group by 1, 2, 3
),

final as (
    select
        period_date,
        period_date_mom,
        period_date_eom,
        -- 4) Days_in_Month
        datediff(day, period_date, period_date_eom) + 1 as days_in_month,
        -- 5) Offset
        -- defined how SKYGEN does it today
        -- 1 month into the future as 1 and increasing offset going backwards
        row_number() over (order by period_date desc) as offset,
    from months

)

select *
from final
order by 1