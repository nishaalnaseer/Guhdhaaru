from fastapi import APIRouter

from src.crud.models import CategoryRecord
from src.crud.queries.items import select_category_by_name
from src.crud.utils import add_object
from src.schema.factrories.items import ItemFactory
from src.schema.item import Category

router = APIRouter(prefix="/categories", tags=["Categories"])


@router.post("/category", status_code=201, tags=["Unfinished"])
async def create_category(category: Category):
    record = CategoryRecord(
        name=category.name,
        parent=category.parent,
    )
    await add_object(record)

    _record = await select_category_by_name(category.name, category.parent)
    return ItemFactory.create_category(_record)
