#!/usr/bin/env python3
"""
   (c) 2023 Sam Caldwell.  See LICENSE.txt
"""
from argparse import Namespace

import log
from db_connect import db_connect
from install_postgres_extension import install_postgres_extension
from install_postgres_function import install_postgres_function
from install_postgres_procedure import install_postgres_procedure
from install_postgres_table import install_postgres_table


def install_postgres_schema(args: Namespace, db_name: str, schema_name: str,
                            schema: dict) -> None:
    """
        install the postgresql database schema

        :param args: Namespace
        :param db_name: str
        :param schema_name: str
        :param schema: dict
        :return: None
    """

    log.blue(f"installing database schema ({db_name}:{schema_name})")

    with db_connect(args.db_host, args.db_port, args.db_user,
                    args.db_pass, db_name) as pg:
        with pg.cursor() as c:
            c.execute(f"create schema if not exists {schema_name};")

        log.green(f"schema created ({db_name}:{schema_name})")

        for section, content in schema.items():
            if type(content) in [list]:
                for db_object in content:
                    name = db_object.get("name", "unnamed")
                    if db_object.get("enabled", False):
                        if section == "extensions":
                            install_postgres_extension(pg, name, db_object)
                        elif section == "functions":
                            install_postgres_function(pg, name, db_object)
                        elif section == "procedures":
                            install_postgres_procedure(pg, name, db_object)
                        elif section == "tables":
                            install_postgres_table(pg, name, db_object)
                        else:
                            raise Exception(f"Unknown or unsupported "
                                            f"structure: {section}[list]")
                    else:
                        log.yellow(f"{section} not enabled: {name}")
            elif type(content) is dict:
                raise Exception(f"{section} is unexpected dictionary")
