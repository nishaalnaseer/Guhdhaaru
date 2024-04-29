from typing import List
from fastapi import APIRouter, HTTPException
from src.crud.models import AttributeRecord, AttributeValueRecord
from src.crud.queries.items import (
    select_attributes, select_attribute2, select_item_by_id
)
from src.crud.raw_sql import get_new_item_id
from src.crud.utils import add_objects, select_query_scalar
from src.endpoints.items.category import router as categories
from src.endpoints.items.item_types import router as item_types
from src.schema.factrories.items import ItemFactory
from src.schema.item import ItemAttribute, ItemAttributeValue

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
