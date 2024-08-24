import asyncio
from typing import Annotated, List

from fastapi import APIRouter, Security, HTTPException
from sqlalchemy import update, and_, select

from src.crud.models import VendorRecord, VendorUserRecord, PermissionRecord, ListingsRecord, TypeRecord
from src.crud.queries.items import select_vendor_rights
from src.crud.queries.vendor import select_vendor, select_vendor_by_id, select_vendor_listings
from src.crud.utils import add_object, execute_safely, scalars_selection, scalar_selection
from src.endpoints.v0.vendors.listings import router as listings
from src.schema.factrories.vendor import VendorFactory
from src.schema.users import User
from src.schema.vendor import Vendor, VendorListing
from src.security.security import get_current_active_user
from src.utils.utils import check_admin

router = APIRouter(prefix="/vendors", tags=["Vendors"])
router.include_router(listings)


async def _get_vendor(vendor_id: int) -> Vendor:
    record = await scalar_selection(
        select(
            VendorRecord
        ).where(
            VendorRecord.id == vendor_id
        )
    )
    if not record:
        raise HTTPException(404, "Vendor not found")
    return VendorFactory.create_vendor(record)


@router.post("/vendor", status_code=201)
async def create_vendor(
        current_user: Annotated[
            User, Security(get_current_active_user, scopes=[])
        ],
        vendor: Vendor
) -> Vendor:
    record = VendorRecord(
        name=vendor.name,
        email=vendor.email,
        location=vendor.location,
        super_admin=current_user.id
    )
    await add_object(record)

    new_record = await select_vendor(vendor.name)
    return VendorFactory.create_vendor(new_record)


# @router.post("/vendor/approve", status_code=201)
# async def approve_vendor(
#         current_user: Annotated[
#             User, Security(get_current_active_user, scopes=[])
#         ],
#         vendor: int
# ) -> Vendor:
#     check_admin(current_user)
#     query = update(
#         VendorRecord
#     ).values(
#         status="ENABLED"
#     ).where(
#         and_(
#             VendorRecord.id == vendor,
#             VendorRecord.status == "REQUESTED"
#         )
#     )
#     await execute_safely(query)
#
#     new_record = await select_vendor_by_id(vendor)
#     return VendorFactory.create_vendor(new_record)


@router.get("/vendors")
async def get_vendors() -> List[Vendor]:
    records = await scalars_selection(
        select(
            VendorRecord
        )
    )

    if not records:
        return []

    return [
        VendorFactory.create_vendor(record) for record in records
    ]


async def _get_my_vendors(current_user: int):
    super_vendor_query = select(
        VendorRecord
    ).where(
        VendorRecord.super_admin == current_user
    )
    ordinary_vendor_query = select(
        VendorRecord
    ).join(
        VendorUserRecord,
        VendorRecord.id == VendorUserRecord.vendor_id
    ).where(
        VendorUserRecord.user_id == current_user
    )
    super_records, ordinary_records = await asyncio.gather(
        scalars_selection(super_vendor_query),
        scalars_selection(ordinary_vendor_query),
    )
    vendors = [
        VendorFactory.create_vendor(
            record
        ) for record in super_records
    ]
    vendors.extend([
        VendorFactory.create_vendor(
            record
        ) for record in ordinary_records
    ])
    return vendors


@router.get("/vendors/me")
async def get_my_vendors(
        current_user: Annotated[
            User, Security(get_current_active_user, scopes=[])
        ],
) -> List[Vendor]:
    return await _get_my_vendors(current_user.id)


async def does_user_have_vendor_rights(
        current_user: int,
        vendor_id: int,
        rights: str
):
    _vendors = await _get_my_vendors(current_user)

    vendor: Vendor | None = None

    for _vendor in _vendors:
        if _vendor.id == vendor_id:
            vendor = _vendor

    if not vendor:
        raise HTTPException(404, "Vendor not found for user")

    permission_records: List[PermissionRecord] = await select_vendor_rights(
        vendor_id, current_user
    )

    permission_here = False
    for permission_record in permission_records:
        if permission_record.name == rights:
            permission_here = True
            return

    if not permission_here:
        raise HTTPException(401, "Permission denied")


@router.get("/vendor/listings")
async def get_vendor_listings(
    vendor_id: int
) -> List[VendorListing]:

    # await does_user_have_vendor_rights(
    #     current_user=current_user.id,
    #     vendor_id=vendor_id,
    #     rights="read:listings"
    # )

    records = await select_vendor_listings(vendor_id)
    _listings: List[VendorListing] = []
    for row in records:
        listing_record: ListingsRecord = row[0]
        type_record: TypeRecord = row[1]

        listing = VendorListing(
            item_details=type_record.name,
            item_id=listing_record.item
        )
        _listings.append(listing)

    return _listings


@router.patch("/vendor/status", status_code=201)
async def update_vendor_status(
        current_user: Annotated[
            User, Security(get_current_active_user, scopes=[])
        ],
        vendor: Vendor
) -> Vendor:
    check_admin(current_user)
    query = update(
        VendorRecord
    ).values(
        status=vendor.status
    ).where(
        VendorRecord.id == vendor.id
    )
    await execute_safely(query)

    return await _get_vendor(vendor.id)


@router.patch("/vendor/me", status_code=201)
async def update_my_vendor(
        current_user: Annotated[
            User, Security(get_current_active_user, scopes=[])
        ],
        vendor: Vendor
):
    # todo check vendor permissions
    query = update(
        VendorRecord
    ).values(
        name=vendor.name,
        email=vendor.email,
        location=vendor.location,
        super_admin=vendor.super_admin
    ).where(
        VendorRecord.id == vendor.id
    )
    await execute_safely(query)

    return await _get_vendor(vendor.id)


@router.patch("/vendor", status_code=201)
async def update_vendor(
        current_user: Annotated[
            User, Security(get_current_active_user, scopes=[])
        ],
        vendor: Vendor
):
    check_admin(current_user)
    # todo check vendor permissions

    query = update(
        VendorRecord
    ).values(
        name=vendor.name,
        email=vendor.email,
        location=vendor.location,
        super_admin=vendor.super_admin,
        status=vendor.status
    ).where(
        VendorRecord.id == vendor.id
    )

    await execute_safely(query)
    return await _get_vendor(vendor.id)
