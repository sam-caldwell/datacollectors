#!/usr/bin/env python3
import hashlib
from argparse import ArgumentParser
from argparse import Namespace
from os.path import join
from sys import exit

import psycopg2
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT
from psycopg2.extensions import connection
from yaml import safe_load


def get_args() -> Namespace:
    parser = ArgumentParser()
    parser.add_argument("--manifest", type=str, required=True, help="manifest yaml file.")
    parser.add_argument("--db_host", type=str, required=True, help="database host")
    parser.add_argument("--db_port", type=int, required=True, help="database port")
    parser.add_argument("--db_user", type=str, required=True, help="database user")
    parser.add_argument("--db_pass", type=str, required=True, help="database password")
    parser.add_argument("--db_name", type=str, required=True, help="database name")
    return parser.parse_args()


def load_manifest(args: Namespace) -> dict:
    print(f"loading manifest file: {args.manifest}")
    with open(args.manifest, 'r') as f:
        return safe_load(f.read())


def db_connect(db_host: str, db_port: int, db_user: str, db_pass: str, db_name: str) -> connection:
    print(f"connecting to {db_user}@{db_host}:{db_port}/{db_name}")
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
    except psycopg2.DatabaseError as e:
        print(f"Error connecting to database:{e}")
        exit(1)


def create_db(conn: connection, db_name: str, template: str):
    try:
        print(f"Creating database {db_name}")
        with conn.cursor() as c:
            c.execute(f"drop database if exists {db_name}")
            c.execute(f"create database {db_name};")
        print("...done")
    except psycopg2.Error as e:
        print(f"Error creating database[{db_name}]:{e}")
        exit(4)


def calc_file_hash(file_name: str) -> str:
    with open(file_name, 'r') as f:
        return hashlib.sha256(f.read().encode('utf-8')).hexdigest()


def run_sql(conn: connection, sources: list[dict], db_name: str):
    try:
        print("running sql sources...")
        assert type(sources) is list, \
            "Expect that sources are a list of dictionary objects"

        for source in sources:
            assert type(source) is dict, \
                "Expect that the source is a dictionary"
            assert "enabled" in source, "Expect enabled flag expected in source"
            assert type(source["enabled"]) is bool, "Expect enabled flag is boolean in source"
            assert "file" in source, "A source descriptor expects a file property"
            assert type(source['file']) is str, "Expect the source file is string"

            sql_file = source["file"]
            if source["enabled"]:
                with conn.cursor() as c:
                    with open(sql_file, 'r') as sql:
                        print(f"\trun :{sql_file}")
                        c.execute(sql.read())
                with conn.cursor() as c:
                    file_parts = sql_file.split("/")
                    file_name = join(file_parts[-3], file_parts[-2], file_parts[-1])
                    file_hash = calc_file_hash(sql_file)
                    print(f"registering file version: {file_name} [{file_hash}]")

                    c.execute(f"call version.register('{file_name}','{db_name}','{file_hash}','installer script');")
            else:
                print(f"\tskip:{sql_file}")
        print("All files completed.")
    except AssertionError as ae:
        print(f"Missing input: {ae}")
    except psycopg2.Error as e:
        print(f"Error running {source['file']}: {e}")
        exit(6)


def make_db_template(conn: connection, db_name: str):
    try:
        with conn.cursor() as c:
            c.execute(f"update pg_database set datistemplate=true where datname={db_name};")
    except psycopg2.Error as e:
        print(f"Error making {db_name} into template")
        exit(5)


def install_db(args: Namespace, manifest: dict) -> int:
    print("installing database")
    pg = db_connect(args.db_host, args.db_port, args.db_user, args.db_pass, args.db_name)
    try:
        for db in manifest:
            assert "name" in db, f"database descriptor missing name flag"
            assert "enabled" in db, f"database[{db['name']}] descriptor missing enabled flag"
            assert type(db['enabled']) is bool, "database enabled flag requires boolean"
            if db["enabled"]:
                assert "template" in db, f"database[{db['name']}] descriptor missing template flag"
                assert type(db['template']), "database template flag requires boolean"
                assert "sources" in db, f"database[{db['sources']}] descriptor missing sources list"
                assert type(db['sources']) is list, "database sources requires a list"
                assert "from_template" in db, "database requires from_template (string)"
                assert type(db['from_template']) is str, "database.from_template must be string"

                create_db(pg, db["name"], db["from_template"])

                this_db = db_connect(args.db_host, args.db_port, args.db_user, args.db_pass, db["name"])

                run_sql(this_db, db["sources"], db["name"])

                if db["template"]:
                    make_db_template(pg, db["name"])
        return 0
    except AssertionError as ae:
        print(f"Error installing db: {ae}")
        return 3


def main() -> int:
    print("starting...")
    args = get_args()
    manifest = load_manifest(args)
    try:
        if "postgres" in manifest:
            assert "databases" in manifest["postgres"], "databases not defined"
            return install_db(args, manifest["postgres"]["databases"])
        else:
            print(f"no supported solutions defined in manifest")
            return 1
    except AssertionError as ae:
        print(f"Missing definition: {ae}")
        return 2


if __name__ == "__main__":
    exit(main())
