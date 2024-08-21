from typing import List, Annotated
from fastapi import APIRouter, Security
from src.crud.models import ListingsRecord
from src.crud.queries.vendor import select_listings_by_item_id, select_listings
from src.crud.utils import add_object
from src.schema.factrories.vendor import VendorFactory
from src.schema.users import User
from src.schema.vendor import Listing
from src.security.security import get_current_active_user

router = APIRouter(prefix="/listings")


@router.post("/listing", status_code=201)
async def create_listing(
        current_user: Annotated[
            User, Security(get_current_active_user, scopes=[])
        ],
        escrow: Listing
):
    # todo apply security check if this user should have access to this vendor
    record = ListingsRecord(
        id=escrow.id,
        vendor_id=escrow.get_vendor_id(),
        item=escrow.item_id
    )
    await add_object(record)

    new_record = await select_listings_by_item_id(escrow.item_id, escrow.vendor)
    return VendorFactory.create_escrow(new_record)


@router.get("/listings")
async def get_listings(item_id: int) -> List[Listing]:
    records = await select_listings(item_id)
    return VendorFactory.create_listings(records)
