with
source as (

    select * from {{ source('pubs', 'pubs_titleauthor') }}

),

renamed as (

    select
        au_id,
        title_id,
        au_ord as author_order,
        royaltyper

    from source

)

select * from renamed
