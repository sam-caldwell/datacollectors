#!/usr/bin/env python3
#
#
from json import dumps
from json import loads
from os import getenv

from flask import Flask
from flask import request

ip_addr = getenv("BOOT_SERVER_IP", "192.168.3.190")
ip_port = int(getenv("BOOT_SERVER_PORT", "8080"))

app = Flask("server")


@app.route("/log/", methods=["POST"])
def logger():
    data = dumps(loads(request.data), indent=2)
    print(data)
    return "OK", 200


@app.route("/<file>", methods=["GET"])
def boot(file: str):
    with open(f"http/{file}", "r") as f:
        return f.read(), 200

app.run(host=ip_addr, port=ip_port)
