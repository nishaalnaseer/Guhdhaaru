from typing import List, Dict
from pydantic import BaseModel, EmailStr

from src.schema.item import Item, ItemAttributeValue, ItemAttribute, SingleItem
from src.schema.users import User


class Vendor(BaseModel):
    id: int
    name: str
    email: EmailStr
    location: str
    users: List[User] | None = None


class Listing(BaseModel):
    id: int
    item_id: int
    vendor: int | Vendor

    def get_vendor_id(self) -> int:
        if type(self.vendor) is int:
            return self.vendor
        else:
            return self.vendor.id


class ListingsPage(BaseModel):
    listings: List[Listing]
    item: SingleItem


class Permission(BaseModel):
    id: int
    name: str

