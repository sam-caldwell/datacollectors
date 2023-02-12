#!/usr/bin/env python3
"""
   (c) 2023 Sam Caldwell.  See LICENSE.txt
"""
import sys


def green(msg: str, end: str = '\n') -> None:
    """
        print message in green

        :param end:
        :param msg: str
        :return: None
    """
    sys.stdout.write('\x1b[1;32m' + msg.strip() + '\x1b[0m' + end)


def yellow(msg: str, end: str = '\n') -> None:
    """
        print message in yellow

        :param end:
        :param msg: str
        :return: None
    """
    sys.stdout.write('\x1b[1;33m' + msg.strip() + '\x1b[0m' + end)


def red(msg: str, end: str = '\n') -> None:
    """
        print message in red

        :param end:
        :param msg: str
        :return: None
    """
    sys.stdout.write('\x1b[1;31m' + msg.strip() + '\x1b[0m' + end)


def blue(msg: str, end: str = '\n') -> None:
    """
        print message in blue

        :param end:
        :param msg: str
        :return: None
    """
    sys.stdout.write('\x1b[1;34m' + msg.strip() + '\x1b[0m' + end)
