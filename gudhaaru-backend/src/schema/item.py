from typing import List

from pydantic import BaseModel


class Category(BaseModel):
    id: int
    name: str
    parent: int | None


class ItemType(BaseModel):
    id: int
    name: str
    parent: int | None
    category: Category | None


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
    attributes: List[List[ItemAttributeTemplate, Attribute]]






