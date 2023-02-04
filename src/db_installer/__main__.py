#!/usr/bin/env python3
"""
   (c) 2023 Sam Caldwell.  See LICENSE.txt
"""

from argparse import Namespace
from os.path import join
from sys import exit

from yaml import safe_load

import log
from get_args import get_args
from install_postgres import install_postgres


def noop_func():
    pass


loader_table = {
    "postgres": {
        "databases": install_postgres,
    }
}


def main() -> int:
    """
        main routine...

        :return: system exit code.
    """
    manifest_file: str = ''
    manifest: dict = {}
    args: Namespace

    log.blue("starting...")
    args = get_args()

    manifest_file = join(args.manifest, 'manifest.yaml')
    log.blue(f"reading {manifest_file}")

    with open(manifest_file, 'r') as f:
        manifest = safe_load(f.read())
    log.green("manifest file loaded.")

    loader, section = None, None
    try:
        for loader, sections in manifest.items():
            log.blue(f"loader detected: {loader}")
            for section, configuration in sections.items():
                log.blue(f"section found: {section}")

                loader_func = loader_table[loader].get(section, noop_func)
                if callable(loader_func):
                    loader_func(args, configuration)
                else:
                    raise Exception(f"loader function should be callable {f}")
                log.green("...section completed")
            log.green("...loader completed")
        log.green("terminating (no error)")
    except KeyError as e:
        log.yellow(f"Manifest does not have configuration for {loader}::{section}")
    except AssertionError as ae:
        log.red(f"Missing definition: {ae}")
        return 2


if __name__ == "__main__":
    exit(main())
