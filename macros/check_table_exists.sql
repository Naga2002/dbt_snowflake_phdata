{% macro check_table_exists( schema_name, table_name, db_name='') %}


    {% set query %}
        select case when count(*) > 0 then true else false end as table_exists
        from {{ db_name }}.information_schema.tables
        where lower(table_schema) = '{{ schema_name }}'
        and lower(table_name) = '{{ table_name }}'
    {% endset %}

    {% set results = run_query(query) %}
    {% if execute %}
    {% if results and results.columns[0].values()[0] %}
        {% set exists = true %}
    {% else %}
        {% set exists = false %}
    {% endif %}
    {% endif %}

    {{ return(exists) }}
{% endmacro %}
