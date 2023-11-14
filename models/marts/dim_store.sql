--dim_store--type 1
WITH sat_store_detail_latest AS (
    SELECT
        sd.store_hk,
        sd.store_name,
        sd.store_address,
        sd.city,
        sd.state,
        sd.zip,
        RANK() OVER (
            PARTITION BY sd.store_hk
            ORDER BY sd.load_datetime ASC
        ) AS asc_rank
    FROM sat_store_detail AS sd
    QUALIFY asc_rank = 1
),

renamed AS (
    SELECT
        store_hk AS dim_store_pk,
        store_name,
        store_address,
        city AS store_city,
        state AS store_state,
        zip AS store_zip
    FROM sat_store_detail_latest
)

SELECT * FROM renamed;
