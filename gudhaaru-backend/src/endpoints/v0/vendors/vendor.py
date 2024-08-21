from typing import Annotated, List

from fastapi import APIRouter, Security
from sqlalchemy import update, and_, select

from src.crud.models import VendorRecord
from src.crud.queries.vendor import select_vendor, select_vendor_by_id
from src.crud.utils import add_object, execute_safely, scalars_selection
from src.schema.factrories.vendor import VendorFactory
from src.schema.users import User
from src.schema.vendor import Vendor
from src.endpoints.v0.vendors.listings import router as listings
from src.security.security import get_current_active_user
from src.utils.utils import check_admin

router = APIRouter(prefix="/vendors", tags=["Vendors"])
router.include_router(listings)


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
        super_user=current_user.id
    )
    await add_object(record)

    new_record = await select_vendor(vendor.name)
    return VendorFactory.create_vendor(new_record)


@router.post("/vendor/approve", status_code=201)
async def approve_vendor(
        current_user: Annotated[
            User, Security(get_current_active_user, scopes=[])
        ],
        vendor: int
) -> Vendor:
    check_admin(current_user)
    query = update(
        VendorRecord
    ).values(
        status="ENABLED"
    ).where(
        and_(
            VendorRecord.id == vendor,
            VendorRecord.status == "REQUESTED"
        )
    )
    await execute_safely(query)

    new_record = await select_vendor_by_id(vendor)
    return VendorFactory.create_vendor(new_record)


@router.get("/vendors")
async def get_vendors() -> List[Vendor]:
    query = select(
        VendorRecord
    )

    return await scalars_selection(query)
