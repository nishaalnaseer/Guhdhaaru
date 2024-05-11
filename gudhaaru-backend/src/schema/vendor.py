from typing import List
from pydantic import BaseModel, EmailStr

from src.schema.item import Item
from src.schema.users import User


class Vendor(BaseModel):
    id: int
    name: str
    email: EmailStr
    location: str
    users: List[User] | None = None


class Escrow(BaseModel):
    id: int
    item: Item
    vendor: Vendor
