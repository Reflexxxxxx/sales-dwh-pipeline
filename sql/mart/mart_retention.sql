TRUNCATE mart.retention;

INSERT INTO mart.retention
WITH first_orders AS (
    SELECT
        c.customer_unique_id,
        DATE_TRUNC('month', MIN(o.order_purchase_timestamp))::DATE AS cohort_month
    FROM staging.orders o
    JOIN staging.customers c ON o.customer_id = c.customer_id
    WHERE o.order_purchase_timestamp IS NOT NULL
    GROUP BY 1
),
order_months AS (
    SELECT DISTINCT
        c.customer_unique_id,
        DATE_TRUNC('month', o.order_purchase_timestamp)::DATE AS order_month
    FROM staging.orders o
    JOIN staging.customers c ON o.customer_id = c.customer_id
    WHERE o.order_purchase_timestamp IS NOT NULL
),
cohort_data AS (
    SELECT
        f.cohort_month,
        om.order_month,
        COUNT(DISTINCT f.customer_unique_id) AS retained
    FROM first_orders f
    JOIN order_months om ON f.customer_unique_id = om.customer_unique_id
    GROUP BY 1, 2
),
cohort_sizes AS (
    SELECT
        cohort_month,
        COUNT(DISTINCT customer_unique_id) AS cohort_size
    FROM first_orders
    GROUP BY 1
)
SELECT
    cd.cohort_month,
    cd.order_month,
    cs.cohort_size,
    cd.retained,
    ROUND(cd.retained::NUMERIC / cs.cohort_size * 100, 2) AS retention_rate_pct
FROM cohort_data cd
JOIN cohort_sizes cs ON cd.cohort_month = cs.cohort_month
ORDER BY cd.cohort_month, cd.order_month;
