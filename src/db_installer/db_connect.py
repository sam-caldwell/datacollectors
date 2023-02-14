#!/usr/bin/env python3
from time import sleep
from typing import Optional
from psycopg2.extensions import connection
from psycopg2 import connect
from psycopg2 import DatabaseError
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT
# from psycopg2 import ProgrammingError


def db_connect(db_host: str,
               db_port: int,
               db_name: str,
               db_user: str,
               db_pass: str,
               retries: int = 1,
               retry_interval: int = 1) -> Optional[connection]:
    """
            Connect to the database.

        :param db_host:
        :param db_port:
        :param db_name:
        :param db_user:
        :param db_pass:
        :param retries:
        :param retry_interval:
        :return: connection or None
    """
    print(f"\tconnect to {db_user}@{db_host}:{db_port}/{db_name}")
    for retry in range(1, retries):
        try:
            c_str = f"host={db_host} " \
                    f"port={db_port} " \
                    f"user={db_user} " \
                    f"password={db_pass} " \
                    f"dbname={db_name}"

            conn = connect(c_str)
            conn.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
            print("connected.")
            return conn
        except DatabaseError as e:
            print(f"Error connecting to database(retry:{retry}:{e}")
            sleep(retry_interval)
        except DuplicateDatabase as e:
            raise Exception(f"DuplicateDatabase error should not occur in db_connect() EVER: {e}")
    print("failed to connect.")
    exit(1)
