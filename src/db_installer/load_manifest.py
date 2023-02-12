#!/usr/bin/env python3
"""
   (c) 2023 Sam Caldwell.  See LICENSE.txt
"""
from os.path import join

from yaml import safe_load

import log


def load_manifest(directory_name: str) -> dict:
    """
        load yaml/json manifest file.

        :param directory_name: str (location of manifest.yaml)
        :return: dict
    """
    manifest_file: str = join(directory_name, 'manifest.yaml')
    log.blue(f"reading {manifest_file}")
    with open(manifest_file, 'r') as f:
        return safe_load(f.read())
