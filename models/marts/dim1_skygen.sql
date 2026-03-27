{{ config(
    materialized='incremental',
    unique_key='dim1key',
    incremental_strategy='merge',
    on_schema_change='append_new_columns'
) }}

WITH source_data AS (
    SELECT
    {{ dbt_utils.generate_surrogate_key([
  	'id',
  ]) }} as dim1key,
        id,
        description AS col1,
        recordupdatedatetime
    FROM {{ ref('base_skygen__table1') }}
    {% if is_incremental() %}
    --instead of variables, this could grab the max timestamp from the target Dim1 table
        WHERE
            recordupdatedatetime
            > (SELECT max(recordupdatedatetime) FROM {{ this }})
    {% endif %}
),

existing_records AS (
    {% if is_incremental() %}
        SELECT
            dim1key,
            id,
            col1,
            recordcreatedatetime,
            recordupdatedatetime,
            recordenddate,
            recordiscurrent
        FROM {{ this }}
        WHERE recordiscurrent = 1
    {% else %}
    SELECT 
      NULL AS dim1key,
      NULL AS ID,
      NULL AS Col1,
      NULL AS RecordCreateDatetime,
      NULL AS RecordUpdateDatetime,
      NULL AS RecordEndDate,
      NULL AS RecordIsCurrent
    WHERE 1=0  -- Empty result set for full refresh
  {% endif %}
),

new_records AS (
    SELECT
        s.dim1key,
        s.id,
        s.col1,
        cast('2199-12-31' AS DATE) AS recordenddate,
        current_timestamp AS recordcreatedatetime,
        current_timestamp AS recordupdatedatetime,
        1 AS recordiscurrent,
    FROM source_data AS s
    LEFT JOIN existing_records AS e ON s.id = e.id
    WHERE e.id IS NULL
),

updated_records AS (
    SELECT
        s.dim1key,
        s.id,
        s.col1,
        e.recordcreatedatetime,
        cast('2199-12-31' AS DATE) AS recordenddate,
        current_timestamp AS recordupdatedatetime,
        e.RecordIsCurrent
    FROM source_data AS s
    INNER JOIN existing_records AS e ON s.id = e.id
    WHERE
        coalesce(s.col1, '') <> coalesce(e.col1, '')
),

records_to_expire AS (
    SELECT
        e.dim1key,
        e.id,
        e.col1,
        e.recordcreatedatetime,
        current_timestamp AS recordupdatedatetime,
        current_date AS recordenddate,
        0 AS recordiscurrent,
    FROM existing_records AS e
    LEFT JOIN source_data AS s ON e.id = s.id
    WHERE
        s.id IS NULL
        AND e.id > -1
),

final AS (
    SELECT * FROM new_records
    UNION ALL
    SELECT * FROM updated_records
    UNION ALL
    SELECT * FROM records_to_expire
)

SELECT
    dim1key,
    id,
    col1,
    recordcreatedatetime,
    recordupdatedatetime,
    recordenddate,
    recordiscurrent
FROM final
