#!/usr/bin/env python3
from psycopg2 import Error
from psycopg2.extensions import connection


def make_db_template(conn: connection, db_name: str) -> None:
    """
        make_db_template()

        :param conn: psycopg2.connection
        :param db_name: str
        :return: None
    """
    try:
        sql = f"update pg_database set datistemplate=true where datname='{db_name}';"
        with conn.cursor() as c:
            c.execute(sql)
    except Error as e:
        print(f"Error making {db_name} into template: {e}")
        exit(5)

