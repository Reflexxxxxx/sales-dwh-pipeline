TRUNCATE staging.order_payments;

INSERT INTO staging.order_payments
SELECT
    order_id,
    NULLIF(payment_sequential, '')::INTEGER,
    payment_type,
    NULLIF(payment_installments, '')::INTEGER,
    NULLIF(payment_value, '')::NUMERIC(10,2)
FROM raw.order_payments
WHERE order_id <> '';
