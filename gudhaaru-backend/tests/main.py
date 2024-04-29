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
        "14": Test(
            req_url_path="/items/item-types/item-type",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=ItemType(
                id=0, name="Socket Head Screws", parent=1,
                category=Category(
                    id=5, name="Screws and Bolts", parent=1
                )
            ),
        ),
        "15": Test(
            req_url_path="/items/item-types/item-type",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=ItemType(
                id=0, name="1-64", parent=5,
                category=Category(
                    id=5, name="Screws and Bolts", parent=1
                )
            ),
        ),
        "16": Test(
            req_url_path="/items/item-types/item-type",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=ItemType(
                id=0, name="Black - Oxide Alloy Steel", parent=6,
                category=Category(
                    id=5, name="Screws and Bolts", parent=1
                )
            ),
        ),
        "17": Test(
            req_url_path="/items/item/attributes",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=[
                ItemAttribute(id=0, name="Lg.", type_id=6),
                ItemAttribute(id=0, name="Threading", type_id=6),
                ItemAttribute(id=0, name="Thread Spacing", type_id=6),
                ItemAttribute(id=0, name="Dia.", type_id=6),
                ItemAttribute(id=0, name="Ht.", type_id=6),
                ItemAttribute(id=0, name="Drive Size", type_id=6),
                ItemAttribute(id=0, name="Tensile Strength, psi", type_id=6),
            ],
        ),
        "18": Test(
            req_url_path="/items/item/attributes-value",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=[
                ItemAttributeValue(id=0, value='3', attribute=1),
                ItemAttributeValue(id=0, value='Fully Threaded', attribute=2),
                ItemAttributeValue(id=0, value='Coarse', attribute=3),
                ItemAttributeValue(id=0, value='2.5', attribute=4),
                ItemAttributeValue(id=0, value='1.4', attribute=5),
                ItemAttributeValue(id=0, value='1.3', attribute=6),
                ItemAttributeValue(id=0, value='170,000', attribute=7)
            ],
        ),
        "19": Test(
            req_url_path="/items/categories/category",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=Category(
                id=0, name="Welding, Brazing & Soldering", parent=1
            )
        ),
        "20": Test(
            req_url_path="/items/categories/category",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=Category(
                id=0, name="Filtering"
            )
        ),
        "21": Test(
            req_url_path="/items/categories/category",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=Category(
                id=0, name="Power Transmission"
            )
        ),
        "22": Test(
            req_url_path="/items/categories/category",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=Category(
                id=0, name="Sealing"
            )
        ),
        "23": Test(
            req_url_path="/items/categories/category",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=Category(
                id=0, name="Flow & Level Control"
            )
        ),
        "24": Test(
            req_url_path="/items/categories/category",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=Category(
                id=0, name="Pressure & Temperature Control"
            )
        ),
        "25": Test(
            req_url_path="/items/categories/category",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=Category(
                id=0, name="Rotary Motion", parent=8
            )
        ),
        "26": Test(
            req_url_path="/items/categories/category",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=Category(
                id=0, name="Linear Motion", parent=8
            )
        ),
        "27": Test(
            req_url_path="/items/categories/category",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=Category(
                id=0, name="Hydraulics", parent=8
            )
        ),
        "28": Test(
            req_url_path="/items/categories/category",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=Category(
                id=0, name="Pneumatics", parent=8
            )
        ),
        "29": Test(
            req_url_path="/items/categories/category",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=Category(
                id=0, name="Flow", parent=10
            )
        ),
        "30": Test(
            req_url_path="/items/categories/category",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=Category(
                id=0, name="Liquid Level", parent=10
            )
        ),
        "31": Test(
            req_url_path="/items/categories/category",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=Category(
                id=0, name="Pressure", parent=10
            )
        ),
        "32": Test(
            req_url_path="/items/categories/category",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=Category(
                id=0, name="Temperature", parent=10
            )
        ),
        "33": Test(
            req_url_path="/items/item-types/item-type",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=ItemType(
                id=0, name="Actuators",
                category=Category(
                    id=13, name="Linear Motion", parent=8
                )
            ),
        ),
        "34": Test(
            req_url_path="/items/item-types/item-type",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=ItemType(
                id=0, name="Bearings",
                category=Category(
                    id=13, name="Linear Motion", parent=8
                )
            ),
        ),
        "35": Test(
            req_url_path="/items/item-types/item-type",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=ItemType(
                id=0, name="Shafts",
                category=Category(
                    id=13, name="Linear Motion", parent=8
                )
            ),
        ),
        "36": Test(
            req_url_path="/items/item-types/item-type",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=ItemType(
                id=0, name="Pumps",
                category=Category(
                    id=14, name="Hydraulics", parent=8
                )
            ),
        ),
        "37": Test(
            req_url_path="/items/item-types/item-type",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=ItemType(
                id=0, name="Valves",
                category=Category(
                    id=14, name="Hydraulics", parent=8
                )
            ),
        ),
        "38": Test(
            req_url_path="/items/item-types/item-type",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=ItemType(
                id=0, name="Hose",
                category=Category(
                    id=14, name="Hydraulics", parent=8
                )
            ),
        ),
        "39": Test(
            req_url_path="/items/item-types/item-type",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=ItemType(
                id=0, name="Hose Fittings",
                category=Category(
                    id=14, name="Hydraulics", parent=8
                )
            ),
        ),
        "40": Test(
            req_url_path="/items/item-types/item-type",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=ItemType(
                id=0, name="Filters",
                category=Category(
                    id=14, name="Hydraulics", parent=8
                )
            ),
        ),
        "41": Test(
            req_url_path="/items/item-types/item-type",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=ItemType(
                id=0, name="Oil",
                category=Category(
                    id=14, name="Hydraulics", parent=8
                )
            ),
        ),
        "42": Test(
            req_url_path="/items/item-types/item-type",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=ItemType(
                id=0, name="Reservoirs",
                category=Category(
                    id=14, name="Hydraulics", parent=8
                )
            ),
        ),
        "43": Test(
            req_url_path="/items/item-types/item-type",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=ItemType(
                id=0, name="O-Rings",
                category=Category(
                    id=9, name="Sealing", parent=0
                )
            ),
        ),
        "44": Test(
            req_url_path="/items/item-types/item-type",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=ItemType(
                id=0, name="Compression Packing",
                category=Category(
                    id=9, name="Sealing", parent=0
                )
            ),
        ),
        "45": Test(
            req_url_path="/items/item-types/item-type",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=ItemType(
                id=0, name="Packing Tools",
                category=Category(
                    id=9, name="Sealing", parent=0
                )
            ),
        ),
        "46": Test(
            req_url_path="/items/item-types/item-type",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=ItemType(
                id=0, name="Gaskets",
                category=Category(
                    id=9, name="Sealing", parent=0
                )
            ),
        ),
        "47": Test(
            req_url_path="/items/item-types/item-type",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=ItemType(
                id=0, name="Mechanical Seals",
                category=Category(
                    id=9, name="Sealing", parent=0
                )
            ),
        ),
        "48": Test(
            req_url_path="/items/item-types/item-type",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=ItemType(
                id=0, name="Weather-stripping",
                category=Category(
                    id=9, name="Sealing", parent=0
                )
            ),
        ),
        "49": Test(
            req_url_path="/items/item-types/item-type",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=ItemType(
                id=0, name="Sealants",
                category=Category(
                    id=9, name="Sealing", parent=0
                )
            ),
        ),
    }

    final = items_tests

    for i_id, item in final.items():
        item.test_id = i_id
        client.req(item)
