from fastapi import APIRouter

from src.crud.models import VendorRecord
from src.crud.queries.vendor import select_vendor
from src.crud.utils import add_object
from src.schema.factrories.vendor import VendorFactory
from src.schema.vendor import Vendor
from src.endpoints.vendors.escrows import router as escrows


router = APIRouter(prefix="/vendors")
router.include_router(escrows)


@router.post("/vendor", status_code=201)
async def create_vendor(vendor: Vendor) -> Vendor:
    record = VendorRecord(
        name=vendor.name,
        email=vendor.email,
        location=vendor.location
    )
    await add_object(record)

    new_record = await select_vendor(vendor.name)
    return VendorFactory.create_vendor(new_record)
