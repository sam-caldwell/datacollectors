#!/usr/bin/env python3

from expect_field import expect_field


def validate_schema_manifest(db_name: str, manifest: dict) -> None:
    """
        validate that the schema is properly structured.

        :param db_name: str
        :param manifest: dict
        :return: None
    """

    print("validating the database schema manifest dict")

    detail = f"database: {db_name}"

    expect_field(manifest, "schemas", "name", str, detail)
    expect_field(manifest, "schemas", "description", str, detail)
    expect_field(manifest, "schemas", "enabled", bool, detail)
    expect_field(manifest, "schemas", "sources", list, detail)

    if manifest["enabled"]:
        for source in manifest["sources"]:
            detail = f"{db_name}.{manifest['name']}"
            expect_field(source, "schemas", "enabled", bool, detail)
            expect_field(source, "schemas", "file", str, detail)

    print("database schema manifest is valid")
