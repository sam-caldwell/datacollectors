#!/usr/bin/env python3
import re
from os import getenv
from os.path import exists

DEBUG = getenv("DEBUG", "false") != "false"


def object(src: dict, object_name: str, object_type: any, optional: bool = False,
           comment: str = "", answer: str = "yes") -> None:
    """
        Expect the src dict contains an object with the given name and type
        or raise AssertionError exception.

        :param src: dict
        :param object_name: str
        :param object_type: any
        :param optional: bool (is the object required/optional)
        :param comment: str (additional error information)
        :param answer: str (the trailing message on passing validation)
        :return: None
    """
    detail = ""

    if comment != "":
        comment = f"(Details: {comment})"

    if DEBUG:
        print(f"is object ({object_name}) in src?", end=" ")

    this_object = src.get(object_name, None)

    if this_object is not None:
        # this_object is not none... it exists.  optional or not it exists and must be evaluated
        assert type(this_object) is object_type, \
            f"expected object ({object_name}) expects type {object_type}. {detail}"
    else:
        # this_object does not exist.  If optional is true, we are okay.  Otherwise, it was expected
        assert optional, f"expected {object_name} in source dictionary object but not found.  {detail}"
    if DEBUG:
        line_ending = ""
        if answer == "yes":
            line_ending = "\n"
        print(answer, end=line_ending)


def file(src: dict, object_name: str, optional: bool = False, comment: str = "") -> None:
    """
        Expect the src dict contains an object with the given name and type
        or raise AssertionError exception.

        :param src: dict
        :param object_name: str
        :param optional: bool (is the object required/optional)
        :param comment: str (additional error information)
        :return: None
    """
    file_name = src.get(object_name, None)
    object(src, object_name, optional, str, comment, answer=f"...check if file ({file_name}) exists...")
    if file_name is not None:  # Note we don't need to evaluate optional here since object() would catch this.
        assert ".." not in file_name, f"File names cannot contain .. or other directory traversal symbols."
        assert "//" not in file_name, f"File names cannot contain // or other vulnerable patterns."
        assert exists(file_name), f"File not found {file_name}"

    if DEBUG:
        print("yes")


def name(src: dict, object_name: str, optional: bool = False,
         comment: str = "") -> None:
    """
        Expect the object_name represents a valid string identifier using the
        given regex pattern.

        :param src: dict
        :param object_name: str
        :param optional: bool
        :param comment: str
        :return: None
    """
    identifier = src.get(object_name, None)
    if optional and (identifier is not None):
        object(src, object_name, str, optional, comment, answer=f"...validate identifier ({identifier}) pattern...")
        pattern = re.compile("^[a-zA-Z][a-zA-Z0-9\\.\\_]+[a-zA-Z0-9]$")
        assert pattern.match(identifier) is not None, f"Invalid name in {object_name}: {identifier}"


def number(src: dict, object_name: str, optional: bool = False, min_value: int = -2 ** 32 / 2,
           max_value: int = 2 ** 32 / 2, comment: str = "") -> None:
    """
        Expect the object_name represents a valid string identifier using the
        given regex pattern.

        :param src: dict
        :param object_name: str
        :param optional: bool
        :param min_value: int: inclusive min value
        :param max_value: int: inclusive max value
        :param comment: str
        :return: None
    """
    value = src.get(object_name, None)
    if optional and (value is not None):
        try:
            value = int(value)
            object(src, object_name, int, optional, comment,
                   answer=f"...perform bounds check on numeric value...")
        except ValueError:
            assert False, f"{object_name} must be an integer value or cast to an integer"

        assert value >= min_value, f"value for {object_name} expected to be >= {min_value}"
        assert value <= max_value, f"value for {object_name} expected to be <= {max_value}"
