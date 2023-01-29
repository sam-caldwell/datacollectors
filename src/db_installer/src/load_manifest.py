#!/usr/bin/env python3
from argparse import Namespace

from yaml import safe_load


def load_manifest(args: Namespace) -> dict:
    """
        load_manifest() will load a YAML/JSON file as a dictionary.

        :param args: argparse.Namespace
        :return: dict
    """

    print(f"loading manifest file: {args.manifest}")

    with open(args.manifest, 'r') as f:
        print("\tmanifest file is open.  Reading...")
        return safe_load(f.read())
