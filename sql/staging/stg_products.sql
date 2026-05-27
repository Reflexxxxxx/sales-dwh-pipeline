TRUNCATE staging.products;

INSERT INTO staging.products
SELECT DISTINCT ON (p.product_id)
    p.product_id,
    NULLIF(p.product_category_name, ''),
    t.product_category_name_english,
    NULLIF(p.product_name_lenght, '')::INTEGER,
    NULLIF(p.product_description_lenght, '')::INTEGER,
    NULLIF(p.product_photos_qty, '')::INTEGER,
    NULLIF(p.product_weight_g, '')::NUMERIC(10,2),
    NULLIF(p.product_length_cm, '')::NUMERIC(10,2),
    NULLIF(p.product_height_cm, '')::NUMERIC(10,2),
    NULLIF(p.product_width_cm, '')::NUMERIC(10,2)
FROM raw.products p
LEFT JOIN raw.product_category_name_translation t
    ON p.product_category_name = t.product_category_name
WHERE p.product_id <> ''
ORDER BY p.product_id;
