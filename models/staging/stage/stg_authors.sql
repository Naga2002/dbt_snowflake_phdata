{%- set yaml_metadata -%}
source_model: 'base_pubs__authors'
derived_columns:
  RECORD_SOURCE: '!BASE_PUBS__AUTHORS'
  LOAD_DATETIME: CURRENT_TIMESTAMP
hashed_columns:
  AUTHOR_HK: 'au_id'
  AUTHOR_DETAIL_HASHDIFF:
    is_hashdiff: true
    columns:
      - 'au_lname'
      - 'au_fname'
      - 'contract'
  AUTHOR_CONTACT_HASHDIFF:
    is_hashdiff: true
    columns:
      - 'au_id'
      - 'phone'
  AUTHOR_ADDRESS_HASHDIFF:
    is_hashdiff: true
    columns:
      - 'address'
      - 'city'
      - 'state'
      - 'zip'
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{% set source_model = metadata_dict['source_model'] %}

{% set derived_columns = metadata_dict['derived_columns'] %}

{% set hashed_columns = metadata_dict['hashed_columns'] %}

{{ automate_dv.stage(include_source_columns=true,
                     source_model=source_model,
                     derived_columns=derived_columns,
                     null_columns=none,
                     hashed_columns=hashed_columns,
                     ranked_columns=none) }}