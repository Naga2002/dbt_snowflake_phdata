{%- set source_model = "stg_titleauthor" -%}
{%- set src_pk = "LINK_TITLE_AUTHOR_HK" -%}
{%- set src_fk = ["TITLE_HK", "AUTHOR_HK"] -%}
{%- set src_ldts = "LOAD_DATETIME" -%}
{%- set src_source = "RECORD_SOURCE" -%}

{{ automate_dv.link(src_pk=src_pk, src_fk=src_fk, src_ldts=src_ldts,
                    src_source=src_source, source_model=source_model) }}
