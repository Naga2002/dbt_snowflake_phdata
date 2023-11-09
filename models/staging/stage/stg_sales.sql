{%- set yaml_metadata -%}
source_model: 'base_pubs__sales'
derived_columns:
  RECORD_SOURCE: '!BASE_PUBS__SALES'
  LOAD_DATETIME: CURRENT_TIMESTAMP
hashed_columns:
  ORDER_HK: 'order_number'
  STORE_HK: 'store_id'
  TITLE_HK: 'title_id'
  LINK_SALE_STORE_TITLE_HK:
    - 'order_number' 
    - 'store_id'
    - 'title_id'
  SALE_DETAIL_HASHDIFF:
    is_hashdiff: true
    columns:
      - 'order_date'
      - 'quantity'
      - 'payterms'   
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