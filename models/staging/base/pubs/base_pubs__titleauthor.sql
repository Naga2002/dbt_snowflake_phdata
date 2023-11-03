with
source_table as (
    select
        au_id,
        title_id,
        au_ord,
        royaltyper
    from {{ source("pubs", "pubs_titleauthor") }}
)

select *
from source_table