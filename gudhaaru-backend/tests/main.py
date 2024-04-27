import logging

from src.schema.item import Category
from src.utils.db_initialzation import main as db_init
from tests._test import Test
from tests.client import Client

# Set up basic configuration for logging
logging.basicConfig(level=logging.CRITICAL)


def main():
    db_init()

    client = Client()
    # client.login()

    reqs = {
        "1": Test(
            test_id=1,
            req_url_path="/items/categories/category",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=Category(
                id=0, name="Fastening & Joining",
            ),
        ),
        # "2": Test(
        #     test_id=2,
        #     req_url_path="/clubs/cities/city",
        #     res_status_code=201,
        #     req_type="post",
        #     req_params=None,
        #     req_body=Category(
        #         id=0, name="Pipe, Tubing, Hose & Fittings",
        #     ),
        # )
    }

    for i_id, item in reqs.items():
        client.req(item)
