#!/bin/bash -e

from json import loads
from requests import post
from string import ascii_letters


def sanitize_gender(g: str) -> str:
    """

        :param g:
        :return:
    """
    try:
        assert g is not None
        gender = g.upper()[0]
        assert gender in ["M", "F"]
    except Exception:
        raise Exception("Gender must be 'M' or 'F' (required)")


def sanitize_race(r: str) -> str:
    """

        :param r:
        :return:
    """
    race_table = {
        "AMERICAN INDIAN": "I",
        "ASIAN OR PACIFIC ISLANDER": "A",
        "BLACK": "B",
        "HISPANIC": "H",
        "WHITE": "W",
        "UNKNOWN": "U",
        "I": "I",
        "A": "A",
        "B": "B",
        "H": "H",
        "W": "W",
        "U": "I"
    }
    assert r is not None
    race = r.upper().strip()
    if race not in race_table:
        raise Exception("Race must be I,A,B,H,W or U.  (required)")
    return race_table[race]


def sanitize_name(n: str) -> list[str]:
    """

    :param n:
    :return:
    """
    assert n.upper().strip() is not None, "expect name to be populated"
    return n.upper().strip()


def sanitize_first_initial(n: str) -> list[str]:
    """

        :param n:
        :return:
    """
    if n is None:
        return list(ascii_letters)
    else:
        fi = list(sanitize_name(n))
        assert len(fi) >= 1
        return fi


def get_sid(last_name: str, first_initial: str, gender: str, race: str):
    """

        :param last_name:
        :param first_initial:
        :param gender:
        :param race:
        :return:
    """
    response = post(
        "https://inmate.tdcj.texas.gov/InmateSearch/search.action",
        headers={
            "Content-Type": "form-data",
            "referrer": "https://inmate.tdcj.texas.gov/InmateSearch/start",
            "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)" +
                          "AppleWebKit/537.36 (KHTML, like Gecko) " +
                          "Chrome/108.0.0.0 Safari/537.36",
        }, data={
            "page": "index",
            "lastName": last_name,
            "firstName": first_initial,
            "gender": gender,
            "race": race,
            "btnSearch": "Search",
        })
    if response.status_code not in [200,201]:
        print(f"Error: lastname:{last_name} first_initial:{first_initial} "
              f"gender:{gender} race:{race} error: {response.status_code}")
    else:
        data = response.text.split('\n')

# 'InmateSearch/viewDetail.action?sid=' | \
# sed - e
# 's/<a href="/https:\/\/inmate.tdcj.texas.gov/' | \
# sed - e
# 's/">/ : /' | \
# sed - e
# 's/<\/a>//' >> dump.txt


def main():
    """

        :return:
    """
    with open("/opt/data/sids.json") as output:
        # .job file will define the last name, gender and race to query.
        with open("/opt/data/collect_sids.job", "r") as manifest:
            job = loads(manifest.read())
            for task in job:
                last_name = sanitize_name(task.get("last_name", None))
                gender = sanitize_gender(task.get("gender", None))
                race = sanitize_race(task.get("race", None))
                first_initials = sanitize_first_initial(task.get("first_initial", None))
                for first_initial in first_initials:
                    sid, last_name, first_name = get_sid(last_name, first_initial, gender, race)
