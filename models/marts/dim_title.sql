--dim_title type 1
WITH hub_title_src AS (
    SELECT
        title_hk,
        title_id,
        record_source
    FROM {{ ref('hub_title') }}
),

sat_title_detail_latest AS (
    SELECT
        sd.title_hk,
        sd.title,
        sd.type,
        sd.notes,
        sd.load_datetime,
        RANK() OVER (
            PARTITION BY sd.title_hk
            ORDER BY sd.load_datetime ASC
        ) AS asc_rank
    FROM {{ ref('sat_title_detail') }} AS sd
    QUALIFY asc_rank = 1
),

sat_title_metric_latest AS (
    SELECT
        sd.title_hk,
        sd.price,
        sd.advance,
        sd.royalty,
        sd.load_datetime,
        RANK() OVER (
            PARTITION BY sd.title_hk
            ORDER BY sd.load_datetime ASC
        ) AS asc_rank
    FROM {{ ref('sat_title_metric') }} AS sd
    QUALIFY asc_rank = 1
),

renamed AS (
    SELECT
        h_t.title_hk AS dim_title_pk,
        h_t.title_id,
        s_tdl.title,
        s_tdl.type,
        s_tml.price,
        s_tml.advance,
        s_tml.royalty,
        s_tdl.notes,
        GREATEST(s_tdl.load_datetime, s_tml.load_datetime) AS valid_from,        
        h_t.record_source AS source
    FROM hub_title_src AS h_t
    INNER JOIN sat_title_detail_latest AS s_tdl
        ON h_t.title_hk = s_tdl.title_hk
    INNER JOIN sat_title_metric_latest AS s_tml
        ON s_tdl.title_hk = s_tml.title_hk
)

SELECT * FROM renamed;
