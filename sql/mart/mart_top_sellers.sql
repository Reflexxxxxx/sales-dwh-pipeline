TRUNCATE mart.top_sellers;

INSERT INTO mart.top_sellers
WITH seller_revenue AS (
    SELECT
        s.seller_id,
        s.seller_city,
        s.seller_state,
        COUNT(DISTINCT oi.order_id)  AS total_orders,
        SUM(oi.price)                AS total_revenue
    FROM staging.order_items oi
    JOIN staging.sellers s ON oi.seller_id = s.seller_id
    GROUP BY 1, 2, 3
)
SELECT
    seller_id,
    seller_city,
    seller_state,
    total_orders,
    ROUND(total_revenue, 2)                                AS total_revenue,
    RANK() OVER (ORDER BY total_revenue DESC)              AS revenue_rank,
    ROUND(total_revenue / SUM(total_revenue) OVER () * 100, 2) AS revenue_share_pct
FROM seller_revenue
ORDER BY revenue_rank;
