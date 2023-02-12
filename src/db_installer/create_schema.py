#!/usr/bin/env python3
from db_connect import DatabaseError
from db_connect import DuplicateSchema
from db_connect import connection
from db_connect import db_connect
from get_args import Namespace


def create_schema(args: Namespace, db_name: str, schema: dict) -> None:
    """
        Create or update the db schema

        :param args: Namespace
        :param db_name: str
        :param schema: dict
        :return: None
    """
    schema_name = schema.get("name")
    print(f"Creating database schemas ({schema_name}) in {db_name}")

    conn: connection = db_connect(db_host=args.db_host,
                                  db_port=args.db_port,
                                  db_name=db_name,  # Don't use the one in args.
                                  db_user=args.db_user,
                                  db_pass=args.db_pass,
                                  retries=args.connect_retries,
                                  retry_interval=args.connect_retry_interval)
    if conn is None:
        raise DatabaseError(f"Database connection not possible "
                            f"after {args.retries} attempts.")
    try:
        with conn.cursor() as c:
            c.execute(f"create schema {schema_name};")
    except DuplicateSchema as e:
        update_schema(conn, db_name, schema_name, schema)
    conn.commit()
    conn.close()
    print(f"...done.  Created {db_name}.{schema_name}")


def update_schema(conn: connection, db_name: str, schema_name: str, schema: dict) -> None:
    """
        update the existing schema.

        :param conn:
        :param db_name:
        :param schema_name:
        :param schema:
        :return:
    """
    print("schema exists...updating...")
    print("No features implemented which support schema update.")
