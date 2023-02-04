#!/usr/bin/env python3

from argparse import Namespace
from install_db import install_db
import log


def install_postgres(args: Namespace, manifest: dict) -> None:
    """
        postgresql_install_db(section, manifest) is the top-level
        database configuration function.

        :param args: Namespace
        :param manifest: dict
        :return: None
    """
    try:
        for database in manifest:
            db_name = database.get("name", None)
            assert db_name is not None, "database name not defined"
            if database.get("enabled", False):
                log.blue(f"database {db_name} installation starting.")
                file_name = database.get("file", None)
                assert file_name is not None, "database manifest file not defined"
                install_db(args, db_name, file_name)
                log.green(f"database {db_name} installation completed.")
            else:
                log.yellow(f"database {db_name} not enabled.  skipping")
    except AssertionError as e:
        log.red(f"Missing Parameter: {e}")
        exit(1)
