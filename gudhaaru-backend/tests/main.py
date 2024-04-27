from src.schema.item import *
from src.utils.db_initialzation import main as db_init
from tests._test import Test
from tests.client import Client


def main():
    db_init()

    client = Client()
    # client.login()

    items_tests = {
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
        "2": Test(
            test_id=2,
            req_url_path="/items/categories/category",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=Category(
                id=0, name="Pipe, Tubing, Hose & Fittings",
            ),
        ),
        "3": Test(
            test_id=3,
            req_url_path="/items/categories/category",
            res_status_code=422,
            req_type="post",
            req_params=None,
            req_body=Category(
                id=0, name="Pipe, Tubing, Hose & Fittings",
            ),
        ),
        "4": Test(
            test_id=4,
            req_url_path="/items/categories/category",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=Category(
                id=0, name="Adhesives & Tape", parent=1
            ),
        ),
        "5": Test(
            test_id=5,
            req_url_path="/items/categories/category",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=Category(
                id=0, name="Fasteners123"
            ),
        ),
        "6": Test(
            test_id=6,
            req_url_path="/items/categories/category",
            res_status_code=201,
            req_type="patch",
            req_params=None,
            req_body=Category(
                id=5, name="Fasteners", parent=1
            ),
        ),
        "7": Test(
            req_url_path="/items/categories/category",
            res_status_code=422,
            req_type="patch",
            req_params=None,
            req_body=Category(
                id=5, name="Adhesives & Tape", parent=1
            ),
        ),
        "8": Test(
            req_url_path="/items/item-types/item-type",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=ItemType(
                id=0, name="Screws and Bolts",
                category=Category(
                    id=5, name="Fasteners", parent=0
                )
            ),
        ),
        "9": Test(
            req_url_path="/items/item-types/item-type",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=ItemType(
                id=0, name="Threaded Rods & Studs",
                category=Category(
                    id=5, name="Fasteners", parent=0
                )
            ),
        ),
        "10": Test(
            req_url_path="/items/item-types/item-type",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=ItemType(
                id=0, name="Adhesives",
                category=Category(
                    id=1, name="Adhesives & Tape", parent=0
                )
            ),
        ),
        "11": Test(
            req_url_path="/items/item-types/item-type",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=ItemType(
                id=0, name="Tapes",
                category=Category(
                    id=1, name="Adhesives & Tape", parent=0
                )
            ),
        ),
        "12": Test(
            req_url_path="/items/item-types/item-type",
            res_status_code=201,
            req_type="patch",
            req_params=None,
            req_body=ItemType(
                id=4, name="Tape",
                category=Category(
                    id=1, name="Adhesives & Tape", parent=0
                )
            ),
        ),
        "13": Test(
            req_url_path="/items/item-types/item-type",
            res_status_code=422,
            req_type="patch",
            req_params=None,
            req_body=ItemType(
                id=4, name="Tape",
                category=Category(
                    id=112312, name="Adhesives & Tape", parent=0
                )
            ),
        ),
    }

    final = items_tests

    for i_id, item in final.items():
        item.test_id = i_id
        client.req(item)
