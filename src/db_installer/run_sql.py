#!/usr/bin/env python3
from db_connect import connection
from db_connect import db_connect
from get_args import Namespace


def run_sql(args: Namespace, db_name: str, sql_file: str) -> None:
    """
        Run the SQL file provided...

        :param args: Namespace
        :param db_name: str
        :param sql_file: str
        :return: None
    """
    print(f"execute sql file {sql_file} on {db_name}")

    conn: connection = db_connect(db_host=args.db_host,
                                  db_port=args.db_port,
                                  db_name=db_name,  # Don't use the one in args.
                                  db_user=args.db_user,
                                  db_pass=args.db_pass,
                                  retries=args.connect_retries,
                                  retry_interval=args.connect_retry_interval)
    try:
        with open(sql_file, "r") as f:
            with conn.cursor() as c:
                c.execute(f.read())
    except Exception as e:
        raise Exception(f"sql file (file: {sql_file}) failed {e}")
    conn.commit()
    conn.close()
    print(f"file successfully executed ({sql_file})")

