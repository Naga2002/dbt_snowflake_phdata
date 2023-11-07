{%- set source_model = "stg_sales" -%}
{%- set src_pk = "LINK_SALE_STORE_TITLE_HK" -%}
{%- set src_fk = ["STORE_HK", "TITLE_HK"] -%}
{%- set src_ldts = "LOAD_DATETIME" -%}
{%- set src_source = "RECORD_SOURCE" -%}

{{ automate_dv.link(src_pk=src_pk, src_fk=src_fk, src_ldts=src_ldts,
                    src_source=src_source, source_model=source_model) }}
