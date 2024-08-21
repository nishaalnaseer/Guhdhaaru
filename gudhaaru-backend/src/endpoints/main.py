import asyncio
from typing import Dict

from fastapi import APIRouter

from src.crud.queries.items import select_root_types, select_all_categories
from src.endpoints.v0.items.items import router as items, get_item
from src.endpoints.v0.vendors.listings import get_listings
from src.endpoints.v0.vendors.vendor import router as vendors
from src.endpoints.v0.users.user import router as users
from src.schema.factrories.items import ItemFactory
from src.schema.item import Category, HomePage
from src.schema.vendor import ListingsPage

router = APIRouter(prefix="/v0")
router.include_router(items)
router.include_router(vendors)
router.include_router(users)


@router.get("/home-one")
async def home1():
    """
    Not needed really as the data manipulation will be done in
    the client but will be kept here as a reference
    """
    type_records, category_records = await asyncio.gather(
        select_root_types(), select_all_categories()
    )

    categories: Dict[int, Category] = {
        record.id: ItemFactory.create_category(record)
        for record in category_records
    }
    final: Dict[int, Category] = {}
    for id_, category in categories.items():
        parent_id = category.parent_id

        if parent_id == 0:
            final.update({id_: category})
            continue

        parent = categories[category.parent_id]
        parent.add_child(category)

    for type_record in type_records:
        # no recursions here because all item_type nodes here are root nodes
        item_type = ItemFactory.create_half_item_type(type_record)
        category_id: int = item_type.category_id
        category = categories[category_id]
        category.add_type(item_type)

    return final


@router.get("/home")
async def home() -> HomePage:
    type_records, category_records = await asyncio.gather(
        select_root_types(), select_all_categories()
    )

    categories = [
        ItemFactory.create_category(record) for record in category_records
    ]
    types = [
        ItemFactory.create_half_item_type(record) for record in type_records
    ]

    return HomePage(
        types=types,
        categories=categories
    )


@router.get("/listings_page")
async def get_listings_page(item_id: int) -> ListingsPage:
    item, listings = await asyncio.gather(get_item(item_id), get_listings(item_id))
    return ListingsPage(item=item, listings=listings)
