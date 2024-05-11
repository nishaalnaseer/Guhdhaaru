from fastapi import APIRouter

from src.crud.models import EscrowRecord
from src.crud.utils import add_object
from src.schema.vendor import Escrow

router = APIRouter(prefix="/escrows")


@router.post("/escrow", status_code=201)
async def create_escrow(escrow: Escrow):
    record = EscrowRecord(
        id=escrow.id,
        vendor_id=escrow.vendor.vendorid,
        item=escrow.item.id
    )
    await add_object(record)

    new_record = await select_escrow(item_id, vendor_id)
    return VendorFactory.create_escrow(new_record)
