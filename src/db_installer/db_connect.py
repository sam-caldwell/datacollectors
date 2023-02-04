#!/usr/bin/env python3

from time import sleep

import psycopg2
from psycopg2 import DatabaseError
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT
from psycopg2.extensions import connection


def db_connect(db_host: str, db_port: int, db_user: str,
               db_pass: str, db_name: str) -> connection:
    """
        Connect to the database.

        :param db_host: str
        :param db_port: int
        :param db_user: str
        :param db_pass: str
        :param db_name: str
        :return: psycopg2 connection
    """
    print(f"connecting to {db_user}@{db_host}:{db_port}/{db_name}")
    for retry in range(1, 10):
        try:
            c_str = f"host={db_host} " \
                    f"port={db_port} " \
                    f"user={db_user} " \
                    f"password={db_pass} " \
                    f"dbname={db_name}"

            conn = psycopg2.connect(c_str)
            conn.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
            print("connected.")
            return conn

        except DatabaseError as e:
            print(f"Error connecting to database(retry:{retry}:{e}")
            sleep(1)
    exit(1)
