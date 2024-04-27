from sqlalchemy import select, and_

from src.crud.engine import async_session
from src.crud.models import CategoryRecord


async def select_category_by_name(name: str, parent: str | None):
    query = select(
        CategoryRecord
    ).where(
        and_(
            CategoryRecord.name == name,
            CategoryRecord.parent == parent
        )
    )
    async with async_session() as session:
        async with session.begin():

            result = await session.execute(query)
            return result.scalar()
