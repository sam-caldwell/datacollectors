#!/usr/bin/env python3
"""
   (c) 2023 Sam Caldwell.  See LICENSE.txt
"""
from sys import exit

import log
from create_db import create_db
from create_schema import create_schema
from get_args import Namespace
from get_args import get_args
from load_manifest import load_manifest
from make_db_template import make_db_template
from run_sql import run_sql
from validate_manifest import validate_manifest

EXIT_SUCCESS = 0
EXIT_VALIDATION_ERROR = 10


def main() -> int:
    """
        main routine...

        :return: system exit code.
    """
    log.blue("starting...")
    args: Namespace = get_args()

    manifest: dict = load_manifest(args.manifest)
    try:
        validate_manifest(manifest)
    except AssertionError as e:
        print(f"Validation Error: {e}")
        return EXIT_VALIDATION_ERROR
    #
    # manifest root (postgres)
    #
    postgres = manifest.get("postgres", {})
    #
    # postgres.config
    #
    config = postgres.get("config", {})
    default_template = config.get("default_template", "template0")
    args.connect_retries = int(config.get("connect_retries", 10))
    args.connect_retry_interval = int(config.get("connect_retry_interval", 10))
    #
    # postgres.databases.[]
    #
    databases = postgres.get("databases", [])

    for database in databases:
        if database.get("enabled", True):
            db_name = database.get("name")
            use_template = database.get("use_template", default_template)
            print(f"use_template: {use_template}")

            create_db(args, db_name, use_template)

            for schema in database.get("schemas", []):
                if schema.get("enabled", False):
                    create_schema(args, db_name, schema)

                    for source in schema.get("sources", []):
                        if source.get("enabled", False):
                            sql_file = source.get("file", None)
                            print(f"running {sql_file}")
                            if sql_file is not None:
                                run_sql(args, db_name, sql_file)
                        else:
                            print(f"skipped {sql_file}")

            create_template = database.get("template", False)
            if create_template:
                make_db_template(args, db_name)


if __name__ == "__main__":
    exit(main())
