with sat_sale_detail_latest as (
    select
        sd.link_sale_store_title_hk,
        sd.order_date,
        sd.quantity,
        sd.payterms,
        RANK() over (
            partition by sd.link_sale_store_title_hk
            order by sd.load_datetime asc
        ) as asc_rank
    from {{ ref('sat_sale_detail') }} as sd
    qualify asc_rank = 1
),
sat_title_author_detail_latest as (
    select
        sd.link_title_author_hk,
        sd.author_order,
        sd.royaltyper,
        RANK() over (
            partition by sd.link_title_author_hk
            order by sd.load_datetime asc
        ) as asc_rank
    from {{ ref('sat_title_author_detail') }} as sd
    qualify asc_rank = 1
),
link_sale_store_title_src as (
    select *
    from {{ ref('link_sale_store_title') }}
),
link_title_author_src as (
    select
        link_title_author_hk,
        title_hk,
        author_hk
    from {{ ref('link_title_author') }}
),

primary_author_per_title as (
    select
        l_ta.title_hk,
        l_ta.author_hk
    from link_title_author_src as l_ta
    inner join sat_title_author_detail_latest as s_tadl
        on
            l_ta.link_title_author_hk = s_tadl.link_title_author_hk
            and s_tadl.author_order = 1
),

final as (
    select
        l_sst.link_sale_store_title_hk as fct_sales_pk,
        l_sst.store_hk as dim_store_pk,
        l_sst.title_hk as dim_title_pk,
        papt.author_hk as dim_author_primary_pk,
        l_sst.order_number,
        s_sdl.order_date,
        s_sdl.quantity,
        s_sdl.payterms,
        l_sst.load_datetime as valid_from,
        l_sst.record_source as source
    from link_sale_store_title_src as l_sst
    inner join sat_sale_detail_latest as s_sdl
        on l_sst.link_sale_store_title_hk = s_sdl.link_sale_store_title_hk
    left join primary_author_per_title as papt
        on l_sst.title_hk = papt.title_hk

)

select * from final
