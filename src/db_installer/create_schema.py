#!/usr/bin/env python3
from psycopg2.extensions import connection

from run_sql import run_sql
from validate_schema_manifest import validate_schema_manifest


def create_schema(conn: connection, db_name: str, manifest: dict) -> None:
    """
        create the database schema within the currently connected
        database.

        Note: conn must be the database where the schema will be created.

        :param conn: psycopg2 connection
        :param db_name: str
        :param manifest: dict
        :return: None
    """

    print(f"Creating database schemas in {db_name}")

    for schema in manifest:

        validate_schema_manifest(db_name, schema)

        if schema["enabled"]:

            schema_name = schema["name"]

            with conn.cursor() as c:
                c.execute(f"create schema if not exists {schema_name};")

            print(f"schema applied: {db_name}.{schema_name}")

            run_sql(conn, schema["sources"], db_name)
            print("...done")
        else:

            print(f"skipped: {db_name}.{schema_name}")
