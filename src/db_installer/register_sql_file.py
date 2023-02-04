#!/usr/bin/env python3

from os.path import join

from psycopg2.extensions import connection

from calc_file_hash import calc_file_hash


def register_sql_file(conn: connection, db_name: str, file_name: str, description: str) -> None:
    """
        Register the current file, its hash and its description as having been
        installed into the database schema.

        :param conn: psycopg2.connection
        :param db_name: str
        :param file_name: str
        :param description: str
        :return: None
    """
    print(f"registering file: {db_name}->{file_name}")
    file_hash = calc_file_hash(file_name)
    file_parts = file_name.split("/")
    file_name = join(file_parts[-4], file_parts[-3], file_parts[-2], file_parts[-1])

    with conn.cursor() as c:
        c.execute(f"call version.register('{file_name}','{db_name}','{file_hash}','{description}');")
    print(f"file registered: {file_name}")
