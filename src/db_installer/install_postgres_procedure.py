#!/usr/bin/env python3
"""
   (c) 2023 Sam Caldwell.  See LICENSE.txt
"""
import log
from psycopg2.extensions import connection


def install_postgres_procedure(pg: connection, name: str, manifest: dict) -> None:
    """

    :param pg:
    :param name:
    :param manifest:
    :return:
    """
    log.blue(f"installing extension {name}")
