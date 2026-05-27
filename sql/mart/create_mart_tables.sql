CREATE SCHEMA IF NOT EXISTS mart;

CREATE TABLE IF NOT EXISTS mart.revenue (
    month                   DATE,
    total_orders            INTEGER,
    total_revenue           NUMERIC(12,2),
    revenue_3m_rolling_avg  NUMERIC(12,2)
);

CREATE TABLE IF NOT EXISTS mart.top_sellers (
    seller_id          TEXT,
    seller_city        TEXT,
    seller_state       TEXT,
    total_orders       INTEGER,
    total_revenue      NUMERIC(12,2),
    revenue_rank       INTEGER,
    revenue_share_pct  NUMERIC(6,2)
);

CREATE TABLE IF NOT EXISTS mart.retention (
    cohort_month       DATE,
    order_month        DATE,
    cohort_size        INTEGER,
    retained           INTEGER,
    retention_rate_pct NUMERIC(6,2)
);
