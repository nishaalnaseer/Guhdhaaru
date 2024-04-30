import asyncio
from typing import Dict

from fastapi import FastAPI
from sqlalchemy import select

from src.crud.models import *
from src.crud.queries.items import select_root_types, select_all_categories
from src.schema.factrories.items import ItemFactory
from src.schema.item import Category, HomePage
from src.utils.utils import lifespan
from src.schema.users import *
from src.endpoints.items.items import router as items

app = FastAPI(lifespan=lifespan)
app.include_router(items)


@app.get("/home-one")
async def home1():
    """
    Not needed really as the data manupulation will be done in
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


@app.get("/home")
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


# talk about load times
