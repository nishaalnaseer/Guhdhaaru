from typing import List
from fastapi import APIRouter, HTTPException
from sqlalchemy import update, delete

from src.crud.models import AttributeRecord, AttributeValueRecord
from src.crud.queries.items import (
    select_attributes, select_attribute2, select_item_by_id, select_attribute,
    select_attribute_value, select_last_inserted_attr, select_last_inserted_value,
    select_item
)
from src.crud.raw_sql import get_new_item_id
from src.crud.utils import add_objects, select_query_scalar, execute_safely, add_object
from src.endpoints.v0.items.category import router as categories
from src.endpoints.v0.items.item_types import router as item_types
from src.schema.factrories.items import ItemFactory
from src.schema.item import ItemAttribute, ItemAttributeValue, SingleItem

router = APIRouter(prefix="/items", tags=["Items"])
router.include_router(categories)
router.include_router(item_types)


@router.post("/item/attributes", status_code=201)
async def create_attributes(
        attributes: List[ItemAttribute]
) -> List[ItemAttribute]:
    if len(attributes) != 0:
        pass
    else:
        raise HTTPException(422, "No attributes")

    type_id = attributes[0].type_id
    records = []

    for attribute in attributes:
        records.append(
            AttributeRecord(
                item_type=attribute.type_id,
                name=attribute.name,
            )
        )
        if type_id != attribute.type_id:
            raise HTTPException(
                status_code=422,
                detail="Type ID must be the same for all attributes"
            )

    await add_objects(records)
    records = await select_attributes(type_id)
    return ItemFactory.create_attributes(records)


@router.post("/item/attributes-value", status_code=201)
async def create_attributes_value(
        values: List[ItemAttributeValue]
):
    if len(values) == 0:
        raise HTTPException(422, "No attributes")

    _records = await select_attribute2(values[0].attribute)

    _attribute_ids = {record.id for record in _records}
    if len(_attribute_ids) == 0:
        raise HTTPException(
            422, "Attribute not found"
        )

    for value in values:
        if value.attribute not in _attribute_ids:
            raise HTTPException(
                422,
                "Attribute ID in request not in attribute id of the item type"
            )

    result = await select_query_scalar(get_new_item_id)
    random_num = int(result)

    records = [
        AttributeValueRecord(
            item_id=random_num,
            attribute=value.attribute,
            value=value.value,
        ) for value in values
    ]

    await add_objects(records)

    inserted = await select_item_by_id(random_num)
    return ItemFactory.create_item(inserted)


@router.patch("/item/attribute", status_code=201)
async def update_attribute(attribute: ItemAttribute) -> ItemAttribute:
    query = update(
        AttributeRecord
    ).values(
        name=attribute.name,
        item_type=attribute.type_id
    ).where(
        AttributeRecord.id == attribute.id
    )
    await execute_safely(query)

    record = await select_attribute(attribute.id)

    if record is None:
        raise HTTPException(
            404, "Attribute not found"
        )

    return ItemFactory.create_attribute(record)


@router.patch("/item/attribute-value", status_code=201)
async def update_attribute_value(value: ItemAttributeValue) -> ItemAttributeValue:
    query = update(
        AttributeValueRecord
    ).values(
        attribute=value.attribute,
        value=value.value
    ).where(
        AttributeValueRecord.id == value.id
    )
    await execute_safely(query)

    record = await select_attribute_value(value.id)

    if record is None:
        raise HTTPException(
            404, "Attribute not found"
        )
    return ItemFactory.create_attribute_value(record)


@router.delete("/item/attribute", status_code=204)
async def delete_attribute(attribute_id: int) -> None:
    query = delete(
        AttributeRecord
    ).where(AttributeRecord.id == attribute_id)
    await execute_safely(query)


@router.delete("/item/attribute-value", status_code=204)
async def delete_attribute_value(value_id: int) -> None:
    query = delete(
        AttributeValueRecord
    ).where(AttributeValueRecord.id == value_id)
    await execute_safely(query)


@router.delete("/item", status_code=204)
async def delete_item(item_id: int) -> None:
    query = delete(
        AttributeValueRecord
    ).where(AttributeValueRecord.item_id == item_id)
    await execute_safely(query)


@router.patch("/item/add-attribute", status_code=201)
async def add_attribute(attribute: ItemAttribute) -> ItemAttribute:
    record = AttributeRecord(
        name=attribute.name,
        item_type=attribute.type_id
    )
    await add_object(record)

    record = await select_last_inserted_attr(attribute.name, attribute.type_id)
    return ItemFactory.create_attribute(record)


@router.patch("/item/add-attribute-value", status_code=201)
async def add_attribute_value(value: ItemAttributeValue) -> ItemAttributeValue:
    record = AttributeValueRecord(
        attribute=value.attribute,
        value=value.value,
        item_id=value.item_id
    )
    await add_object(record)

    record = await select_last_inserted_value(
        attribute=value.attribute,
        item_id=value.item_id
    )
    return ItemFactory.create_attribute_value(record)


@router.get("/item")
async def get_item(item_id: int) -> SingleItem:
    records = await select_item(item_id)
    item = SingleItem()

    if records is None or len(records) == 0:
        raise HTTPException(status_code=404, detail="Item Not Found")

    for record in records:
        value = record[0]
        attribute = record[1]

        item.values[value.attribute] = ItemFactory.create_attribute_value(
            value
        )
        item.attributes[attribute.id] = ItemFactory.create_attribute(
            attribute
        )

    return item
