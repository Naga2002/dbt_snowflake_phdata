{%- set source_model = "stg_authors" -%}
{%- set src_pk = "AUTHOR_HK" -%}
{%- set src_hashdiff = "AUTHOR_DETAIL_HASHDIFF" -%}
{%- set src_payload = ['au_lname', 'au_fname', 'contract'] -%}
{%- set src_ldts = "LOAD_DATETIME" -%}
{%- set src_source = "RECORD_SOURCE" -%}

{{ automate_dv.sat(src_pk=src_pk, src_hashdiff=src_hashdiff,
                   src_payload=src_payload, src_eff=src_eff,
                   src_ldts=src_ldts, src_source=src_source,
                   source_model=source_model) }}
