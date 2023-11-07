with

source as (

    select * from {{ source('pubs', 'pubs_sales') }}

),

renamed as (

    select
        stor_id as store_id,
        title_id,
        ord_num as order_number,
        ord_date as order_date,
        qty as quantity,
        payterms

    from source

)

select * from renamed
