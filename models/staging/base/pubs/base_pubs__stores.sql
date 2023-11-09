with

source as (

    select * from {{ source('pubs', 'pubs_stores') }}

),

renamed as (

    select
        stor_id as store_id,
        stor_name as store_name,
        stor_address as store_address,
        city,
        state,
        zip

    from source

)

select * from renamed
