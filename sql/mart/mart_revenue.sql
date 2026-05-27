TRUNCATE mart.revenue;

INSERT INTO mart.revenue
WITH monthly AS (
    SELECT
        DATE_TRUNC('month', o.order_purchase_timestamp)::DATE AS month,
        COUNT(DISTINCT o.order_id)                            AS total_orders,
        SUM(oi.price + oi.freight_value)                      AS total_revenue
    FROM staging.orders o
    JOIN staging.order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status NOT IN ('canceled', 'unavailable')
      AND o.order_purchase_timestamp IS NOT NULL
    GROUP BY 1
)
SELECT
    month,
    total_orders,
    ROUND(total_revenue, 2)                               AS total_revenue,
    ROUND(AVG(total_revenue) OVER (
        ORDER BY month
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2)                                                 AS revenue_3m_rolling_avg
FROM monthly
ORDER BY month;
