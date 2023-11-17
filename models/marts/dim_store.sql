--dim_store--type 1
WITH hub_store_src AS (
    SELECT
        store_hk,
        store_id,
        record_source
    FROM {{ ref('hub_store') }}
),

sat_store_detail_latest AS (
    SELECT
        sd.store_hk,
        sd.store_name,
        sd.store_address,
        sd.city,
        sd.state,
        sd.zip,
        sd.load_datetime,
        RANK() OVER (
            PARTITION BY sd.store_hk
            ORDER BY sd.load_datetime ASC
        ) AS asc_rank
    FROM {{ ref('sat_store_detail') }} AS sd
    QUALIFY asc_rank = 1
),

renamed AS (
    SELECT
        h_s.store_hk AS dim_store_pk,
        h_s.store_id,
        s_sdl.store_name,
        s_sdl.store_address,
        s_sdl.city AS store_city,
        s_sdl.state AS store_state,
        s_sdl.zip AS store_zip,
        s_sdl.load_datetime AS valid_from,
        h_s.record_source AS source
    FROM hub_store_src AS h_s
    INNER JOIN sat_store_detail_latest AS s_sdl
        ON h_s.store_hk = s_sdl.store_hk
)

SELECT * FROM renamed;
