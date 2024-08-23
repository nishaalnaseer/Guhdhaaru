
import json
import urllib.parse

from httpx import Client as SyncClient
from src.utils.settings import *
from src.utils.my_logger import get_logger
from tests._test import Test


class Client:
    def __init__(self):
        self._headers: dict | None = None
        self._client = SyncClient()

        if HOST == "0.0.0.0":
            _host = "127.0.0.1"
        else:
            _host = HOST

        self._server = f"http://{_host}:{PORT}"
        self._logger = get_logger(f"Logging {__name__}")
        self.login()

    def login(self):
        username = ADMIN1_EMAIL
        password = ADMIN1_PASSWORD
        data = (f'grant_type=&username={username}&password={password}'
                f'&scope=&client_id=&client_secret=')
        encoded_string = urllib.parse.quote(data)
        headers = {
            'accept': 'application/json',
            'Content-Type': 'application/x-www-form-urlencoded'
        }

        response = self._client.post(
            url=f"{self._server}/token",
            content=data,
            headers=headers
        )

        if response.status_code != 201:
            raise Exception(
                f"Error while login in. "
                f"Server returned {response.status_code}\n"
                f"Content: {response.content.decode('utf-8')}"
            )

        content = json.loads(response.content)

        _token = content["access_token"]
        token_type = content["token_type"]
        token = f"{token_type} {_token}"

        self._headers = {
            'accept': 'application/json',
            "Authorization": token
        }

    def req(self, _test: Test) -> str | None:
        if _test.req_body is not None:
            if type(_test.req_body) is list:
                _body = [
                    x.model_dump() for x in _test.req_body
                ]
            else:
                _body = _test.req_body.model_dump()
                _body.update(_test.xtra_args)
        else:
            _body = None
        url = f"{self._server}{_test.version}{_test.req_url_path}"
        if _test.req_type.lower() == "post":
            response = self._client.post(
                url=url,
                json=_body, params=_test.req_params,
                headers=self._headers
            )
        elif _test.req_type == "patch":
            response = self._client.patch(
                url=url,
                json=_body, params=_test.req_params,
                headers=self._headers
            )
        elif _test.req_type == "get":
            response = self._client.get(
                url=url,
                params=_test.req_params,
                headers=self._headers
            )
        else:
            raise Exception("invalid req type")

        if response.status_code != _test.res_status_code:
            self._logger.error(
                f"Test ID: {_test.test_id} returned {response.status_code} "
                f"expected: {_test.res_status_code}"
            )

            if response.status_code >= 500 or response.status_code == 204:
                return

            self._logger.error(
                f"Response: {json.loads(response.content.decode())}"
            )
        else:
            self._logger.info(
                f"Test ID: {_test.test_id} succeeded"
            )
            return response.content.decode()
