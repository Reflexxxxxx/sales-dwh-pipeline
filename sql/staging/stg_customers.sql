TRUNCATE staging.customers;

INSERT INTO staging.customers
SELECT DISTINCT ON (customer_id)
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    TRIM(LOWER(customer_city)),
    TRIM(UPPER(customer_state))
FROM raw.customers
WHERE customer_id <> ''
ORDER BY customer_id;
