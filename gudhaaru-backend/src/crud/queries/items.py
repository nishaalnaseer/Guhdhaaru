from sqlalchemy import select, and_

from src.crud.engine import async_session
from src.crud.models import CategoryRecord, TypeRecord
from src.crud.utils import scalar_selection


async def select_category_by_name(name: str, parent: int):
    query = select(
        CategoryRecord
    ).where(
        and_(
            CategoryRecord.name == name,
            CategoryRecord.parent == parent
        )
    )
    return await scalar_selection(query)


async def select_category_by_id(cat_id: int):
    query = select(
        CategoryRecord
    ).where(
        CategoryRecord.id == cat_id
    )
    return await scalar_selection(query)


async def select_last_inserted_type(name: str, parent: int, category: int):
    query = select(
        TypeRecord
    ).where(
        and_(
            TypeRecord.name == name,
            TypeRecord.parent == parent,
            TypeRecord.category == category
        )
    )
    return await scalar_selection(query)


async def select_type_by_id(type_id: int):
    query = select(
        TypeRecord
    ).where(
        TypeRecord.id == type_id
    )
    return await scalar_selection(query)


async def select_attributes(item_type_id: int):
    query = select()
