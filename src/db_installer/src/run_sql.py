#!/usr/bin/env python3
from os import getenv
from os.path import join

from psycopg2.extensions import connection

from expect_field import expect_field
from register_sql_file import register_sql_file


def run_sql(conn: connection, sources: list[dict], db_name: str):
    print("running sql sources...")
    for source in sources:
        expect_field(source, "sources", "enabled", bool, db_name)
        sql = source.get("file", "")
        assert sql != "", "file name must be sql file."

        if source.get("enabled", False):
            if "file" in source:
                sql = join(getenv('PWD'), sql)
                print(f"Running {sql}")
                with conn.cursor() as c:
                    with open(sql, 'r') as f:
                        print(f"\trun :{sql}")
                        c.execute(f.read())
                register_sql_file(conn, db_name, sql, source.get("description", ""))
                print("SQL file has been run.")
        else:
            print(f"\tskip:{sql}")

    print("All files completed.")
