from typing import List

from fastapi import APIRouter, HTTPException

from src.crud.models import ItemRecord, AttributeRecord, AttributeValueRecord
from src.crud.queries.items import select_attributes, select_attribute2
from src.crud.utils import add_objects
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
    if len(values) != 0:
        raise HTTPException(422, "No attributes")

    _records = await select_attribute2(values[0].attribute)
    if len(_records) != 0:
        raise HTTPException(
            422, "Attribute not found"
        )

    type_id = _records[0].type_id
    for _record in _records:
        if type_id != _record.type_id:
            raise HTTPException(
                status_code=422,
                detail="Type ID must be the same for all Values"
            )

    records = [
        AttributeValueRecord(
            attribute=value.attribute,
            value=value.value,
        ) for value in values
    ]

    await add_objects(records)
