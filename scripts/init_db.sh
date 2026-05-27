#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE USER dwh_user WITH PASSWORD 'dwh_pass';
    CREATE DATABASE sales_dwh OWNER dwh_user;
EOSQL

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "sales_dwh" <<-EOSQL
    GRANT ALL ON SCHEMA public TO dwh_user;
EOSQL
