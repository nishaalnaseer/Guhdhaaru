from typing import List

from fastapi import APIRouter, HTTPException
from sqlalchemy import update

from src.crud.models import CategoryRecord, TypeRecord, AttributeRecord
from src.crud.queries.items import (
    select_category_by_name, select_category_by_id, select_last_inserted_type,
    select_type_by_id
)
from src.crud.utils import add_object, execute_safely, add_objects
from src.schema.factrories.items import ItemFactory
from src.schema.item import ItemType, ItemAttribute

router = APIRouter(prefix="/item-types", tags=["ItemTypes"])


@router.post("/item-type", status_code=201)
async def create_item_type(item_type: ItemType) -> ItemType:
    if item_type.category is None or type(item_type.category) is int:
        raise HTTPException(
            status_code=422, detail="Category must be an object"
        )

    if item_type.parent_id is None:
        parent = 0
    else:
        parent = item_type.parent_id

    record = TypeRecord(
        name=item_type.name,
        parent=parent,
        category=item_type.category.id  # todo get category id from db and validate
    )

    await add_object(record)
    inserted = await select_last_inserted_type(
        item_type.name, parent, item_type.category.id
    )

    return ItemFactory.create_half_item_type(inserted)


@router.patch("/item-type", status_code=201)
async def update_item_type(item_type: ItemType) -> ItemType:
    if item_type.category is None or type(item_type.category) is int:
        raise HTTPException(
            status_code=422, detail="Category must be an object"
        )

    if item_type.parent_id is None:
        parent = 0
    else:
        parent = item_type.parent_id

    query = update(
        TypeRecord
    ).values(
        name=item_type.name,
        parent=parent,
        category=item_type.category.id  # todo get category id from db and validate
    ).where(
        TypeRecord.id == item_type.id
    )
    await execute_safely(query)
    updated = await select_type_by_id(item_type.id)

    return ItemFactory.create_half_item_type(updated)
