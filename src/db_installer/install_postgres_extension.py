#!/usr/bin/env python3
"""
   (c) 2023 Sam Caldwell.  See LICENSE.txt
"""
from psycopg2.extensions import connection

import log


def install_postgres_extension(pg: connection, name: str, manifest: dict) -> None:
    """

    :param pg:
    :param name:
    :param manifest:
    :return:
    """
    log.blue(f"installing extension {name}")
    name = manifest.get("name", None)
    description = manifest.get("name", None)
    schema = manifest.get("schema", "pg_catalog")
    version = manifest.get("version", None)

    sql = f"create extension if not exists {name} " \
          f"     schema {schema}"
    if version is not None:
        sql = f"{sql} version '{version}'"
    sql = f"{sql}; "
    if description is not None:
        sql = f"{sql} comment on extension {name} is '{description}';"
    with pg.cursor() as conn:
        conn.execute(sql)
