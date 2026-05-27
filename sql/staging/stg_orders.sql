TRUNCATE staging.orders;

INSERT INTO staging.orders
SELECT DISTINCT ON (order_id)
    order_id,
    customer_id,
    order_status,
    NULLIF(order_purchase_timestamp, '')::TIMESTAMP,
    NULLIF(order_approved_at, '')::TIMESTAMP,
    NULLIF(order_delivered_carrier_date, '')::TIMESTAMP,
    NULLIF(order_delivered_customer_date, '')::TIMESTAMP,
    NULLIF(order_estimated_delivery_date, '')::TIMESTAMP
FROM raw.orders
WHERE order_id <> ''
ORDER BY order_id;
