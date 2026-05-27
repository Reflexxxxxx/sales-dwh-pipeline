from datetime import datetime
from airflow import DAG
from airflow.operators.trigger_dagrun import TriggerDagRunOperator
from airflow.providers.postgres.operators.postgres import PostgresOperator

STAGING_TABLES = [
    "orders",
    "order_items",
    "customers",
    "sellers",
    "products",
    "order_payments",
    "order_reviews",
]

with DAG(
    dag_id="transform_staging",
    start_date=datetime(2024, 1, 1),
    schedule=None,
    catchup=False,
    tags=["staging", "transform"],
    template_searchpath=["/opt/airflow"],
) as dag:

    create_schema = PostgresOperator(
        task_id="create_staging_schema",
        postgres_conn_id="sales_dwh",
        sql="sql/staging/create_staging_tables.sql",
    )

    transform_tasks = [
        PostgresOperator(
            task_id=f"stg_{table}",
            postgres_conn_id="sales_dwh",
            sql=f"sql/staging/stg_{table}.sql",
        )
        for table in STAGING_TABLES
    ]

    trigger_marts = TriggerDagRunOperator(
        task_id="trigger_build_marts",
        trigger_dag_id="build_marts",
    )

    create_schema >> transform_tasks >> trigger_marts
