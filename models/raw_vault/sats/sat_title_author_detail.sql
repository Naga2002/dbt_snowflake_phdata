{%- set source_model = "stg_titleauthor" -%}
{%- set src_pk = "LINK_TITLE_AUTHOR_HK" -%}
{%- set src_hashdiff = "TITLE_AUTHOR_DETAIL_HASHDIFF" -%}
{%- set src_payload = ['author_order', 'royaltyper'] -%}
{%- set src_ldts = "LOAD_DATETIME" -%}
{%- set src_source = "RECORD_SOURCE" -%}

{{ automate_dv.sat(src_pk=src_pk, src_hashdiff=src_hashdiff,
                   src_payload=src_payload, src_eff=src_eff,
                   src_ldts=src_ldts, src_source=src_source,
                   source_model=source_model) }}
