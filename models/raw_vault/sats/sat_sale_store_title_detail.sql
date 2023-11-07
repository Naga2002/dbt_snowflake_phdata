{%- set source_model = "stg_sales" -%}
{%- set src_pk = "LINK_SALE_STORE_TITLE_HK" -%}
{%- set src_hashdiff = "SALE_STORE_TITLE_DETAIL_HASHDIFF" -%}
{%- set src_payload = ['order_number', 'order_date', 'quantity', 'payterms'] -%}
{%- set src_ldts = "LOAD_DATETIME" -%}
{%- set src_source = "RECORD_SOURCE" -%}

{{ automate_dv.sat(src_pk=src_pk, src_hashdiff=src_hashdiff,
                   src_payload=src_payload, src_eff=src_eff,
                   src_ldts=src_ldts, src_source=src_source,
                   source_model=source_model) }}

