from sqlalchemy import select

from src.crud.models import VendorRecord
from src.crud.utils import scalar_selection


async def select_vendor(name: str):
    query = select(
        VendorRecord
    ).where(
        VendorRecord.name == name
    )
    return await scalar_selection(query)
