#!/usr/bin/env python3
from hashlib import sha256


def calc_file_hash(file_name: str) -> str:
    with open(file_name, 'r') as f:
        return sha256(f.read().encode('utf-8')).hexdigest()
