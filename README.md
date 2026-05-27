# Sales DWH Pipeline

A data warehouse pipeline built on the [Brazilian E-Commerce dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) (Kaggle).

Demonstrates end-to-end ETL with Airflow, PostgreSQL, Docker, and SQL window functions.

## Architecture

```
CSV files (Kaggle)
    │
    ▼
raw schema          — all columns TEXT, data as-is
    │
    ▼
staging schema      — typed columns, deduplication, NULL handling
    │
    ▼
mart schema         — business-ready aggregations with window functions
```

**DAG chain:**
```
ingest_raw  →  transform_staging  →  build_marts
```

## Stack

| Tool | Role |
|---|---|
| Apache Airflow 2.8 | Orchestration |
| PostgreSQL 15 | Data warehouse |
| Python + pandas | CSV ingestion |
| Docker Compose | Infrastructure |

## Marts

| Mart | Description | Window functions used |
|---|---|---|
| `mart.revenue` | Monthly revenue | 3-month rolling average |
| `mart.top_sellers` | Seller ranking by revenue | `RANK()`, revenue share `%` |
| `mart.retention` | Cohort retention by month | Cohort size over time |

## How to run

**Prerequisites:** Docker, Docker Compose, Kaggle CSV files in `data/`.

```bash
# 1. Start infrastructure
docker compose up -d

# 2. Wait for Airflow to initialize, then open
#    http://localhost:8082  (admin / admin)

# 3. Trigger the pipeline — runs all three DAGs in sequence
airflow dags trigger ingest_raw
```
