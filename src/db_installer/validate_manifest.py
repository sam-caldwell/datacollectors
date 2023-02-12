#!/usr/bin/env python3

import expect


def validate_manifest(manifest: dict) -> None:
    """
        Validate the structure of the manifest or
        throw exception on error.

        :param manifest: dict
        :return: None
    """
    print("validating the db manifest")
    this_object = manifest
    expect.object(this_object, "postgres", dict)
    this_object = manifest["postgres"]
    #
    # config dictionary
    #
    expect.object(this_object, "config", dict)
    config = this_object.get("config", {})

    expect.object(config, "default_template", str, optional=True)
    expect.number(config, "connect_retries", optional=True, min_value=0, max_value=1024)
    expect.number(config, "connect_retry_interval", optional=True, min_value=0, max_value=3600)
    #
    # databases list
    #
    expect.object(this_object, "databases", list)
    for this_object in this_object["databases"]:
        expect.object(this_object, "name", str)
        expect.name(this_object, "name", str)
        if this_object.get("enabled", True):
            expect.object(this_object, "enabled", bool, optional=True)
            expect.object(this_object, "description", str, optional=True)
            expect.object(this_object, "from_template", str, optional=True)
            expect.object(this_object, "template", bool, optional=True)
            expect.object(this_object, "schemas", list)
            for this_object in this_object["schemas"]:
                expect.object(this_object, "name", str)
                expect.object(this_object, "enabled", bool, optional=True)
                if this_object.get("enabled", True):
                    expect.object(this_object, "description", str, optional=True)
                    expect.object(this_object, "sources", list)
                    for this_object in this_object["sources"]:
                        expect.object(this_object, "enabled", bool, optional=True)
                        if this_object.get("enabled", True):
                            expect.file(this_object, "file", str)
                            expect.object(this_object, "register_versions", bool, optional=True)
                            expect.object(this_object, "description", str, optional=True)
    print("\n---db manifest is valid.---")
