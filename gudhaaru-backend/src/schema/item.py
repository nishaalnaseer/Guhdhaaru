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
    category: Category | None = None


class ItemAttributeTemplate(BaseModel):
    id: int
    name: str
    item_id: int


class Attribute(BaseModel):
    id: int
    attribute_template: int
    value: str


class Item(BaseModel):
    id: int
    name: str
    item_type: ItemType
    attributes: List[Tuple[ItemAttributeTemplate, Attribute]]
