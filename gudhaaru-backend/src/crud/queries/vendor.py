from sqlalchemy import select, and_

from src.crud.models import VendorRecord, ListingsRecord, AttributeValueRecord
from src.crud.utils import scalar_selection, scalars_selection, all_selection, fetch_one


async def select_vendor(name: str):
    query = select(
        VendorRecord
    ).where(
        VendorRecord.name == name
    )
    return await scalar_selection(query)


async def select_listings(item_id: int):
    query = select(
        ListingsRecord, VendorRecord
    ).join(
        VendorRecord, VendorRecord.id == ListingsRecord.vendor_id
    ).where(ListingsRecord.item == item_id)
    return await all_selection(query)


async def select_listings_by_item_id(item_id: int, vendor_id: int):
    query = select(
        ListingsRecord, VendorRecord
    ).join(
        VendorRecord, VendorRecord.id == vendor_id
    ).where(
        and_(
            ListingsRecord.vendor_id == vendor_id,
            ListingsRecord.item == item_id
        )
    )
    return await fetch_one(query)
