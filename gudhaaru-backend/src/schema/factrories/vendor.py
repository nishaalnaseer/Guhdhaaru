from typing import List

from src.schema.vendor import Listing, Vendor


class VendorFactory:
    @staticmethod
    def create_vendor(record) -> Vendor:
        return Vendor(
            id=record.id,
            name=record.name,
            email=record.email,
            location=record.location,
            status=record.status
        )

    @staticmethod
    def create_escrow(record) -> Listing:
        escrow_record = record[0]
        vendor_record = record[1]

        return Listing(
            id=escrow_record.id,
            item_id=escrow_record.item,
            vendor=VendorFactory.create_vendor(vendor_record),
        )

    @staticmethod
    def create_listings(records) -> List[Listing]:
        return [
            VendorFactory.create_escrow(record) for record in records
        ]
