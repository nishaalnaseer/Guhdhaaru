import json
from typing import List, Tuple, Dict, Any

from pydantic import BaseModel


class Category(BaseModel):
    id: int
    name: str
    parent: int | None = None
    parent_: BaseModel | None = None
    children_tree: Dict[int, Any] = {}
    type_tree: Dict[int, Any] = {}

    def add_child(self, child: Any) -> None:
        self.children_tree.update({child.id: child})

    def add_type(self, child: Any) -> None:
        self.type_tree.update({child.id: child})


class ItemType(BaseModel):
    id: int
    name: str
    parent: int | None = None
    category: Category | None | int = None
    parent_: BaseModel | None = None
    children: Dict[int, BaseModel] | None = {}


class ItemAttribute(BaseModel):
    id: int
    name: str
    type_id: int


class ItemAttributeValue(BaseModel):
    id: int
    attribute: int
    value: str


class Item(BaseModel):
    id: int
    attributes: List[
        List[ItemAttribute | ItemAttributeValue,]
    ]


class HomePage(BaseModel):
    types: List[ItemType]
    categories: List[Category]
