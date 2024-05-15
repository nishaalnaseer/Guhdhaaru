from fastapi import APIRouter, HTTPException
from sqlalchemy import update, delete

from src.crud.models import CategoryRecord
from src.crud.queries.items import select_category_by_name, select_category_by_id
from src.crud.utils import add_object, execute_safely
from src.schema.factrories.items import ItemFactory
from src.schema.item import Category

router = APIRouter(prefix="/categories", tags=["Categories"])


@router.post("/category", status_code=201)
async def create_category(category: Category) -> Category:
    if category.parent_id is None:
        parent = 1
    else:
        parent = category.parent_id

    record = CategoryRecord(
        name=category.name,
        parent=parent,
    )
    await add_object(record)

    _record = await select_category_by_name(category.name, parent)
    return ItemFactory.create_category(_record)


@router.patch("/category", status_code=201)
async def update_category(category: Category) -> Category:
    if category.parent_id is None:
        parent = 1
    else:
        parent = category.parent_id

    query = update(
        CategoryRecord
    ).values(
        name=category.name,
        parent=parent
    ).where(CategoryRecord.id == category.id)
    await execute_safely(query)

    _record = await select_category_by_id(category.id)

    if _record is None:
        raise HTTPException(404, "Category not found")

    return ItemFactory.create_category(_record)


@router.delete("/category", status_code=204)
async def delete_category(category_id: int) -> None:
    if category_id == 1:
        raise HTTPException(
            403,
            "Forbidden to delete a root node"
        )

    query = delete(
        CategoryRecord
    ).where(CategoryRecord.id == category_id)
    await execute_safely(query)
