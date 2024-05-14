from fastapi import APIRouter

from src.crud.models import EscrowRecord
from src.crud.queries.vendor import select_escrow_by_item_id, select_escrows
from src.crud.utils import add_object
from src.schema.factrories.vendor import VendorFactory
from src.schema.vendor import Escrow

router = APIRouter(prefix="/escrows")


@router.post("/escrow", status_code=201)
async def create_escrow(escrow: Escrow):
    record = EscrowRecord(
        id=escrow.id,
        vendor_id=escrow.get_vendor_id(),
        item=escrow.item_id
    )
    await add_object(record)

    new_record = await select_escrow_by_item_id(escrow.item_id, escrow.vendor)
    return VendorFactory.create_escrow(new_record)


@router.get("/escrows")
async def get_escrows(item_id: int):
    records = await select_escrows(item_id)
    return VendorFactory.create_escrows(records)
