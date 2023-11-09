with
source_table as (
    select
        title_id,
        title,
        type,
        pub_id,
        price,
        advance,
        royalty,
        ytd_sales,
        notes,
        pubdate
    from {{ source("pubs", "pubs_titles") }}
)

select *
from source_table
