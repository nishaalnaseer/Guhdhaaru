from typing import List, Dict

from fastapi import APIRouter, HTTPException
from sqlalchemy import update

from src.crud.models import CategoryRecord, TypeRecord, AttributeRecord
from src.crud.queries.items import (
    select_category_by_name, select_category_by_id,
    select_last_inserted_type,
    select_type_by_id, select_type_data, select_leaf_node
)
from src.crud.utils import add_object, execute_safely, add_objects
from src.schema.factrories.items import ItemFactory
from src.schema.item import ItemType, ItemAttribute, Item, LeafNode

router = APIRouter(prefix="/item-types", tags=["ItemTypes"])


@router.post("/item-type", status_code=201)
async def create_item_type(item_type: ItemType) -> ItemType:
    if item_type.parent_id is None:
        parent = 0
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
async def update_item_type(item_type: ItemType) -> ItemType:
    if item_type.parent_id is None:
        parent = 0
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

    return ItemFactory.create_half_item_type(updated)


@router.get("/item-type")
async def get_item_type(type_id: int):
    records = await select_type_data(type_id)
    print("hello")
    return [
        ItemFactory.create_half_item_type(record) for record
        in records
    ]


@router.get("/item-type/leaf-node")
async def get_leaf_node(type_id: int) -> LeafNode:
    records = await select_leaf_node(type_id)

    if len(records) == 0:
        raise HTTPException(
            422,
            "No item types found"
        )

    items = {}
    node: Dict[str,  Item] = records[0][2]
    item_type = ItemFactory.create_half_item_type(node)

    for record in records:
        # AttributeValueRecord, AttributeRecord
        value_record, attribute_record = record[0], record[1]

        try:
            _item = items[value_record.item_id]
        except KeyError:
            _item = Item(
                id=value_record.item_id,
                attributes={}
            )
            items[value_record.item_id] = _item

        attribute = ItemFactory.create_attribute(attribute_record)
        attribute.value = ItemFactory.create_attribute_value(
            value_record
        )
        _item.attributes[attribute.name] = attribute

    return LeafNode(
        items=items,
        item_type=item_type
    )
