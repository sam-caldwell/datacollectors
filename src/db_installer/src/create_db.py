#!/usr/bin/env python3
from psycopg2 import Error
from psycopg2.extensions import connection


def create_db(conn: connection, db_name: str, template: str) -> None:
    """
        Create the postgresql database from the given template.

        :param conn: psycopg2.connection
        :param db_name: str
        :param template: str
        :return: None
    """

    try:

        print(f"Creating database named '{db_name}' template {template}")
        with conn.cursor() as c:
            c.execute(f"drop database if exists {db_name}")
            c.execute(f"create database {db_name};")

        print("...database created")

    except Error as e:
        print(f"Error creating database[{db_name}]:{e}")
        exit(4)
