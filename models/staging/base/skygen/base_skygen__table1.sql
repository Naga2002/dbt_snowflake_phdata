{{
    config(
        database='stage',
        schema='schemadb'
    )
}}

{% set source_relation = source('skygen', 'table1') %}
{% set columns_with_aliases = [
        ["id", "id", "number", "id"]
        , ["description", "case 
                when trim(description) = '' then null
                else trim(description)
            end", "varchar", "description"]
        , ["recordupdatedatetime", "recordupdatedatetime", "timestamp_ntz", "recordupdatedatetime"]
        , ["new_col", "new_col", "varchar", "new_col"]
            ] 
%}

{% set table_exists = check_table_exists('schemadb', 'table1', 'stage') %}

{%- if table_exists %}
        with source as (
            select * from {{  source_relation }} 
        ),
        renamed as (
            {{ generate_column_select(columns_with_aliases, source_relation, table_exists) }}
        )
        select * from renamed
{% else %} 
        with source as (
            {{ generate_column_select(columns_with_aliases, source_relation, table_exists) }}
        )
        select * from source

{% endif -%}

