with
source_table as (
    select
        au_id,
        au_lname,
        au_fname,
        phone,
        address,
        city,
        state,
        zip,
        contract
    from {{ source("pubs", "pubs_authors") }}
)

select *
from source_table
