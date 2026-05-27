from datetime import datetime
from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator

MART_TABLES = [
    "revenue",
    "top_sellers",
    "retention",
]

with DAG(
    dag_id="build_marts",
    start_date=datetime(2024, 1, 1),
    schedule=None,
    catchup=False,
    tags=["mart"],
    template_searchpath=["/opt/airflow"],
) as dag:

    create_schema = PostgresOperator(
        task_id="create_mart_schema",
        postgres_conn_id="sales_dwh",
        sql="sql/mart/create_mart_tables.sql",
    )

    mart_tasks = [
        PostgresOperator(
            task_id=f"mart_{table}",
            postgres_conn_id="sales_dwh",
            sql=f"sql/mart/mart_{table}.sql",
        )
        for table in MART_TABLES
    ]

    create_schema >> mart_tasks
