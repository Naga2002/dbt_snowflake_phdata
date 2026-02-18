with

source as (

    select * from {{ source('skygen', 'table1') }}

),

renamed as (

    select
        id,
        description,
        recordupdatedatetime

    from source

)

select * from renamed
