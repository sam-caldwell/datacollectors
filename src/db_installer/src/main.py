#!/usr/bin/env python3

from sys import exit

from expect_field import expect_field
from get_args import get_args
from install_db import install_db
from load_manifest import load_manifest


def main() -> int:
    """
        main routine...

        :return: system exit code.
    """
    print("starting...")
    args = get_args()
    manifest = load_manifest(args)
    try:
        if "postgres" in manifest:
            print("Installing postgres database schema")
            postgres = manifest["postgres"]
            expect_field(postgres, "postgres", "databases", list)
            return install_db(args, manifest["postgres"]["databases"])
        else:
            print(f"no supported solutions defined in manifest")
            return 1
    except AssertionError as ae:
        print(f"Missing definition: {ae}")
        return 2


if __name__ == "__main__":
    exit(main())
