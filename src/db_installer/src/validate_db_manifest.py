#!/usr/bin/env python3

from expect_field import expect_field


def validate_db_manifest(manifest: dict):
    print("validating the db manifest")

    expect_field(manifest, "database", "name", str)
    expect_field(manifest, "database", "enabled", bool)

    if manifest["enabled"]:
        expect_field(manifest, "database", "template", bool)
        expect_field(manifest, "database", "schemas", list)
        expect_field(manifest, "database", "from_template", str)
        expect_field(manifest, "database", "description", str)

    print("db manifest is valid.")
