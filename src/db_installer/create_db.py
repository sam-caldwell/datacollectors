#!/usr/bin/env python3
from db_connect import DatabaseError
from db_connect import DuplicateDatabase
from db_connect import connection
from db_connect import db_connect
from get_args import Namespace


def create_db(args: Namespace, db_name: str, use_template: str) -> None:
    """
        Create a given database.

        :param args: ArgParse Arguments object
        :param db_name: str name of the database to create
        :param use_template: name of the template to use
        :return: None
    """
    print(f"Installing database: {db_name} (template: {use_template})")
    conn: connection = db_connect(db_host=args.db_host,
                                  db_port=args.db_port,
                                  db_name=args.db_name,
                                  db_user=args.db_user,
                                  db_pass=args.db_pass,
                                  retries=args.connect_retries,
                                  retry_interval=args.connect_retry_interval)
    if conn is None:
        raise DatabaseError(f"Database connection not possible "
                            f"after {args.retries} attempts.")

    try:
        with conn.cursor() as c:
            c.execute(f"create database {db_name} "
                      f"template {use_template};")
        with conn.cursor() as c:
            c.execute("commit;")
    except DuplicateDatabase:
        update_db(conn, db_name, use_template)
    conn.commit()
    conn.close()
    print("...done.  Database is created or updated.")


def update_db(conn: connection, db_name: str, use_template: str) -> None:
    """
        update an existing database.

        See https://www.postgresql.org/docs/9.1/sql-alterdatabase.html

        :param conn: connection
        :param db_name: str
        :param use_template: str
        :return: None
    """
    print("Database already exists...updating...")
    print("Nothing to update.  Templates cannot be changed and no other "
          "features are implemented yet which can be updated.")
