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
        with conn.cursor() as c:
            c.execute(f"update pg_database "
                      f"set datistemplate=true "
                      f"where datname={db_name};")
    except Error as e:
        print(f"Error making {db_name} into template")
        exit(5)
