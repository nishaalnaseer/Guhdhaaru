from typing import List

from fastapi import APIRouter, HTTPException

from src.crud.models import ItemRecord, AttributeRecord
from src.crud.utils import add_objects
from src.endpoints.items.category import router as categories
from src.endpoints.items.item_types import router as item_types
from src.schema.item import Item, ItemAttribute

router = APIRouter(prefix="/items", tags=["Items"])
router.include_router(categories)
router.include_router(item_types)


@router.post("/item/attributes", status_code=204)
async def create_attributes(attributes: List[ItemAttribute]):
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
        if type_id == attribute.type_id:
            raise HTTPException(
                status_code=422,
                detail="Type ID must be the same for all attributes"
            )

    await add_objects(records)
