TRUNCATE staging.sellers;

INSERT INTO staging.sellers
SELECT DISTINCT ON (seller_id)
    seller_id,
    seller_zip_code_prefix,
    TRIM(LOWER(seller_city)),
    TRIM(UPPER(seller_state))
FROM raw.sellers
WHERE seller_id <> ''
ORDER BY seller_id;
