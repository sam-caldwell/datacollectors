#!/usr/bin/env python3

from argparse import Namespace

from create_db import create_db
from create_schema import create_schema
from db_connect import db_connect
from make_db_template import make_db_template
from validate_db_manifest import validate_db_manifest


def install_db(args: Namespace, manifest: dict) -> int:
    """
        install the database schema from the manifest.

        :param args: argparse.Namespace
        :param manifest: dict
        :return: int
    """
    print("installing database")
    pg = db_connect(args.db_host, args.db_port, args.db_user, args.db_pass, args.db_name)
    try:
        for db in manifest:
            validate_db_manifest(db)
            if db["enabled"]:
                create_db(pg, db["name"], db["from_template"])
                this_db = db_connect(args.db_host, args.db_port, args.db_user, args.db_pass, db["name"])

                create_schema(this_db, db["name"], db["schemas"])

                if db["template"]:
                    make_db_template(pg, db["name"])
        return 0
    except AssertionError as ae:
        print(f"Error installing db: {ae}")
        return 3
