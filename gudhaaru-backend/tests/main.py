from src.schema.item import *
from src.schema.users import User
from src.schema.vendor import Vendor, Listing
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
                id=1, name="Fastening & Joining", parent_id=1,
            ),
        ),
        "2": Test(
            test_id=2,
            req_url_path="/items/categories/category",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=Category(
                id=1, name="Pipe, Tubing, Hose & Fittings", parent_id=1,
            ),
        ),
        "3": Test(
            test_id=3,
            req_url_path="/items/categories/category",
            res_status_code=422,
            req_type="post",
            req_params=None,
            req_body=Category(
                id=1, name="Pipe, Tubing, Hose & Fittings", parent_id=1,
            ),
        ),
        "4": Test(
            test_id=4,
            req_url_path="/items/categories/category",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=Category(
                id=1, name="Adhesives & Tape", parent_id=2
            ),
        ),
        "5": Test(
            test_id=5,
            req_url_path="/items/categories/category",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=Category(
                id=1, name="Fasteners123", parent_id=1,
            ),
        ),
        "6": Test(
            test_id=6,
            req_url_path="/items/categories/category",
            res_status_code=201,
            req_type="patch",
            req_params=None,
            req_body=Category(
                id=6, name="Fasteners", parent_id=2
            ),
        ),
        "7": Test(
            req_url_path="/items/categories/category",
            res_status_code=422,
            req_type="patch",
            req_params=None,
            req_body=Category(
                id=6, name="Adhesives & Tape", parent_id=2,
            ),
        ),
        "8": Test(
            req_url_path="/items/item-types/item-type",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=ItemType(
                id=1, name="Screws and Bolts", category_id=6, leaf_node=False,
                parent_id=1,
            ),
        ),
        "9": Test(
            req_url_path="/items/item-types/item-type",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=ItemType(
                id=1, name="Threaded Rods & Studs", category_id=6,
                leaf_node=False, parent_id=1,
            ),
        ),
        "10": Test(
            req_url_path="/items/item-types/item-type",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=ItemType(
                id=1, name="Adhesives", category_id=5, leaf_node=False, parent_id=1,
            ),
        ),
        "11": Test(
            req_url_path="/items/item-types/item-type",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=ItemType(
                id=1, name="Tapes", category_id=2, leaf_node=False, parent_id=1,
            ),
        ),
        "12": Test(
            req_url_path="/items/item-types/item-type",
            res_status_code=201,
            req_type="patch",
            req_params=None,
            req_body=ItemType(
                id=5, name="Tape", category_id=5, leaf_node=False, parent_id=1,
            ),
        ),
        "13": Test(
            req_url_path="/items/item-types/item-type",
            res_status_code=422,
            req_type="patch",
            req_params=None,
            req_body=ItemType(
                id=5, name="Tape", category_id=112312, leaf_node=False, parent_id=1,
            ),
        ),
        "14": Test(
            req_url_path="/items/item-types/item-type",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=ItemType(
                id=1, name="Socket Head Screws", parent_id=2, category_id=6,
                leaf_node=False
            ),
        ),
        "15": Test(
            req_url_path="/items/item-types/item-type",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=ItemType(
                id=1, name="1-64", parent_id=6, category_id=6, leaf_node=False,
            ),
        ),
        "16": Test(
            req_url_path="/items/item-types/item-type",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=ItemType(
                id=1, name="Black - Oxide Alloy Steel", parent_id=7,
                category_id=6, leaf_node=True
            ),
        ),
        "17": Test(
            req_url_path="/items/item/attributes",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=[
                # todo if [POST] /items/item/attributes item type is not a leaf node
                #  raise 422
                ItemAttribute(id=1, name="Lg.", type_id=8),
                ItemAttribute(id=1, name="Threading", type_id=8),
                ItemAttribute(id=1, name="Thread Spacing", type_id=8),
                ItemAttribute(id=1, name="Dia.", type_id=8),
                ItemAttribute(id=1, name="Ht.", type_id=8),
                ItemAttribute(id=1, name="Drive Size", type_id=8),
                ItemAttribute(id=1, name="Tensile Strength, psi", type_id=8),
            ],
        ),
        "18": Test(
            req_url_path="/items/item/attributes-value",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=[
                ItemAttributeValue(id=1, value='3', attribute=1),
                ItemAttributeValue(id=1, value='Fully Threaded', attribute=2),
                ItemAttributeValue(id=1, value='Coarse', attribute=3),
                ItemAttributeValue(id=1, value='2.5', attribute=4),
                ItemAttributeValue(id=1, value='1.4', attribute=5),
                ItemAttributeValue(id=1, value='1.3', attribute=6),
                ItemAttributeValue(id=1, value='170,000', attribute=7)
            ],
        ),
        "19": Test(
            req_url_path="/items/categories/category",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=Category(
                id=1, name="Welding, Brazing & Soldering", parent_id=1
            )
        ),
        "20": Test(
            req_url_path="/items/categories/category",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=Category(
                id=1, name="Filtering", parent_id=1,
            )
        ),
        "21": Test(
            req_url_path="/items/categories/category",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=Category(
                id=1, name="Power Transmission", parent_id=1,
            )
        ),
        "22": Test(
            req_url_path="/items/categories/category",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=Category(
                id=1, name="Sealing", parent_id=1,
            )
        ),
        "23": Test(
            req_url_path="/items/categories/category",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=Category(
                id=1, name="Flow & Level Control", parent_id=1,
            )
        ),
        "24": Test(
            req_url_path="/items/categories/category",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=Category(
                id=1, name="Pressure & Temperature Control", parent_id=1,
            )
        ),
        "25": Test(
            req_url_path="/items/categories/category",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=Category(
                id=1, name="Rotary Motion", parent_id=9
            )
        ),
        "26": Test(
            req_url_path="/items/categories/category",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=Category(
                id=1, name="Linear Motion", parent_id=9
            )
        ),
        "27": Test(
            req_url_path="/items/categories/category",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=Category(
                id=1, name="Hydraulics", parent_id=9
            )
        ),
        "28": Test(
            req_url_path="/items/categories/category",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=Category(
                id=1, name="Pneumatics", parent_id=9
            )
        ),
        "29": Test(
            req_url_path="/items/categories/category",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=Category(
                id=1, name="Flow", parent_id=11
            )
        ),
        "30": Test(
            req_url_path="/items/categories/category",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=Category(
                id=1, name="Liquid Level", parent_id=11
            )
        ),
        "31": Test(
            req_url_path="/items/categories/category",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=Category(
                id=1, name="Pressure", parent_id=11
            )
        ),
        "32": Test(
            req_url_path="/items/categories/category",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=Category(
                id=1, name="Temperature", parent_id=12
            )
        ),
        "33": Test(
            req_url_path="/items/item-types/item-type",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=ItemType(
                id=1, name="Actuators", category_id=14, leaf_node=False, parent_id=1,
            ),
        ),
        "34": Test(
            req_url_path="/items/item-types/item-type",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=ItemType(
                id=1, name="Bearings", category_id=14, leaf_node=False, parent_id=1,
            ),
        ),
        "35": Test(
            req_url_path="/items/item-types/item-type",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=ItemType(
                id=1, name="Shafts", category_id=14, leaf_node=False, parent_id=1,
            ),
        ),
        "36": Test(
            req_url_path="/items/item-types/item-type",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=ItemType(
                id=1, name="Pumps", category_id=15, leaf_node=False, parent_id=1,
            ),
        ),
        "37": Test(
            req_url_path="/items/item-types/item-type",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=ItemType(
                id=1, name="Valves", category_id=15, leaf_node=False, parent_id=1,
            ),
        ),
        "38": Test(
            req_url_path="/items/item-types/item-type",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=ItemType(
                id=1, name="Hose", category_id=15, leaf_node=False, parent_id=1,
            ),
        ),
        "39": Test(
            req_url_path="/items/item-types/item-type",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=ItemType(
                id=1, name="Hose Fittings", category_id=15, leaf_node=False,
                parent_id=1,
            ),
        ),
        "40": Test(
            req_url_path="/items/item-types/item-type",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=ItemType(
                id=1, name="Filters", category_id=15, leaf_node=False,
                parent_id=1,
            ),
        ),
        "41": Test(
            req_url_path="/items/item-types/item-type",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=ItemType(
                id=1, name="Oil", category_id=15, leaf_node=False, parent_id=1,
            ),
        ),
        "42": Test(
            req_url_path="/items/item-types/item-type",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=ItemType(
                id=1, name="Reservoirs", category_id=15, leaf_node=False, parent_id=1,
            ),
        ),
        "43": Test(
            req_url_path="/items/item-types/item-type",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=ItemType(
                id=1, name="O-Rings", category_id=10, leaf_node=False,
                parent_id=1,
            ),
        ),
        "44": Test(
            req_url_path="/items/item-types/item-type",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=ItemType(
                id=1, name="Compression Packing", category_id=10, leaf_node=False,
                parent_id=1,
            ),
        ),
        "45": Test(
            req_url_path="/items/item-types/item-type",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=ItemType(
                id=1, name="Packing Tools", category_id=10, leaf_node=False,
                parent_id=1,
            ),
        ),
        "46": Test(
            req_url_path="/items/item-types/item-type",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=ItemType(
                id=1, name="Gaskets", category_id=10, leaf_node=False,
                parent_id=1,
            ),
        ),
        "47": Test(
            req_url_path="/items/item-types/item-type",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=ItemType(
                id=1, name="Mechanical Seals", category_id=10, leaf_node=False,
                parent_id=1,
            ),
        ),
        "48": Test(
            req_url_path="/items/item-types/item-type",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=ItemType(
                id=1, name="Weather-stripping", category_id=10, leaf_node=False,
                parent_id=1,
            ),
        ),
        "49": Test(
            req_url_path="/items/item-types/item-type",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=ItemType(
                id=1, name="Sealants", category_id=10, leaf_node=False,
                parent_id=1,
            ),
        ),
        "50": Test(
            req_url_path="/items/item/attributes-value",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=[
                ItemAttributeValue(id=1, value='4', attribute=1),
                ItemAttributeValue(id=1, value='Fully Threaded', attribute=2),
                ItemAttributeValue(id=1, value='Coarse', attribute=3),
                ItemAttributeValue(id=1, value='2.5', attribute=4),
                ItemAttributeValue(id=1, value='1.4', attribute=5),
                ItemAttributeValue(id=1, value='1.3', attribute=6),
                ItemAttributeValue(id=1, value='170,000', attribute=7)
            ],
        ),
    }

    final = items_tests

    for i_id, _test in final.items():
        _test.test_id = i_id
        client.req(_test)

    content = Test(
        test_id=-1,
        req_url_path="/items/item-types/item-type/leaf-node",
        res_status_code=200,
        req_type="get",
        req_params={
            "type_id": 8
        },
        req_body=None
    )
    response = client.req(content)

    if response is None:
        return

    leaf = LeafNode(**json.loads(response))
    item: Item = list(leaf.items.values())[0]

    _next = {
        "51": Test(
            req_url_path="/vendors/vendor",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=Vendor(
                id=0,
                name="Good Hardware",
                email="nishawl.naseer@outlook.com",
                location="Ameenee Magu",
                status="ENABLED",
                super_admin=1,
            ),
        ),
        "52": Test(
            req_url_path="/vendors/vendor",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=Vendor(
                id=0,
                name="Great Hardware Henveyru",
                email="nishawl.naseer1@outlook.com",
                location="Henveyru",
                status="ENABLED",
                super_admin=1,
            ),
        ),
        "53": Test(
            req_url_path="/vendors/vendor",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=Vendor(
                id=0,
                name="Good Hardware Galolhu",
                email="nishawl.naseer2@outlook.com",
                location="Galolhu",
                status="ENABLED",
                super_admin=1,
            ),
        ),
        "54": Test(
            req_url_path="/vendors/listings/listing",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=Listing(
                id=0,
                item_id=item.id,
                vendor=1,
                status="ENABLED",
                super_admin=1,
            ),
        ),
        "55": Test(
            req_url_path="/vendors/listings/listing",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=Listing(
                id=0,
                item_id=item.id,
                vendor=3
            ),
        ),
        "56": Test(
            req_url_path="/vendors/listings/listing",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=Listing(
                id=0,
                item_id=item.id,
                vendor=2
            ),
        ),
        "57": Test(
            req_url_path="/users/user/register",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=User(
                id=0,
                name="Nishaal",
                email="nishaalnaseer4@gmail.com",
                is_admin=True,
                enabled=True,
            ),
            xtra_args={"password": "1234567"}
        ),
        "58": Test(
            req_url_path="/users/user/register",
            res_status_code=422,
            req_type="post",
            req_params=None,
            req_body=User(
                id=0,
                name="Nishaal",
                email="nishaalnaseer4@gmail.com",
                is_admin=True,
                enabled=True,
            ),
            xtra_args={"password": "1234567"}
        ),
        "59": Test(
            req_url_path="/items/item/attributes-value",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=[
                ItemAttributeValue(id=1, value='4', attribute=1),
                ItemAttributeValue(id=1, value='Fully Threaded', attribute=2),
                ItemAttributeValue(id=1, value='Coarse', attribute=3),
                ItemAttributeValue(id=1, value='2.3', attribute=4),
                ItemAttributeValue(id=1, value='1.5', attribute=5),
                ItemAttributeValue(id=1, value='1.3', attribute=6),
                ItemAttributeValue(id=1, value='170,000', attribute=7)
            ],
        ),
        "60": Test(
            req_url_path="/items/item/attributes-value",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=[
                ItemAttributeValue(id=1, value='4', attribute=1),
                ItemAttributeValue(id=1, value='Fully Threaded', attribute=2),
                ItemAttributeValue(id=1, value='Coarse', attribute=3),
                ItemAttributeValue(id=1, value='2.0', attribute=4),
                ItemAttributeValue(id=1, value='1.4', attribute=5),
                ItemAttributeValue(id=1, value='1.3', attribute=6),
                ItemAttributeValue(id=1, value='170,000', attribute=7)
            ],
        ),
        "61": Test(
            req_url_path="/items/item/attributes-value",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=[
                ItemAttributeValue(id=1, value='4', attribute=1),
                ItemAttributeValue(id=1, value='Half Threaded', attribute=2),
                ItemAttributeValue(id=1, value='Coarse', attribute=3),
                ItemAttributeValue(id=1, value='2.5', attribute=4),
                ItemAttributeValue(id=1, value='1.4', attribute=5),
                ItemAttributeValue(id=1, value='1.3', attribute=6),
                ItemAttributeValue(id=1, value='170,000', attribute=7)
            ],
        ),
        "62": Test(
            req_url_path="/items/item/attributes-value",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=[
                ItemAttributeValue(id=1, value='4', attribute=1),
                ItemAttributeValue(id=1, value='Quarter Threaded', attribute=2),
                ItemAttributeValue(id=1, value='Coarse', attribute=3),
                ItemAttributeValue(id=1, value='2.5', attribute=4),
                ItemAttributeValue(id=1, value='1.4', attribute=5),
                ItemAttributeValue(id=1, value='1.3', attribute=6),
                ItemAttributeValue(id=1, value='170,000', attribute=7)
            ],
        ),
    }

    for i_id, _test in _next.items():
        _test.test_id = i_id
        client.req(_test)

    content = Test(
        test_id=-2,
        req_url_path="/items/item-types/item-type/leaf-node",
        res_status_code=200,
        req_type="get",
        req_params={
            "type_id": 8
        },
        req_body=None
    )
    response = client.req(content)
    if response is None:
        return
    leaf = LeafNode(**json.loads(response))

    item_one: Item = list(leaf.items.values())[0]
    item_two: Item = list(leaf.items.values())[1]
    item_three: Item = list(leaf.items.values())[2]
    item_four: Item = list(leaf.items.values())[3]
    item_five: Item = list(leaf.items.values())[4]

    _listings = {
        "63": Test(
            req_url_path="/vendors/listings/listing",
            res_status_code=422,
            req_type="post",
            req_params=None,
            req_body=Listing(
                id=0,
                item_id=item_one.id,
                vendor=1,
                status="ENABLED",
                super_admin=1,
            ),
        ),
        "64": Test(
            req_url_path="/vendors/listings/listing",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=Listing(
                id=0,
                item_id=item_two.id,
                vendor=1,
                status="ENABLED",
                super_admin=1,
            ),
        ),
        "66": Test(
            req_url_path="/vendors/listings/listing",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=Listing(
                id=0,
                item_id=item_three.id,
                vendor=1,
                status="ENABLED",
                super_admin=1,
            ),
        ),
        "67": Test(
            req_url_path="/vendors/listings/listing",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=Listing(
                id=0,
                item_id=item_four.id,
                vendor=1,
                status="ENABLED",
                super_admin=1,
            ),
        ),
        "68": Test(
            req_url_path="/vendors/listings/listing",
            res_status_code=201,
            req_type="post",
            req_params=None,
            req_body=Listing(
                id=0,
                item_id=item_five.id,
                vendor=1,
                status="ENABLED",
                super_admin=1,
            ),
        ),
    }

    for i_id, _test in _listings.items():
        _test.test_id = i_id
        client.req(_test)
