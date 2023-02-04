#!/usr/bin/env python3
"""
   (c) 2023 Sam Caldwell.  See LICENSE.txt
"""
from argparse import ArgumentParser
from argparse import Namespace


def get_args() -> Namespace:
    """
        get_args() - processes cli arguments

        :return: argparse.Namespace
    """

    parser = ArgumentParser()

    parser.add_argument("--manifest", type=str, required=True, help="manifest directory.")

    parser.add_argument("--db_host", type=str, required=True, help="database host")

    parser.add_argument("--db_port", type=int, required=True, help="database port")

    parser.add_argument("--db_user", type=str, required=True, help="database user")

    parser.add_argument("--db_pass", type=str, required=True, help="database password")

    parser.add_argument("--db_name", type=str, required=True, help="database name")

    return parser.parse_args()
