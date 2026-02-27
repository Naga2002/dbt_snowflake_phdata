{% macro generate_column_select(columns_with_aliases, source_relation, does_table_exist) %}

{# get client columns from the source table and store as a list of column names#}
{%- set source_columns = adapter.get_columns_in_relation(source_relation) -%}
{%- set source_column_names = source_columns | map(attribute='name') | list -%}

{# format template columns into a dictionary object called columns_model #}
{%- set columns_model = {} -%}
{%- for column_with_alias in columns_with_aliases %}
    {%- set column_name = column_with_alias[0] | upper -%}
    {%- set column_transformation = column_with_alias[1] -%}
    {%- set column_datatype = column_with_alias[2] -%}
    {%- set column_alias = column_with_alias[3] -%}
    {%- set _ = columns_model.update({
        column_name: {
            "transformation": column_transformation,
            "datatype": column_datatype,
            "alias": column_alias
        }
    }) -%}
{%- endfor -%}

{# {{log(column_models, info=True)}} #}
{% set base_model_sql %}
    select
        {# iterate through template columns.  If template column is not in client column, set values as null. #}
        {%- for column, values in columns_model.items() %}
            {% if values['datatype'] is not none %}
                {% if column in source_column_names -%}
                {{values['transformation'] }}::{{values['datatype']}} as {{ values['alias'] }}{{"," if not loop.last }}
                {%- else -%}
                NULL::{{values['datatype']}} as {{ values['alias'] }}{{"," if not loop.last }}
                {% endif %}
            {% else %}
                {% if column in source_column_names -%}
                {{values['transformation'] }} as {{ values['alias'] }}{{"," if not loop.last }}
                {%- else -%}
                NULL as {{ values['alias'] }}{{"," if not loop.last }}
                {% endif %}
            {% endif %}
        {%- endfor %}
    {% if does_table_exist %}
    from {{ source_relation }}
    {% endif %}

{%- endset -%}

{%- if execute %}
    {# {{- log(base_model_sql, info=True) -}} #}
    {%- do return(base_model_sql) -%}
{% endif -%}
{% endmacro %}
