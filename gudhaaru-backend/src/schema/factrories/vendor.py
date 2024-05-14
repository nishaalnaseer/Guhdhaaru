from typing import List

from src.schema.vendor import Escrow, Vendor


class VendorFactory:
    @staticmethod
    def create_vendor(record) -> Vendor:
        return Vendor(
            id=record.id,
            name=record.name,
            email=record.email,
            location=record.location
        )

    @staticmethod
    def create_escrow(record) -> Escrow:
        escrow_record = record[0]
        vendor_record = record[1]

        return Escrow(
            id=escrow_record.id,
            item_id=escrow_record.item,
            vendor=VendorFactory.create_vendor(vendor_record),
        )

    @staticmethod
    def create_escrows(records) -> List[Escrow]:
        return [
            VendorFactory.create_escrow(record) for record in records
        ]
