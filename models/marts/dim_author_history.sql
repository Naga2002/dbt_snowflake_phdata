--dim_author_history type 2
WITH hub_author_src AS (
    SELECT
        author_hk,
        au_id,
        record_source
    FROM {{ ref('hub_author') }}
),

pit_author_src AS (
    SELECT
        author_hk,
        as_of_date,
        sat_author_detail_pk,
        sat_author_detail_ldts,
        sat_author_contact_pk,
        sat_author_contact_ldts,
        sat_author_address_pk,
        sat_author_address_ldts
    FROM {{ ref('pit_author') }}
),

sat_author_detail_src AS (
    SELECT
        author_hk,
        au_lname,
        au_fname,
        contract,
        load_datetime AS sat_author_detail_ldts
    FROM {{ ref('sat_author_detail') }}
),

sat_author_contact_src AS (
    SELECT
        author_hk,
        phone,
        load_datetime AS sat_author_contact_ldts
    FROM {{ ref('sat_author_contact') }}
),

sat_author_address_src AS (
    SELECT
        author_hk,
        address,
        city,
        state,
        zip,
        load_datetime AS sat_author_address_ldts
    FROM {{ ref('sat_author_address') }}
),

renamed AS (
    SELECT
        h_a.au_id AS author_id,
        p_a.as_of_date AS valid_from,
        CAST(MD5_BINARY(NULLIF(CONCAT_WS(
            '||',
            COALESCE(
                NULLIF(UPPER(TRIM(CAST(p_a.author_hk AS VARCHAR))), ''), '^^'
            ),
            COALESCE(
                NULLIF(UPPER(TRIM(CAST(p_a.as_of_date AS VARCHAR))), ''), '^^'
            )
        ), '^^||^^')) AS BINARY(16)) AS dim_author_history_pk,
        LEAD(p_a.as_of_date, 1, '2999-01-01')
            OVER (PARTITION BY p_a.author_hk ORDER BY p_a.as_of_date)
            AS valid_to,        
        s_ad.au_lname AS author_lastname,
        s_ad.au_fname AS author_firstname,
        s_ad.contract AS author_contract,
        s_ac.phone AS author_phone,
        s_aa.address AS author_address,
        s_aa.city AS author_city,
        s_aa.state AS author_state,
        s_aa.zip AS author_zip

    FROM hub_author_src AS h_a
    INNER JOIN pit_author_src AS p_a ON h_a.author_hk = p_a.author_hk
    INNER JOIN sat_author_detail_src AS s_ad
        ON
            p_a.author_hk = s_ad.author_hk
            AND p_a.sat_author_detail_ldts = s_ad.sat_author_detail_ldts
    INNER JOIN sat_author_contact_src AS s_ac
        ON
            p_a.author_hk = s_ac.author_hk
            AND p_a.sat_author_contact_ldts = s_ac.sat_author_contact_ldts
    INNER JOIN sat_author_address_src
        AS s_aa ON p_a.author_hk = s_aa.author_hk
    AND p_a.sat_author_address_ldts = s_aa.sat_author_address_ldts

)

SELECT * FROM renamed
