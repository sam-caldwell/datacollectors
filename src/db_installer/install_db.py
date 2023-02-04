#!/usr/bin/env python3
"""
   (c) 2023 Sam Caldwell.  See LICENSE.txt
"""
from argparse import Namespace
from os.path import join

from psycopg2 import Error
from psycopg2.extensions import connection
from yaml import safe_load

import log
from db_connect import db_connect
from install_postgres_schema import install_postgres_schema
from make_db_template import make_db_template

def db_exists(conn: connection, name: str) -> bool:
    with conn.cursor() as c:
        c.execute(
            "select count(datname) as c "
            "from pg_catalog.pg_database "
            f"where datname = '{name}'"
        )
        return c.fetchone()[0] > 0


def install_db(args: Namespace, db_name: str, file_name: str) -> None:
    """
        install the database schema from the manifest.

        :param args: argparse.Namespace
        :param db_name: str
        :param file_name: str
        :return: None
    """

    def create_db(name: str, template_name: str, description: str):
        try:
            log.blue(f"Creating database named '{db_name}' "
                     f"template {template_name}")
            pg = db_connect(args.db_host, args.db_port, args.db_user,
                            args.db_pass, args.db_name)
            with pg.cursor() as c:
                if db_exists(pg, name):
                    c.execute(f"alter database {name} set ")
                else:
                    c.execute(f"create database {name} "
                              f"template={template_name};")
            pg.close()
            log.green("...database created")
        except Error as e:
            log.red(f"Error creating database[{db_name}]:{e}")
            exit(4)

    manifest: dict = {}
    manifest_file = join(args.manifest, file_name)

    log.blue(f"reading {manifest_file}")
    with open(manifest_file, 'r') as f:
        manifest = safe_load(f.read())
        log.green(f"manifest file loaded: {manifest_file} for {db_name}")

    log.blue(f"installing database {db_name}")

    try:
        db = manifest.get("database", {})
        template = bool(db.get("template", False))

        create_db(name=db_name,
                  template_name=db.get("from_template", "template0"),
                  description=db.get("description", ""))

        for schema in db.get("schema", {}):
            schema_name = schema.get("name", None)
            enabled = schema.get("enabled", False)
            assert schema_name is not None, "schema.name is missing"

            if enabled:
                log.yellow(f"schema ({db_name}:{schema_name}) "
                           f"enabled...installing")
                install_postgres_schema(args=args,
                                        db_name=db_name,
                                        schema_name=schema_name,
                                        schema=schema)
            else:
                log.yellow(f"schema ({db_name}:{schema_name}) "
                           f"disabled...skipping")
        if template:
            pg = db_connect(args.db_host, args.db_port, args.db_user, args.db_pass, args.db_name)
            make_db_template(pg, db_name)
            pg.close()

    except AssertionError as ae:
        print(f"Error installing db: {ae}")
        exit(1)
