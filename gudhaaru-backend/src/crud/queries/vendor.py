from sqlalchemy import select, and_

from src.crud.models import VendorRecord, ListingsRecord, AttributeValueRecord, AttributeRecord, TypeRecord
from src.crud.utils import scalar_selection, scalars_selection, all_selection, fetch_one


async def select_vendor(name: str):
    query = select(
        VendorRecord
    ).where(
        VendorRecord.name == name
    )
    return await scalar_selection(query)


async def select_vendor_by_id(vendor: int):
    query = select(
        VendorRecord
    ).where(
        VendorRecord.id == vendor
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


async def select_vendor_listings(vendor_id: int):
    query = select(
        ListingsRecord, TypeRecord
    ).join(
        AttributeValueRecord, AttributeValueRecord.item_id == ListingsRecord.item
    ).join(
        AttributeRecord, AttributeRecord.id == AttributeValueRecord.attribute
    ).join(
        TypeRecord, AttributeRecord.item_type == TypeRecord.id
    ).where(
        ListingsRecord.vendor_id == vendor_id
    ).distinct()

    return await all_selection(query)
