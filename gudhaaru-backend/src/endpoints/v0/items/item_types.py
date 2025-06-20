from collections import defaultdict
from typing import Annotated

from fastapi import APIRouter, HTTPException, Security
from sqlalchemy import update, delete

from src.crud.models import TypeRecord
from src.crud.queries.items import (
    select_last_inserted_type,
    select_type_by_id, select_type_data, select_leaf_node
)
from src.crud.utils import add_object, execute_safely
from src.schema.factrories.items import ItemFactory
from src.schema.item import ItemType, Item, LeafNode
from src.schema.users import User
from src.security.security import get_current_active_user
from src.utils.utils import check_admin

router = APIRouter(prefix="/item-types", tags=["ItemTypes"])


@router.post("/item-type", status_code=201)
async def create_item_type(
        current_user: Annotated[
            User, Security(get_current_active_user, scopes=[])
        ],
        item_type: ItemType
) -> ItemType:
    check_admin(current_user)
    if item_type.parent_id is None:
        parent = 1
    else:
        parent = item_type.parent_id

    record = TypeRecord(
        name=item_type.name,
        parent=parent,
        # todo get category id from db and validate
        category=item_type.category_id,
        leaf_node=item_type.leaf_node
    )

    await add_object(record)
    inserted = await select_last_inserted_type(
        item_type.name, parent, item_type.category_id
    )

    return ItemFactory.create_half_item_type(inserted)


@router.patch("/item-type", status_code=201)
async def update_item_type(
        current_user: Annotated[
            User, Security(get_current_active_user, scopes=[])
        ],
        item_type: ItemType
) -> ItemType:
    check_admin(current_user)
    if item_type.parent_id is None:
        parent = 1
    else:
        parent = item_type.parent_id

    query = update(
        TypeRecord
    ).values(
        name=item_type.name,
        parent=parent,
        # todo get category id from db and validate
        category=item_type.category_id,
        leaf_node=item_type.leaf_node
    ).where(
        TypeRecord.id == item_type.id
    )
    await execute_safely(query)
    updated = await select_type_by_id(item_type.id)

    if updated is None:
        raise HTTPException(404, "Item Type not found")

    return ItemFactory.create_half_item_type(updated)


@router.get("/item-type")
async def get_item_type(type_id: int):
    records = await select_type_data(type_id)
    return [
        ItemFactory.create_half_item_type(record) for record
        in records
    ]


@router.get("/item-type/leaf-node")
async def get_leaf_node(type_id: int) -> LeafNode:
    records = await select_leaf_node(type_id)

    if len(records) == 0:
        raise HTTPException(
            404,
            "No item type found"
        )

    items = defaultdict(dict)
    attributes = {}
    node = records[0][2]
    item_type = ItemFactory.create_half_item_type(node)

    for record in records:
        attribute_record = record[1]
        if attribute_record is None:
            continue

        attribute = ItemFactory.create_attribute(attribute_record)
        attributes[attribute.id] = attribute

    for record in records:
        value_record = record[0]

        if value_record is None:
            continue

        value = ItemFactory.create_attribute_value(value_record)
        items[value.item_id][value.attribute] = value

    return LeafNode(
        items={
            key: Item(id=key, attributes=value) for key, value in items.items()
        },
        item_type=item_type,
        attributes=attributes
    )


@router.delete("/item-types/item-type", status_code=204)
async def delete_item_type(
        current_user: Annotated[
            User, Security(get_current_active_user, scopes=[])
        ],
        item_type: int
):
    check_admin(current_user)
    if item_type == 1:
        raise HTTPException(
            403,
            "Forbidden to delete a root node"
        )

    query = delete(
        TypeRecord
    ).where(TypeRecord.id == item_type)
    await execute_safely(query)
