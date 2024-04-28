from typing import List, Tuple

from pydantic import BaseModel


class Category(BaseModel):
    id: int
    name: str
    parent: int | None = None


class ItemType(BaseModel):
    id: int
    name: str
    parent: int | None = None
    category: Category | None | int = None


class ItemAttribute(BaseModel):
    id: int
    name: str
    type_id: int


class ItemAttributeValue(BaseModel):
    id: int
    attribute: int
    value: str
