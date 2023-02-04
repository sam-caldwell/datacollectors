#!/usr/bin/env python3


def expect_field(obj: dict, object_name: str, field_name: str, data_type: any, comment: str = "") -> None:
    """
        Given a dictionary (object_name), validate the field_name is in the dict
        and that the value of the identified field, verify the data_type.

        Throw assertion error if any expectation is not met.

        :param obj: dict
        :param object_name: str
        :param field_name: str
        :param data_type: any (type)
        :param comment: str
        :return: None
    """

    detail = ""

    if comment != "":
        comment = f"(detail: {comment})"

    assert field_name in obj, \
        f"expected {field_name} in {object_name} dict not found {detail}"

    assert type(obj[field_name]) is data_type, \
        f"expected {object_name}.{field_name} of type {data_type} not found {detail}"
