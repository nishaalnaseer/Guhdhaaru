from src.schema.vendor import Vendor


class VendorFactory:
    @staticmethod
    def create_vendor(record) -> Vendor:
        return Vendor(
            id=record.id,
            name=record.name,
            email=record.email,
            location=record.location
        )
