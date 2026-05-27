from datetime import datetime
import os
import pandas as pd
from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.operators.trigger_dagrun import TriggerDagRunOperator
from airflow.providers.postgres.operators.postgres import PostgresOperator
from airflow.providers.postgres.hooks.postgres import PostgresHook

DATA_DIR = "/opt/airflow/data"

CSV_TO_TABLE = {
    "olist_orders_dataset.csv": "orders",
    "olist_order_items_dataset.csv": "order_items",
    "olist_customers_dataset.csv": "customers",
    "olist_sellers_dataset.csv": "sellers",
    "olist_products_dataset.csv": "products",
    "olist_order_payments_dataset.csv": "order_payments",
    "olist_order_reviews_dataset.csv": "order_reviews",
    "olist_geolocation_dataset.csv": "geolocation",
    "product_category_name_translation.csv": "product_category_name_translation",
}


def load_csv_to_raw(csv_file: str, table_name: str) -> None:
    filepath = os.path.join(DATA_DIR, csv_file)
    df = pd.read_csv(filepath, dtype=str, keep_default_na=False)
    hook = PostgresHook(postgres_conn_id="sales_dwh")
    engine = hook.get_sqlalchemy_engine()
    df.to_sql(table_name, engine, schema="raw", if_exists="replace", index=False)


with DAG(
    dag_id="ingest_raw",
    start_date=datetime(2024, 1, 1),
    schedule="@once",
    catchup=False,
    tags=["raw", "ingest"],
    template_searchpath=["/opt/airflow"],
) as dag:

    create_schema = PostgresOperator(
        task_id="create_raw_schema",
        postgres_conn_id="sales_dwh",
        sql="sql/raw/create_raw_tables.sql",
    )

    load_tasks = [
        PythonOperator(
            task_id=f"load_{table_name}",
            python_callable=load_csv_to_raw,
            op_kwargs={"csv_file": csv_file, "table_name": table_name},
        )
        for csv_file, table_name in CSV_TO_TABLE.items()
    ]

    trigger_staging = TriggerDagRunOperator(
        task_id="trigger_transform_staging",
        trigger_dag_id="transform_staging",
    )

    create_schema >> load_tasks >> trigger_staging
