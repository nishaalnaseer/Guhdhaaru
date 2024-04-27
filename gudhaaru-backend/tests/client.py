import os
import json
import requests

from tests._logger import get_logger
from tests._test import Test


class Client:
    def __init__(self):
        self._headers: dict | None = None
        host = os.getenv("host")
        port = os.getenv("port")

        if host == "0.0.0.0":
            _host = "127.0.0.1"
        else:
            _host = host

        self._server = f"http://{_host}:{port}"
        self._logger = get_logger(f"Logging {__name__}")

    def login(self):
        username = "nishawl.naseer@outlook.com"
        password = "123"
        data = f'grant_type=&username={username}&password={password}&scope=&client_id=&client_secret='
        headers = {
            'accept': 'application/json',
            'Content-Type': 'application/x-www-form-urlencoded'
        }

        response = requests.post(
            f"{self._server}/token",
            data=data,
            headers=headers
        )
        content = json.loads(response.content)

        _token = content["access_token"]
        token_type = content["token_type"]
        token = f"{token_type} {_token}"

        self._headers = {
            'accept': 'application/json',
            "Authorization": token
        }

    def req(self, _test: Test):
        if _test.req_body is not None:
            _body = _test.req_body.model_dump()
        else:
            _body = None

        if _test.req_type == "post":
            response = requests.post(
                url=f"{self._server}{_test.req_url_path}",
                json=_body, params=_test.req_params,
                headers=self._headers
            )
        elif _test.req_type == "patch":
            response = requests.patch(
                url=f"{self._server}{_test.req_url_path}",
                json=_body, params=_test.req_params,
                headers=self._headers
            )
        else:
            raise Exception("invalid req type")

        if response.status_code != _test.res_status_code:
            self._logger.error(
                f"Test ID: {_test.test_id} returned {response.status_code}"
            )
            self._logger.error(
                f"Response: {json.loads(response.content.decode())}"
            )
        else:
            self._logger.info(
                f"Test ID: {_test.test_id} succeeded"
            )
