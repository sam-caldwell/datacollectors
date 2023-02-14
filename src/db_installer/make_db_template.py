#!/usr/bin/env python3
from db_connect import connection
from db_connect import db_connect
from get_args import Namespace


def make_db_template(args: Namespace, db_name: str) -> None:
    """
        make a given database into a template.
        (note: if the database is a template, do nothing)

        :param args: Namespace
        :param db_name: str
        :return: None
    """
    print(f"making database: {db_name} into a template")
    conn: connection = db_connect(db_host=args.db_host,
                                  db_port=args.db_port,
                                  db_name=args.db_name,
                                  db_user=args.db_user,
                                  db_pass=args.db_pass,
                                  retries=args.connect_retries,
                                  retry_interval=args.connect_retry_interval)

    sql = f"update pg_database " \
          f"set datistemplate=true " \
          f"where datname='{db_name}';"

    with conn.cursor() as c:
        c.execute(sql)
    conn.commit()
    conn.close()
    print(f"database {db_name} is now a template")

