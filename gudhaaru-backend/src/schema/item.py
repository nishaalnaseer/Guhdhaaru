import json
from typing import List, Tuple, Dict, Any

from pydantic import BaseModel


class Category(BaseModel):
    id: int
    name: str
    parent_id: int | None = None
    parent: BaseModel | None = None
    children_tree: Dict[int, Any] | None = {}
    type_tree: Dict[int, Any] | None = {}

    def add_child(self, child: Any) -> None:
        self.children_tree.update({child.id: child})

    def add_type(self, child: Any) -> None:
        self.type_tree.update({child.id: child})


class ItemType(BaseModel):
    id: int
    name: str
    category_id: int
    parent_id: int | None = None
    leaf_node: bool
    category: Category | None = None
    parent: BaseModel | None = None
    children: Dict[int, BaseModel] | None = {}


class ItemAttributeValue(BaseModel):
    id: int
    attribute: int
    value: str


class ItemAttribute(BaseModel):
    id: int
    name: str
    type_id: int
    value: ItemAttributeValue | None = None


class Item(BaseModel):
    id: int
    attributes: Dict[str, ItemAttribute]


class HomePage(BaseModel):
    types: List[ItemType]
    categories: List[Category]


class LeafNode(BaseModel):
    items: Dict[int,  Item]
    item_type: ItemType
