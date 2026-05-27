TRUNCATE staging.order_items;

INSERT INTO staging.order_items
SELECT
    order_id,
    NULLIF(order_item_id, '')::INTEGER,
    product_id,
    seller_id,
    NULLIF(shipping_limit_date, '')::TIMESTAMP,
    NULLIF(price, '')::NUMERIC(10,2),
    NULLIF(freight_value, '')::NUMERIC(10,2)
FROM raw.order_items
WHERE order_id <> '';
